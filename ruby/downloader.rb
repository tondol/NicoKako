#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require_relative 'NicoVideo/nico'
require_relative 'base'

class NicovideoDownloader
  def initialize
    Model::connect
    @config = Model::config
    @lives = Model::Lives.new
    @videos = Model::Videos.new
    @logs = Model::Logs.new
  end

  def download_video(params)
    tc_url = params[:url].to_s
    page_url = "http://live.nicovideo.jp/watch/#{params[:live_id]}"
    swf_url = "http://live.nicovideo.jp/nicoliveplayer.swf?131118162200"
    flash_ver = %q{"WIN 11,6,602,180"}
    app = params[:url].path.reverse.chop.reverse

    resume = ""
    filename = params[:filename]
    filepath = @config["contents_dir"] + filename

    50.times {|i|
      system("rtmpdump" +
        " -l 0" +
        " -n #{params[:url].host}" +
        " -t #{tc_url}" +
        " -p #{page_url}" +
        " -s #{swf_url}" +
        " -f #{flash_ver}" +
        " -a #{app}" +
        " -y #{params[:playpath]}" +
        " -C S:#{params[:ticket]}" +
        " -o #{filepath}" +
        " #{resume}")
      resume = "-e"
      break if $?.exitstatus != 2
      sleep 1
    }

    if $?.exitstatus == 0
      filesize = File.size(filepath)
      return filename, filesize
    else
      raise Nicovideo::UnavailableVideoError.new
    end
  end
  def download_comments_sub(params)
    lines = []
    dates = []
    retry_count = 0

    TCPSocket.open(params[:address], params[:port]) {|s|
      s.write(%|<thread thread="#{params[:thread]}"| +
        %| res_from="-1000"| +
        %| version="20061206"| +
        %| scores="1"| +
        %| when="#{params[:when]}"| +
        %| waybackkey="#{params[:wayback_key]}"| +
        %| user_id="#{params[:user_id]}"/>\0|)
      s.write(%|<ping>EOT</ping>\0|)

      loop do
        if line = s.gets("\0")
          break if line =~ %r|<ping>EOT</ping>|
          lines << line.chop
          dates << $1 if line =~ /date="([0-9]+)"/
        else
          retry_count += 1
          # 失敗したら諦める
          break if retry_count >= 5
        end
      end
    }

    [lines, dates]
  end
  def download_comments(params)
    comments = []
    end_time = params[:when]

    loop do
      puts "thread = #{params[:thread]}, when = #{params[:when]}"
      lines, dates = download_comments_sub(params)
      break if dates.empty?
      comments = lines + comments
      params[:when] = dates.first
      sleep 1
    end

    filename = "#{params[:live_id]}.xml"
    filepath = @config["contents_dir"] + filename
    File.open(filepath, "w") {|f|
      comments.each {|comment| f.puts(comment) }
    }
  end
  def download_thumbnail(params)
    thumbnail = nil
    url = params[:url]

    Net::HTTP.start(url.host, url.port) {|w|
      request = url.path
      response = w.get(request, "Cookie" => @session)
      thumbnail = response.body
    }

    filename = "#{params[:live_id]}.jpg"
    filepath = @config["contents_dir"] + filename
    File.open(filepath, "wb") {|f|
      f.write(thumbnail)
    }
  end
  def download(live)
    begin
      player_status = Nicovideo::PlayerStatus.new(@session, live["nicoLiveId"])
      params = player_status.params

      params[:contents].each {|content|
        # 既にダウンロード済みならスキップする
        filename = File.basename(content[:playpath]).sub(/\.f4v$/, ".flv")
        next if @videos.select_by_filename(filename).num_rows != 0

        filename, filesize = download_video({
          :live_id => live["nicoLiveId"],
          :url => params[:url],
          :ticket => params[:ticket],
          :filename => filename,
          :playpath => "mp4:" + content[:playpath],
        })

        @logs.d("downloader", "download/videos: #{filename}")
        @videos.insert_into(live["id"], content[:vpos], filename, filesize)
      }

      @logs.d("downloader", "download/comments: #{live["title"]}")
      download_comments({
        :live_id => live["nicoLiveId"],
        :address => params[:address],
        :port => params[:port],
        :thread => params[:thread],
        :when => params[:end_time],
        :wayback_key => player_status.wayback_key,
        :user_id => params[:user_id],
      })

      @logs.d("downloader", "download/thumbnail: #{live["title"]}")
      download_thumbnail({
        :live_id => live["nicoLiveId"],
        :url => player_status.thumbnail_url,
      })

      @logs.d("downloader", "download: #{live["title"]}")
      @lives.update_with_success(live["id"])
      sleep 30
    rescue StandardError => e
      @logs.e("downloader", "download/unavailable: #{live["title"]}")
      @logs.e("downloader", "download/unavailable: #{e.message}")
      $stderr.puts(e.backtrace)
      @lives.update_with_failure(live["id"])
    end
  end
  def main
    # logs.d("downloader", ">> run: #{Time.now}")
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"])
    @session = @nicovideo.instance_variable_get(:@session)

    begin
      @lives.select_all_not_downloaded.each_hash {|live|
        download(live)
      }
    rescue Exception => e
      @logs.e("downloader", "error: #{e.message}")
      @logs.e("downloader", "trace: #{e.backtrace}")
      $stderr.puts(e.backtrace)
    ensure
      Model::close
    end
  end
end

NicovideoDownloader.new.main

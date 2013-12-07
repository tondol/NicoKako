#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql'
require 'yaml'

require_relative 'NicoVideo/nico'
require_relative 'base'

class NicovideoDownloader
  def initialize
    Model::connect
    @config = Model::config
    @lives = Model::Lives.new
    @logs = Model::Logs.new
  end

  def get_player_status(live_id)
    Net::HTTP.start("ow.live.nicovideo.jp", 80) {|w|
      request = "/api/getplayerstatus?v=" + live_id
      response = w.get(request, 'Cookie' => @session)
      status = response.body
      raise Nicovideo::UnavailableVideoError.new if status.include?("<code>closed</code>")

      params = {}
      params[:url] = $1 if status =~ %r|<url>([./0-9:A-Za-z_]+)</url>|
      params[:playpath] = "mp4:" + $1 if status =~ %r|(/content/[0-9]{8}/[0-9A-Za-z_]+.f4v)|
      params[:ticket] = $1 if status =~ %r|<ticket>([0-9:A-Za-z]+)</ticket>|
      params[:user_id] = $1 if status =~ %r|<user_id>([0-9]+)</user_id>|
      params[:address] = $1 if status =~ %r|<addr>([.0-9A-Za-z]+)</addr>|
      params[:port] = $1 if status =~ %r|<port>([0-9]+)</port>|
      params[:thread] = $1 if status =~ %r|<thread>([0-9]+)</thread>|
      params[:end_time] = $1 if status =~ %r|<end_time>([0-9]+)</end_time>|
      return params
    }
  end
  def get_wayback_key(thread)
    Net::HTTP.start("watch.live.nicovideo.jp", 80) {|w|
      request = "/api/getwaybackkey?thread=" + thread
      response = w.get(request, 'Cookie' => @session)
      return $1 if response.body =~ /^waybackkey=([-.0-9A-Za-z]+)$/
    }
  end
  def get_thumbnail_url(live_id)
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/gate/" + live_id
      response = w.get(request, 'Cookie' => @session)
      return URI.parse($1) if response.body =~ %r|(http://live.nicovideo.jp/thumb/[0-9]+\.jpg)|
    }
  end

  def download_video(params)
    tc_url = "#{params[:url].to_s}"
    page_url = "http://live.nicovideo.jp/watch/#{params[:live_id]}"
    swf_url = "http://live.nicovideo.jp/nicoliveplayer.swf?131118162200"
    flash_ver = %q{"WIN 11,6,602,180"}
    app = params[:url].path.reverse.chop.reverse

    resume = ""
    filename = "#{params[:live_id]}.flv"
    filepath = "#{@config["contents"]}#{filename}"

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
          raise Nicovideo::UnavailableVideoError.new if retry_count >= 5
          sleep 1
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
    end

    filename = "#{params[:live_id]}.xml"
    filepath = "#{@config["contents"]}#{filename}"
    File.open(filepath, "w") {|f|
      comments.each {|comment| f.puts(comment) }
    }
  end
  def download_thumbnail(live_id)
    thumbnail = nil
    url = get_thumbnail_url(live_id)

    Net::HTTP.start(url.host, url.port) {|w|
      request = url.path
      response = w.get(request, "Cookie" => @session)
      thumbnail = response.body
    }

    filename = "#{live_id}.jpg"
    filepath = "#{@config["contents"]}#{filename}"
    File.open(filepath, "wb") {|f|
      f.write(thumbnail)
    }
  end
  def download(id, live_id, title)
    begin
      status = get_player_status(live_id)
      wayback_key = get_wayback_key(status[:thread])

      @logs.d("downloader", "download video: #{title}")
      filename, filesize = download_video({
        :live_id => live_id,
        :url => URI.parse(status[:url]),
        :playpath => status[:playpath],
        :ticket => status[:ticket],
      })

      @logs.d("downloader", "download comments: #{title}")
      download_comments({
        :live_id => live_id,
        :address => status[:address],
        :port => status[:port],
        :thread => status[:thread],
        :when => status[:end_time],
        :wayback_key => wayback_key,
        :user_id => status[:user_id],
      })
 
      @logs.d("downloader", "download thumbnail: #{title}")
      download_thumbnail(live_id)
 
      @logs.d("downloader", "modified: #{title}")
      @lives.update_with_success(filename, filesize, id)
      sleep 30
    rescue StandardError => e
      @logs.e("downloader", "unavailable: #{title}")
      @logs.e("downloader", e.message)
      @lives.update_with_failure(id)
    end
  end
  def main
    # logs.d("downloader", ">> run: #{Time.now}")
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"])
    @session = @nicovideo.instance_variable_get(:@session)

    begin
      @lives.select.each_hash {|row|
        download(row["id"], row["nicoLiveId"], row["title"])
      }
    rescue Exception => e
      @logs.e("downloader", "an unexpected error has occurred")
      @logs.e("downloader", e.message)
    ensure
      Model::close
    end
  end
end

NicovideoDownloader.new.main

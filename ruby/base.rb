#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql'
require 'yaml'
require 'nokogiri'

require_relative 'NicoVideo/nico'

module Model
  def self.connect
    config = load_config
    @@db = Mysql::new(config["db"]["host"],
      config["db"]["user"],
      config["db"]["password"],
      config["db"]["database"])
  end
  def self.close
    @@db.close
  end
  def self.load_config
    config_dir = File.dirname(File.dirname(__FILE__))
    YAML.load_file(config_dir + '/config.yml')
  end
  def self.save_config(config)
    config_dir = File.dirname(File.dirname(__FILE__))
    File.write(config_dir + '/config.yml', config.to_yaml)
  end
  def self.db
    @@db
  end
  def self.db_time_to_time(t)
    return nil unless t
    Time.local(t.year, t.mon, t.day, t.hour, t.min, t.sec)
  end

  class Lives
    def initialize
      @db = Model::db
    end
    def select(id)
      statement = @db.prepare("SELECT * FROM `lives`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
    def select_all_not_downloaded
      # ダウンロード対象の動画を取得する
      statement = @db.prepare("SELECT * FROM `lives`" +
        " WHERE `downloadedAt` IS NULL AND `deletedAt` IS NULL" +
        " ORDER BY `createdAt` ASC")
      statement.execute
    end
    def update_with_success(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `downloadedAt` = ?" +
        " WHERE `id` = ?")
      statement.execute(Time.now, id)
    end
    def update_with_failure(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `retryCount` = `retryCount` + 1" +
        " WHERE `id` = ?")
      statement.execute(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `deletedAt` = ?" +
        " WHERE `id` = ? AND `retryCount` >= 3")
      statement.execute(Time.now, id)
    end
    def delete(id)
      statement = @db.prepare("DELETE FROM `lives`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
  end

  class Videos
    def initialize
      @db = Model::db
    end
    def select(id)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
    def select_by_filename(filename)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `filename` = ?")
      statement.execute(filename)
    end
    def select_all_by_live_id(live_id)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `liveId` = ?" +
        " ORDER BY `createdAt` ASC")
      statement.execute(live_id)
    end
    def insert_into(live_id, vpos, filename, filesize)
      statement = @db.prepare("INSERT INTO `videos`" +
        " (`liveId`, `vpos`, `filename`, `filesize`, `createdAt`, `modifiedAt`)" +
        " VALUES (?, ?, ?, ?, ?, ?)")
      statement.execute(live_id, vpos, filename, filesize, Time.now, Time.now)
    end
    def delete_by_live_id(live_id)
      statement = @db.prepare("DELETE FROM `videos`" +
        " WHERE `liveId` = ?")
      statement.execute(live_id)
    end
  end

  class Logs
    def initialize
      @db = Model::db
    end
    def d(name, message)
      $stderr.puts("Logs.d | #{name} | #{message}")
      statement = @db.prepare("INSERT INTO `logs`" +
        " (`kind`, `name`, `message`, `createdAt`)" +
        " VALUES (?, ?, ?, ?)")
      statement.execute("d", name, message, Time.now)
    end
    def e(name, message)
      $stderr.puts("Logs.e | #{name} | #{message}")
      statement = @db.prepare("INSERT INTO `logs`" +
        " (`kind`, `name`, `message`, `createdAt`)" +
        " VALUES (?, ?, ?, ?)")
      statement.execute("e", name, message, Time.now)
    end
  end
end

module Nicovideo
  class PlayerStatus
    def initialize(session, live_id)
      @session = session
      @live_id = live_id
    end
    def stream_id(document)
      stream_id = nil
      quesheet = document.xpath('//stream/quesheet')
      quesheet.xpath('que').each {|que|
        next unless que.text.start_with?("/play")
        streams = que.text.split[1].split(',')
        streams.each {|stream|
          fields = stream.split(':')
          if fields.size == 3 && fields[0] == Model::config["nv"]["quality"]
            return fields[2]
          else
            stream_id = fields.last
          end
        }
      }
      stream_id
    end
    def stream_contents(document, stream_id)
      contents = []
      quesheet = document.xpath('//stream/quesheet')
      quesheet.xpath('que').each {|que|
        next unless que.text.start_with?("/publish")
        fields = que.text.split
        if fields[1] == stream_id
          contents << {
            :vpos => que.attribute('vpos').value,
            :playpath => fields[2],
          }
        end
      }
      contents
    end
    def params
      return @params if @params
  
      Net::HTTP.start("ow.live.nicovideo.jp", 80) {|w|
        request = "/api/getplayerstatus?v=#{@live_id}"
        response = w.get(request, 'Cookie' => @session)
        status = response.body
        raise Nicovideo::UnavailableVideoError.new if status.include?("<code>closed</code>")
  
        document = Nokogiri::XML(status)
        contents = stream_contents(document, stream_id(document))
  
        @params = {}
        @params[:url] = URI.parse(document.xpath('//rtmp/url').text)
        @params[:ticket] = document.xpath('//rtmp/ticket').text
        @params[:user_id] = document.xpath('//user/user_id').text
        @params[:address] = document.xpath('//ms/addr').text
        @params[:port] = document.xpath('//ms/port').text
        @params[:thread] = document.xpath('//ms/thread').text
        @params[:contents] = contents
        @params[:end_time] = document.xpath('//stream/end_time').text
      }
  
      @params
    end
    def wayback_key
      Net::HTTP.start("watch.live.nicovideo.jp", 80) {|w|
        request = "/api/getwaybackkey?thread=" + params[:thread]
        response = w.get(request, 'Cookie' => @session)
        return $1 if response.body =~ /^waybackkey=([-.0-9A-Za-z]+)$/
      }
    end
    def thumbnail_url
      Net::HTTP.start("live.nicovideo.jp", 80) {|w|
        request = "/gate/" + @live_id
        response = w.get(request, 'Cookie' => @session)
        return URI.parse($1) if response.body =~ %r|(http://live.nicovideo.jp/thumb/[0-9]+\.jpg)|
      }
    end
  end
end

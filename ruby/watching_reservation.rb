#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'json'
require 'pp'

require_relative 'NicoVideo/nico'
require_relative 'base'

class WatchingReservation
  def initialize
    Model::connect
    @config = Model::config
  end
  def get_token
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation?mode=watch_num&vid=#{@video_id}"
      response = w.get(request, 'Cookie' => @session)
      $1 if response.body =~ /(ulck_[0-9]+)/
    }
  end
  def register
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation"
      response = w.post(request, "mode=auto_register&vid=#{@video_id}&token=#{get_token}", 'Cookie' => @session)
    }
    puts({ "status" => "ok" }.to_json)
  end
  def delete
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/my?delete=timeshift&vid=#{@video_id}&confirm=#{get_token}"
      response = w.get(request, 'Cookie' => @session)
    }
    puts({ "status" => "ok" }.to_json)
  end
  def list
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation?mode=detaillist"
      response = w.get(request, 'Cookie' => @session)
      document = Nokogiri::XML(response.body)
      puts document.xpath("//reserved_item").map {|item|
        {
          "vid" => item.css("vid").text,
          "title" => item.css("title").text,
          "status" => item.css("status").text,
          "unwatch" => item.css("unwatch").text.to_i,
          "expire" => item.css("expire").text.to_i
        }
      }.to_json
    }
  end
  def main
    # logs.d("downloader", ">> run: #{Time.now}")
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"])
    @session = @nicovideo.instance_variable_get(:@session)
    @mode = ARGV.shift

    if @mode == "register"
      @video_id = ARGV.shift.gsub(/^lv/, '')
      register
    elsif @mode == "delete"
      @video_id = ARGV.shift.gsub(/^lv/, '')
      delete
    else
      list
    end
    Model::close
  end
end

WatchingReservation.new.main

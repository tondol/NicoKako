#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'json'
require 'pp'

require_relative 'NicoVideo/nico'
require_relative 'base'

class WatchingReservation
  def initialize
    @config = Model::load_config
  end
  def get_token
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation?mode=watch_num&vid=#{@video_id}"
      response = w.get(request, 'Cookie' => @session)
      $1 if response.body =~ /(ulck_[0-9]+)/
    }
  end
  def register
    token = get_token
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation"
      response = w.post(request, "mode=auto_register&vid=#{@video_id}&token=#{token}", 'Cookie' => @session)
      if response.body.include?("watching_reservation_completed")
        puts({ "status" => "ok" }.to_json)
      else
        puts({ "status" => "ng", "body" => response.body.force_encoding("utf-8") }.to_json)
      end
    }
  end
  def watch
    token = get_token
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/api/watchingreservation"
      response = w.post(request, "accept=true&mode=use&vid=#{@video_id}&token=#{token}", 'Cookie' => @session)
      if response.body.include?("status=\"ok\"")
        puts({ "status" => "ok" }.to_json)
      else
        puts({ "status" => "ok", "body" => response.body.force_encoding("utf-8") }.to_json)
      end
    }
  end
  def delete
    # not tested yet
    token = get_token
    Net::HTTP.start("live.nicovideo.jp", 80) {|w|
      request = "/my?delete=timeshift&vid=#{@video_id}&confirm=#{token}"
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
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"], @config["nv"]["session"])
    @session = @nicovideo.instance_variable_get(:@session)
    @config["nv"]["session"] = @session
    @mode = ARGV.shift

    if @mode == "register"
      @video_id = ARGV.shift.gsub(/^lv/, '')
      register
    elsif @mode == "watch"
      @video_id = ARGV.shift.gsub(/^lv/, '')
      watch
    elsif @mode == "delete"
      @video_id = ARGV.shift.gsub(/^lv/, '')
      delete
    else
      list
    end

    Model::save_config(@config)
  end
end

WatchingReservation.new.main

#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'open3'
require_relative 'NicoVideo/nico'
require_relative 'base'

class NicovideoCollector
  def initialize
    Model::connect
    @lives = Model::Lives.new
    @videos = Model::Videos.new
    @logs = Model::Logs.new
    @config = Model::load_config
  end

  def main
    begin
      @videos.select_all.each_hash {|v|
        unless File.exist?(@config["contents_dir"] + "/" + v["nicoLiveId"] + ".jpg")
          Net::HTTP.start("live.nicovideo.jp", 80) {|http|
            response = http.get("/watch/" + v["nicoLiveId"])
            if response.body =~ %r!http://live\.nicovideo\.jp(/thumb/\d+\.jpg)!
              response = http.get($1)
              File.write(@config["contents_dir"] + "/" + v["nicoLiveId"] + ".jpg", response.body)
            end
          }
          sleep 1
        end
      }
    rescue Exception => e
      $stderr.puts(e.message)
      $stderr.puts(e.backtrace)
    ensure
      Model::close
    end
  end
end

NicovideoCollector.new.main

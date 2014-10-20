#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql'
require 'yaml'

require_relative 'base'

class NicovideoCleaner
  def initialize
    Model::connect
    @config = Model::config
    @lives = Model::Lives.new
    @videos = Model::Videos.new
    @logs = Model::Logs.new
  end

  def clean_files(live)
    @videos.select_all_by_live_id(live["id"]).each_hash {|video|
      filename = video["filename"]
      filepath = @config["contents"] + filename
      if File.exist?(filepath)
        File.delete(filepath)
        @logs.d("cleaner", "delete/video: #{filepath}")
      end
    }

    filename = "#{live["nicoLiveId"]}.xml"
    filepath = @config["contents"] + filename
    if File.exist?(filepath)
      File.delete(filepath)
      @logs.d("cleaner", "delete/comments: #{filepath}")
    end
    filename = "#{live["nicoLiveId"]}.jpg"
    filepath = @config["contents"] + filename
    if File.exist?(filepath)
      File.delete(filepath)
      @logs.d("cleaner", "delete/thumbnail: #{filepath}")
    end
  end
  def clean(live)
    clean_files(live)
    @videos.delete_by_live_id(live["id"])
    @lives.delete(live["id"])
    @logs.d("cleaner", "delete: #{live["id"]}")
  end
  def main
    begin
      ARGV.each {|id|
        clean(@lives.select(id).each_hash.first)
      }
    rescue Exception => e
      @logs.e("cleaner", "error: #{e.message}")
      @logs.e("cleaner", "trace: #{e.backtrace}")
      $stderr.puts(e.backtrace)
    ensure
      Model::close
    end
  end
end

NicovideoCleaner.new.main

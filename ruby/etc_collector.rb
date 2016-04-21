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

  def get_db_filenames()
    @videos.select_all.each_hash.select {|video|
      !video["deletedAt"]
    }.map {|video|
      video["filename"]
    }
  end
  def get_disk_filenames()
    Dir.entries(@config["contents_dir"]).select {|entry|
      entry != "." && entry != ".."
    }
  end
  def get_disk_images()
    get_disk_filenames.select {|entry| entry.end_with?(".jpg") }
  end
  def get_disk_videos()
    get_disk_filenames.select {|entry|
      entry.end_with?(".mp4") || entry.end_with?(".flv")
    }.select {|entry|
      yield("#{@config["contents_dir"]}/#{entry}")
    }
  end
  def sync_acd()
    system("ACD_CLI_CACHE_PATH=#{@config["acd_cli_cache_path"]} " +
        "/usr/local/bin/acdcli sync")
  end
  def get_acd_filenames()
    output, _ = Open3.capture3("ACD_CLI_CACHE_PATH=#{@config["acd_cli_cache_path"]} " +
        "/usr/local/bin/acdcli ls #{@config["acd_cli_contents_dir"]}")
    return output.each_line.map {|s| s.split(" ")[2] }
  end

  def main
    begin
      sync_acd()
      # STEP1. DBとローカルの一致原則
      # DB上のファイルエントリとローカルのビデオファイルの集合が一致する
      s1 = Set.new(get_disk_videos {|e| true })
      s2 = Set.new(get_db_filenames)
      puts "-- videos on disk (include dummies) v.s. videos on DB"
      puts "only: videos on disk"
      puts (s1 - s2).to_a
      puts "only: videos on DB"
      puts (s2 - s1).to_a
      # STEP2. ローカルとACDの一致原則
      # ローカルの空のビデオファイルとACD上のビデオファイルの集合が一致する
      s1 = Set.new(get_disk_videos {|e| File.size(e) == 0 })
      s2 = Set.new(get_acd_filenames)
      puts "-- dummies on disk v.s. videos on ACD"
      puts "only: dummies on disk"
      puts (s1 - s2).to_a
      puts "only: videos on ACD"
      puts (s2 - s1).to_a
    rescue Exception => e
      $stderr.puts(e.message)
      $stderr.puts(e.backtrace)
    ensure
      Model::close
    end
  end
end

NicovideoCollector.new.main

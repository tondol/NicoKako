#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'fileutils'

require_relative 'NicoVideo/nico'
require_relative 'base'

class NicovideoCollector
  def initialize
    Model::connect
    @logs = Model::Logs.new
    @config = Model::load_config
  end

  def main
    begin
      system("ACD_CLI_CACHE_PATH=#{@config["acd_cli_cache_path"]} " +
          "/usr/local/bin/acdcli sync")
      return if $?.exitstatus != 0

      entries = Dir.entries(@config["contents_dir"]).select {|entry|
        entry != "." && entry != ".." &&
          (entry.end_with?(".mp4") || entry.end_with?(".flv")) &&
          File.size("#{@config["contents_dir"]}/#{entry}") != 0
      }.to_a
      entries.each_with_index {|entry, index|
        puts("#{index + 1}/#{entries.size}")
        system("ACD_CLI_CACHE_PATH=#{@config["acd_cli_cache_path"]} " +
            "/usr/local/bin/acdcli upload -o " +
            "#{@config["contents_dir"]}/#{entry} " +
            "#{@config["acd_cli_contents_dir"]}")
        break if $?.exitstatus != 0
        File.delete("#{@config["contents_dir"]}/#{entry}")
        FileUtils.touch("#{@config["contents_dir"]}/#{entry}")
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

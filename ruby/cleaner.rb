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
    @logs = Model::Logs.new
  end

  def clean_files(nico_live_id)
    filename = "#{nico_live_id}.flv"
    filepath = "#{@config["contents"]}#{filename}"
    if File.exist?(filepath)
      File.delete(filepath)
      @logs.d("cleaner", "delete: #{filepath}")
    end
    filename = "#{nico_live_id}.xml"
    filepath = "#{@config["contents"]}#{filename}"
    if File.exist?(filepath)
      File.delete(filepath)
      @logs.d("cleaner", "delete: #{filepath}")
    end
    filename = "#{nico_live_id}.jpg"
    filepath = "#{@config["contents"]}#{filename}"
    if File.exist?(filepath)
      File.delete(filepath)
      @logs.d("cleaner", "delete: #{filepath}")
    end
  end
  def clean(live)
    clean_files(live["nicoLiveId"])
    @lives.delete(live["id"])
    @logs.d("cleaner", "clean: #{live["id"]}")
  end
  def main
    begin
      ARGV.each {|id|
        clean(@lives.select_with_id(id).each_hash.first)
      }
    rescue Exception => e
      @logs.e("cleaner", "an unexpected error has occurred")
      @logs.e("cleaner", e.message)
      $stderr.puts(e.backtrace)
    ensure
      Model::close
    end
  end
end

NicovideoCleaner.new.main

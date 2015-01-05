#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'json'

require_relative 'NicoVideo/nico'
require_relative 'base'

class GetPlayerStatus
  def initialize
    @config = Model::load_config
  end
  def main
    # logs.d("downloader", ">> run: #{Time.now}")
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"], @config["nv"]["session"])
    @session = @nicovideo.instance_variable_get(:@session)
    @config["nv"]["session"] = @session

    @player_status = Nicovideo::PlayerStatus.new(@session, ARGV.shift)
    puts @player_status.params.to_json

    Model::save_config(@config)
  end
end

GetPlayerStatus.new.main

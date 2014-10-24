#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'json'

require_relative 'NicoVideo/nico'
require_relative 'base'

class GetPlayerStatus
  def initialize
    Model::connect
    @config = Model::config
  end
  def main
    # logs.d("downloader", ">> run: #{Time.now}")
    @nicovideo = Nicovideo.login(@config["nv"]["mail"], @config["nv"]["password"])
    @session = @nicovideo.instance_variable_get(:@session)
    @player_status = Nicovideo::PlayerStatus.new(@session, ARGV.shift)
    puts @player_status.params.to_json
    Model::close
  end
end

GetPlayerStatus.new.main

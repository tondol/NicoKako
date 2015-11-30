#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'yaml'

def get_hash(hash, key)
  keys = key.split("/")
  keys.each {|key|
    hash = hash[key]
  }
  hash
end
def set_hash(hash, key, value)
  keys = key.split("/")
  last_key = keys.pop
  keys.each {|key|
    hash = hash[key]
  }
  hash[last_key] = value
  hash
end
def prompt(key, hint, default=nil)
  default ||= get_hash(@config, key)
  puts "#{hint} (default=#{default})"
  print "\e[33m>\e[0m "
  s = gets.chomp
  set_hash(@config, key, s.empty? ? default : s)
end
def puts_header(s)
  puts "\e[32m===="
  puts s
  puts "====\e[0m"
end

puts_header("version check")
abort "NicoAnime requires Ruby 1.9 or above" if RUBY_VERSION.to_f < 1.9
puts "... done"

puts_header("bundle install")
system("cd ruby; bundle install")
puts "... done"

puts_header("configure config.yml")
Dir.chdir(File.dirname(__FILE__))
contents_dir = File.expand_path(File.dirname(__FILE__)) + "/public/contents"
@config = YAML.load_file(File.exist?("config.yml") ? "config.yml" : "config.yml.example")
prompt("nv/mail", "your email address on niconico")
prompt("nv/password", "your password on niconico account")
prompt("nv/quality", "input 'premium' or 'default'")
prompt("db/host", "the hostname of your database")
prompt("db/port", "your database port")
prompt("db/user", "the username of your database account")
prompt("db/password", "the password of your database account")
prompt("db/database", "your database name")
prompt("application_title", "application's title")
prompt("application_url", "application's url")
prompt("contents_dir", "the directory where videos are located (with NO ending '/')", contents_dir)
prompt("contents_dir_url", "the url where videos are located (with NO ending '/')")
File.write("config.yml", @config.to_yaml)
puts "... done"

puts_header("create tables")
File.write("my.cnf", "[client]\npassword = #{@config["db"]["password"]}")
system("mysql --defaults-extra-file=my.cnf" +
  " -u #{@config["db"]["user"]}" +
  " --default-character-set=utf8" +
  " #{@config["db"]["database"]} < install.sql")
File.delete("my.cnf")
puts "... done"

puts_header("make contents directory writeable")
system("chmod o+w #{@config["contents_dir"]}")
puts "... done"

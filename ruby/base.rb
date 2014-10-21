#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-

require 'mysql'
require 'yaml'

require_relative 'NicoVideo/nico'

module Model
  def self.connect
    @@db = Mysql::new(config["db"]["host"],
      config["db"]["user"],
      config["db"]["password"],
      config["db"]["database"])
  end
  def self.close
    @@db.close
  end
  def self.config
    YAML.load_file(File.dirname(File.dirname(__FILE__)) + '/config.yml')
  end
  def self.db
    @@db
  end
  def self.db_time_to_time(t)
    return nil unless t
    Time.local(t.year, t.mon, t.day, t.hour, t.min, t.sec)
  end

  class Lives
    def initialize
      @db = Model::db
    end
    def select_all
      # ダウンロード対象の動画を取得する
      statement = @db.prepare("SELECT * FROM `lives`" +
        " WHERE `downloadedAt` IS NULL AND `deletedAt` IS NULL" +
        " ORDER BY `createdAt` ASC")
      statement.execute
    end
    def select(id)
      statement = @db.prepare("SELECT * FROM `lives`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
    def update_with_success(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `downloadedAt` = ?" +
        " WHERE `id` = ?")
      statement.execute(Time.now, id)
    end
    def update_with_failure(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `retryCount` = `retryCount` + 1" +
        " WHERE `id` = ?")
      statement.execute(id)
      statement = @db.prepare("UPDATE `lives`" +
        " SET `deletedAt` = ?" +
        " WHERE `id` = ? AND `retryCount` >= 3")
      statement.execute(Time.now, id)
    end
    def delete(id)
      statement = @db.prepare("DELETE FROM `lives`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
  end

  class Videos
    def initialize
      @db = Model::db
    end
    def select(id)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `id` = ?")
      statement.execute(id)
    end
    def select_by_filename(filename)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `filename` = ?")
      statement.execute(filename)
    end
    def select_all_by_live_id(live_id)
      statement = @db.prepare("SELECT * FROM `videos`" +
        " WHERE `liveId` = ?" +
        " ORDER BY `createdAt` ASC")
      statement.execute(live_id)
    end
    def insert_into(live_id, vpos, filename, filesize)
      statement = @db.prepare("INSERT INTO `videos`" +
        " (`liveId`, `vpos`, `filename`, `filesize`, `createdAt`, `modifiedAt`)" +
        " VALUES (?, ?, ?, ?, ?, ?)")
      statement.execute(live_id, vpos, filename, filesize, Time.now, Time.now)
    end
    def delete_by_live_id(live_id)
      statement = @db.prepare("DELETE FROM `videos`" +
        " WHERE `liveId` = ?")
      statement.execute(live_id)
    end
  end

  class Logs
    def initialize
      @db = Model::db
    end
    def d(name, message)
      $stderr.puts("Logs.d | #{name} | #{message}")
      statement = @db.prepare("INSERT INTO `logs`" +
        " (`kind`, `name`, `message`, `createdAt`)" +
        " VALUES (?, ?, ?, ?)")
      statement.execute("d", name, message, Time.now)
    end
    def e(name, message)
      $stderr.puts("Logs.e | #{name} | #{message}")
      statement = @db.prepare("INSERT INTO `logs`" +
        " (`kind`, `name`, `message`, `createdAt`)" +
        " VALUES (?, ?, ?, ?)")
      statement.execute("e", name, message, Time.now)
    end
  end
end

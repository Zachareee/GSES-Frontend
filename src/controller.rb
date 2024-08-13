# frozen_string_literal: true

require 'fileutils'
require 'json'

APPDATA_FOLDER = "#{ENV['APPDATA']}/GSES-frontend"
CONFIG_FILE = "#{APPDATA_FOLDER}/games.txt"
SETTINGS_FILE = "#{APPDATA_FOLDER}/settings.txt"

# Backend
module Controller
  # Backend relating to games
  class Games
    def self.load
      return @games = JSON.parse(File.read(CONFIG_FILE)) if File.exist?(CONFIG_FILE)

      @games = []
    end

    # game = [image, game name, path]
    def self.save(gameinfo)
      @games.push(gameinfo)
    end

    def self.delete(idx)
      @games.delete_at idx unless idx.nil?
    end

    def self.run(idx)
      puts Settings.settings
      `"#{@games[idx][1]}"` unless @games[idx].nil?
    end

    def self.shutdown
      File.write CONFIG_FILE, @games.to_json
    end
  end

  # Backend relating to settings
  class Settings
    def self.settings
      load
    end

    def self.load
      return @settings unless @settings.nil?

      if File.exist?(SETTINGS_FILE)
        settings = JSON.parse(File.read(SETTINGS_FILE))
        return @settings = settings unless settings.nil?
      end

      @settings = {
        'steamclient_loader.exe' => nil,
        'steamclient.dll' => nil,
        'steamclient64.dll' => nil
      }
    end

    def self.save(key, sett)
      @settings[key] = sett
    end

    def self.shutdown
      File.write SETTINGS_FILE, @settings.to_json
    end
  end

  def self.create_home_folder
    FileUtils.mkdir_p APPDATA_FOLDER unless File.directory? APPDATA_FOLDER
  end

  def self.shutdown
    create_home_folder
    Games.shutdown
    Settings.shutdown
  end
end

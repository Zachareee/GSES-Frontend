# frozen_string_literal: true

require 'fileutils'
require 'json'

APPDATA_FOLDER = "#{ENV['APPDATA']}/GSES-frontend"
CONFIG_FILE = "#{APPDATA_FOLDER}/games.json"
SETTINGS_FILE = "#{APPDATA_FOLDER}/settings.json"

# Backend
module Controller
  # Backend relating to games
  class Games
    def self.load
      return @games = JSON.parse(File.read(CONFIG_FILE)) if File.exist?(CONFIG_FILE)

      @games = []
    end

    # game = [appid, game name, path, cmdline, image]
    def self.save(gameinfo)
      @games.push(gameinfo)
    end

    def self.delete(idx)
      @games.delete_at idx unless idx.nil?
    end

    def self.run(idx)
      return if @games[idx].nil?

      game = @games[idx]
      file = game[2]
      settings = Settings.load
      args = [
        settings['steamclient_loader.exe'],
        settings['steamclient.dll'],
        settings['steamclient64.dll'],
        file, file.gsub(/\\[^\\]*$/).each(&{}), game[3], game[0]
      ].map { |arg| "\"#{arg}\"" }.join ' '

      `#{args}`
    end

    def self.shutdown
      File.write CONFIG_FILE, @games.to_json
    end
  end

  # Backend relating to settings
  class Settings
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

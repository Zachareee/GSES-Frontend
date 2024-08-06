# frozen_string_literal: true
require 'fileutils'
require 'json'

APPDATA_FOLDER = "#{ENV['APPDATA']}/GSES-frontend"
CONFIG_FILE ="#{APPDATA_FOLDER}/games.txt"

# Backend
class Controller
  def self.load_games
    return @games = JSON.parse(File.read CONFIG_FILE) if File.exist?(CONFIG_FILE)
    @games = []
  end

  # game = [image, game name, path]
  def self.save_game(gameinfo)
    @games.push(gameinfo)
  end

  def self.delete_game idx
    @games.delete_at idx
  end

  def self.shutdown
    FileUtils.mkdir_p APPDATA_FOLDER unless File.directory? APPDATA_FOLDER
    File.write CONFIG_FILE, @games.to_json
  end

  def self.run_game idx
    `#{@games[idx][1]}`
  end
end

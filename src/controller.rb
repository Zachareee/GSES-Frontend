# frozen_string_literal: true

# Backend
class Controller
  @games = []
  def self.load_games
    @games
  end

  # game = [image, game name, path]
  def self.save_game(gameinfo)
    @games.push(gameinfo)
  end

  def self.run_game idx
    `#{@games[idx][0]}`
  end
end

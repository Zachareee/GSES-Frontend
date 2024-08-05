# frozen_string_literal: true

# Backend
class Controller
  @games = [['A game name']]
  def self.load_games
    @games
  end

  # game = [image, game name, path]
  def self.save_game(gameinfo)
    @games.push(gameinfo)
  end
end

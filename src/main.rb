# frozen_string_literal: true

require 'glimmer-dsl-libui'

require_relative './controller'

# Frontend
class GUI
  include Glimmer

  def launch
    window_menu
    window('GSES Frontend', 900, 600) do
      display_games
    end.show
  end

  def window_menu
    menu 'Games' do
      menu_item 'Add game' do
        puts 'Hi'
      end
    end
  end

  def display_games
    table do
      image_column 'Cover art'
      text_column 'Game name'

      cell_rows Controller.load_games
    end
  end
end

GUI.new.launch

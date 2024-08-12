# frozen_string_literal: true

require 'glimmer-dsl-libui'

require_relative 'controller'
require_relative 'win_api'
require_relative 'window/addgame'
require_relative 'window/settings'

menubar = {
  "File" => {
    "Add" => Proc.new { AddGame.launch },
    "Remove" => Proc.new { Controller.delete_game }
  },
  "Edit" => {
    "Settings" => Proc.new { Settings.launch }
  }
}

# Frontend
class GUI
  include Glimmer::LibUI::Application
  attr_accessor :selected

  body do
    window_menu
    window('GSES Frontend', 900, 600) do
      display_games

      on_closing do
        Controller.shutdown
        nil
      end
    end
  end

  def window_menu
    menu 'File' do
      menu_item 'Add' do
        on_clicked do
          AddGame.launch
        end
      end
      menu_item 'Remove' do
        on_clicked do
          Controller.delete_game @selected
        end
      end
    end
  end

  def display_games
    table do
      # image_column 'Cover art'
      text_column 'Game name'
      text_column 'Path'

      cell_rows Controller.load_games

      selection <=> [self, :selected]
      on_row_double_clicked do |_t, row|
        Controller.run_game row
      end
    end
  end
end

GUI.launch

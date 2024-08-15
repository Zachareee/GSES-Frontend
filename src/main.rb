# frozen_string_literal: true

require 'glimmer-dsl-libui'

require_relative 'controller'
require_relative 'win_api'
require_relative 'window/addgame'
require_relative 'window/settings'

# Frontend
class GUI
  include Glimmer::LibUI::Application
  attr_accessor :selected

  @@menubar = {
    'File' => {
      'Add' => {
        proc: proc { AddGame.launch }
      },
      'Remove' => {
        proc: proc { |idx| Controller::Games.delete idx },
        params: [:@selected]
      }
    },
    'Edit' => {
      'Settings' => {
        proc: proc { Settings.launch }
      }
    }
  }

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
    @@menubar.each do |key, value|
      menu key do
        value.each do |menuitem, action|
          menu_item menuitem do
            on_clicked do
              action[:proc].call(instance_variable_get(action[:params][0])) unless action[:params].nil?
              action[:proc].call if action[:params].nil?
            end
          end
        end
      end
    end
  end

  def display_games
    table do
      # image_column 'Cover art'
      text_column 'App ID'
      text_column 'Game name'
      text_column 'Path'
      text_column 'Command line'

      cell_rows Controller::Games.load

      on_row_double_clicked do |_t, row|
        Controller::Games.run row
      end

      selection <=> [self, :selected]
    end
  end
end

GUI.launch

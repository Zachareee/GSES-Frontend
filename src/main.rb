# frozen_string_literal: true

require 'glimmer-dsl-libui'

require_relative 'controller'
require_relative 'win_api'

# Frontend
class GUI
  include Glimmer::LibUI::Application

  body do
    window_menu
    window('GSES Frontend', 900, 600) do
      display_games
    end
  end

  def window_menu
    menu 'Games' do
      menu_item 'Add game' do
        on_clicked do
          AddGame.launch
        end
      end
    end
  end

  def display_games
    table do
      # image_column 'Cover art'
      text_column 'Game name'

      cell_rows Controller.load_games

      on_row_double_clicked do |t, row|
        Controller.run_game row
      end
    end
  end
end

# Popup window when "Add Game" is clicked
class AddGame
  include Glimmer::LibUI::Application
  include NativeDialog::Flags
  attr_accessor :file

  body do
    window('Add game', 600, 400) do |child|
      vertical_box do
        customform
        button 'Accept' do
          on_clicked do
            Controller.save_game [@file] unless @file.nil?
            child.destroy
          end
        end
      end
    end
  end

  def customform
    form do
      horizontal_box do
        file = formbox 'Filename', :file
        button 'Browse' do
          on_clicked do
            @file = browse_files
            file.text = @file unless @file.nil?
          end
        end
      end
    end
  end

  def formbox(label, varname)
    entry do
      label label
      text <=> [self, varname]
    end
  end

  def browse_files
    dialog = NativeDialog.new('Choose the exe file of the game')
                         .filters({ 'Executable files (*.exe)' => '*.exe' })
                         .flags OFN_FILEMUSTEXIST | OFN_HIDEREADONLY | OFN_PATHMUSTEXIST
    dialog.selected_file if dialog.open_file?
  end
end

GUI.launch

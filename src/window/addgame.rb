require 'glimmer-dsl-libui'

require_relative '../controller'
require_relative '../win_api'

# Popup window when "Add Game" is clicked
class AddGame
  include Glimmer::LibUI::Application
  include NativeDialog::Flags
  attr_accessor :file, :name

  body do
    window('Add game', 600, 400) do |child|
      vertical_box do
        customform
        button 'Accept' do
          on_clicked do
            Controller::Games.save [@name, @file] unless @file.nil?
            child.destroy
          end
        end
      end
    end
  end

  def customform
    form do
      formbox 'Game name', :name
      file = formbox 'Filename', :file
      horizontal_box do
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

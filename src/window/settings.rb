require 'glimmer-dsl-libui'

# The settings window
class Settings
  include Glimmer::LibUI::Application
  include NativeDialog::Flags
  attr_accessor :settings

  body do
    window('Settings', 600, 400) do |child|
      vertical_box do
        customform
        button 'Accept' do
          on_clicked do
            child.destroy
          end
        end
      end
    end
  end

  def customform
    Controller::Settings.load.each do |key, value|
      horizontal_box do
        label key
        text_field = entry do
          text value
        end
        text_field.read_only = true

        button 'Browse' do
          on_clicked do
            file = browse_files key
            unless file.nil?
              text_field.text = file
              Controller::Settings.save key, file
            end
          end
        end
      end
    end
  end

  def browse_files(file)
    dialog = NativeDialog.new("Select the #{file} file")
                         .filters({ file => file })
                         .flags OFN_FILEMUSTEXIST | OFN_HIDEREADONLY | OFN_PATHMUSTEXIST
    dialog.selected_file if dialog.open_file?
  end
end

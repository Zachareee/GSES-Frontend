# frozen_string_literal: true

require 'glimmer-dsl-libui'

# The GUI class
class GUI
  include Glimmer

  def launch
    window('GSES Frontend', 900, 600) do
      grid do
        2.times do |top_value|
          2.times do |left_value|
            create_button left_value, top_value
          end
        end
      end
    end.show
  end

  def create_button(left, top)
    button "#{left}, #{top}" do
      left left
      top top
      hexpand true
      vexpand true
      on_clicked do
        msg_box 'Information', "You clicked #{left} #{top}"
      end
    end
  end
end

GUI.new.launch

module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      moving_rect_mask = AdventureRL::Mask.new({
        position: AdventureRL::Point.new((10..50).sample, (10..434).sample),
        size: {
          width:  128,
          height: 96
        }
      })
      @moving_rect = AdventureRL::Rectangle.new moving_rect_mask, color: 0xff_0000ff
      mouse_rect_mask = AdventureRL::Mask.new({
        position: AdventureRL::Point.new(0, 0),
        size: {
          width:  64,
          height: 64
        },
        origin: {
          x: :center,
          y: :center
        }
      })
      @mouse_rect = AdventureRL::Rectangle.new mouse_rect_mask, color: 0xff_00ff00
    end

    private

    def needs_cursor?
      return true
    end

    def button_down btnid
      case btnid
      when Gosu::KB_Q, Gosu::KB_ESCAPE
        close
      end
    end

    def update
      dt = get_deltatime
      @moving_rect.move_by x: (16 * dt)
      @mouse_rect.set_position mouse_x, mouse_y
      if (@moving_rect.collides_with? @mouse_rect)
        @moving_rect.set_color 0xff_ff0000
      else
        @moving_rect.reset_color
      end

      #puts "#{get_fps} - #{get_deltatime}"
      #puts get_deltatime * get_fps
      super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
    end

    def draw
      @moving_rect.draw
      @mouse_rect.draw
    end
  end
end

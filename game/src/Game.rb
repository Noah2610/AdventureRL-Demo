module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      @rect_count   = 50
      @move_x_range = (-512..512).to_a
      @move_y_range = @move_x_range
      @move_x_speed = 96
      @move_y_speed = 96
      @size_range   = (16..48).to_a
      @colors = (0xff_000000..0xff_ffffff).to_a
      @game_running = true
      setup_rects
    end

    private

    def setup_rects
      @rects = @rect_count.times.map do |n|
        puts "Loading MASK #{n}"
        mask = AdventureRL::Mask.new({
          position: AdventureRL::Point.new(
            (0..get_size(:width)).sample, (0..get_size(:height)).sample
          ),
          size: {
            width:  @size_range.sample,
            height: @size_range.sample
          },
          origin: {
            x: :left,
            y: :top
          }
        })
        puts "Finish mask #{n}"
        puts "Loading RECT #{n}"
        rect = AdventureRL::Rectangle.new mask, color: @colors.sample
        puts "Finish rect #{n}"
        next rect
      end
      mouse_rect_mask = AdventureRL::Mask.new({
        position: AdventureRL::Point.new(0, 0),
        size: {
          width:  8,
          height: 8
        },
        origin: {
          x: :center,
          y: :center
        }
      })
      @mouse_rect = AdventureRL::Rectangle.new mouse_rect_mask, color: 0xff_00ff00
    end

    def needs_cursor?
      return true
    end

    def button_down btnid
      case btnid
      when Gosu::KB_Q, Gosu::KB_ESCAPE
        close
      when Gosu::KB_R
        reset
      end
    end

    def reset
      setup_rects
      @game_running = true
    end

    def update
      return  unless (@game_running)
      @mouse_rect.set_position mouse_x, mouse_y
      move_rects  #if (button_down? Gosu::KB_SPACE)
      check_collisions

      puts get_fps  if (get_tick % get_fps == 0)  unless (get_fps == 0)

      #puts "#{get_fps} - #{get_deltatime}"
      #puts get_deltatime * get_fps
      super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
    end

    def move_rects
      dt = get_deltatime
      @rects.each.with_index do |rect, index|
        #rect.move_by x: (@move_x_range.sample * dt), y: (@move_y_range.sample * dt)
        xincr = yincr = 0
        speed_mults = [
          1,    # 0
          1.1,  # 1
          1.25, # 2
          1.5,  # 3
          1.75, # 4
          0.9,  # 5
          0.75, # 6
          0.5,  # 7
          0.25  # 8
        ]
        xspeed = @move_x_speed * speed_mults[index % 8]
        yspeed = @move_y_speed * speed_mults[index % 8]
        case index % 4
        when 0
          xincr = xspeed * dt
          yincr = yspeed * dt
        when 1
          xincr = (xspeed * dt) * -1
          yincr = yspeed * dt
        when 2
          xincr = xspeed * dt
          yincr = (yspeed * dt) * -1
        when 3
          xincr = (xspeed * dt) * -1
          yincr = (yspeed * dt) * -1
        end
        rect.move_by x: xincr, y: yincr

        if    (rect.get_side(:right) <= get_side(:left))
          rect.move_to x: (get_side(:right) - rect.get_size(:width) - (get_side(:left) - rect.get_side(:right).abs))
        elsif (rect.get_side(:left) >= get_side(:right))
          rect.move_to x: (get_side(:left) + (get_side(:right) - rect.get_side(:left)).abs)
        end
        if    (rect.get_side(:top) >= get_side(:bottom))
          rect.move_to y: (get_side(:top) + (get_side(:bottom) - rect.get_side(:top)).abs)
        elsif (rect.get_side(:bottom) <= get_side(:top))
          rect.move_to y: (get_side(:bottom) - rect.get_size(:height) - (get_side(:top) - rect.get_side(:bottom).abs))
        end
      end
    end

    def check_collisions
      @rects.each do |rect|
        if (rect.collides_with? @mouse_rect)
          rect.set_color 0xff_ff0000
          @game_running = false
        else
          rect.reset_color
        end
      end
    end

    def draw
      @rects.each &:draw
      @mouse_rect.draw
    end
  end
end

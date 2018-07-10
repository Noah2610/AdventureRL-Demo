module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      reset_dt

      AdventureRL::Clip.root = DIR[:clips]
      AdventureRL::Clip.default_settings = DIR[:clip_configs].join('default.yml')
      AdventureRL::Audio.root = DIR[:audio]
      AdventureRL::Audio.default_settings = DIR[:audio_configs].join('default.yml')

      clip = AdventureRL::Clip.new DIR[:clip_configs].join('america.yml')

      @cplayer = AdventureRL::ClipPlayer.new({
        speed: 1,
        mask: {
          position: {
            x: 0,
            y: 0
          },
          size: {
            width:  get_size(:width),
            height: get_size(:height)
          }
        }
      })

      @cplayer.play clip
      add @cplayer

      rect = AdventureRL::Rectangle.new(
        {
          position: {
            x: 16,
            y: 16
          },
          size: {
            width: 32,
            height: 32
          },
        },
        z_index: 10,
        color: 0xff_ff0000
      )
      @layer = AdventureRL::Layer.new({
        position: {
          x: 128,
          y: 64
        },
        size: {
          width:  128,
          height: 128
        },
        origin: {
          x: :center,
          y: :center
        }
      })
      add @layer
      @layer.add rect
      add rect

      @interval_sec = 0.001
      @scale_dir = -1
      @max_scale_count = 50
      @scale_count = @max_scale_count
      @scale_step = 0.01
      set_interval seconds: @interval_sec do
        scale_by = @scale_step * @scale_dir
        increase_scale :x, scale_by
        increase_scale :y, scale_by
        @scale_count += @scale_dir
        @scale_dir *= -1  if ([0, @max_scale_count].include?(@scale_count))
      end

      @move_axis = :x
      @move_dir = 1
      @max_move_count = 100
      @move_count = ((@max_move_count.to_f / 100.0) * 50).round
      @move_step = 100
      set_interval seconds: @interval_sec do
        move_by @move_axis => (@move_step * get_dt) * @move_dir
        @move_count += 1
        if (@move_count > @max_move_count)
          case @move_axis
          when :x
            @move_axis = :y
          when :y
            @move_axis = :x
            @move_dir *= -1
          end
          @move_count = 0
        end
      end

      @rot_step = 2
      set_interval seconds: @interval_sec do
        increase_rotation @rot_step
      end

    end

    private

      def needs_cursor?
        return true
      end

      def button_down btnid
        seek_secs  = 4
        speed_incr = 0.25
        case btnid
        when Gosu::KB_Q, Gosu::KB_ESCAPE
          close
        when Gosu::KB_SPACE
          @cplayer.toggle
        when Gosu::KB_L, Gosu::KB_RIGHT
          @cplayer.seek seek_secs
        when Gosu::KB_H, Gosu::KB_LEFT
          @cplayer.seek -seek_secs
        when Gosu::KB_K, Gosu::KB_UP
          @cplayer.increase_speed speed_incr
        when Gosu::KB_J, Gosu::KB_DOWN
          @cplayer.increase_speed -speed_incr
        when Gosu::KB_S
          if (Gosu.button_down? Gosu::KB_LEFT_SHIFT)
            @cplayer.increase_speed -speed_incr
          else
            @cplayer.increase_speed speed_incr
          end
        when Gosu::KB_F
          toggle_fullscreen
        end
      end

      def update
        super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
        @layer.move_to x: mouse_x, y: mouse_y
      end

      def draw
        super
      end

    private

      def get_mem
        free = `free -h`.strip.split ?\n
        return free[1].split(' ')[2]
      end
  end
end

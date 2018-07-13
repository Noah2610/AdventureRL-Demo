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

      clip = AdventureRL::Clip.new DIR[:clip_configs].join('cyanide.yml')

      @cplayer = AdventureRL::ClipPlayer.new(
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
      )

      @cplayer.play clip
      add @cplayer

      rect_size = {
        width:  196,
        height: 196
      }
      @layer = AdventureRL::Layer.new(
        mask: {
          position: {
            x: get_center.x,
            y: get_center.y
          },
          size: rect_size,
          origin: {
            x: :center,
            y: :center
          }
        }
      )
      @rect = AdventureRL::Rectangle.new(
        mask: {
          size: rect_size,
          mouse_events: true
        },
        color: 0x99_00ff44
      )
      @rect.define_singleton_method(:on_mouse_press) do |btnid|
        puts btnid
      end

      @layer.add @rect
      add @layer

      @angle_incr = 180
      @scale_incr = 1
    end

    private

      def needs_cursor?
        return true
      end

      # Call <tt>super</tt> for AdventureRL framework button events to work.
      def button_down btnid
        super
        seek_secs  = 4
        speed_incr = 0.1
        case btnid
        when Gosu::KB_Q, Gosu::KB_ESCAPE
          close
        when Gosu::KB_F
          toggle_fullscreen
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
        end
      end

      def update
        super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
        dt = get_dt
        #@layer.move_to x: mouse_x, y: mouse_y
        increase_rotation  @angle_incr * dt      if (Gosu.button_down? Gosu::KB_D)
        increase_rotation -@angle_incr * dt      if (Gosu.button_down? Gosu::KB_A)
        if (Gosu.button_down? Gosu::KB_W)
          increase_scale :x, @scale_incr * dt
          increase_scale :y, @scale_incr * dt
        end
        if (Gosu.button_down? Gosu::KB_S)
          increase_scale :x, -@scale_incr * dt
          increase_scale :y, -@scale_incr * dt
        end
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

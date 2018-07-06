module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      AdventureRL::Clip.root = DIR[:clips]
      AdventureRL::Clip.default_settings = DIR[:clips].join 'default.yml'
      clip_one      = AdventureRL::Clip.new DIR[:clips].join('one.yml')
      clip_samsung  = AdventureRL::Clip.new DIR[:clips].join('samsung_color.yml')
      clip_ink      = AdventureRL::Clip.new DIR[:clips].join('ink.yml')
      @cplayer_one  = AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: 0, y: 0
          },
          size: {
            width:  (get_size(:width) * 0.5).floor,
            height: get_size(:height)
          }
        }
      })
      @cplayer_two = AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: 0
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.5).floor
          }
        }
      })
      @cplayer_three = AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: (get_size(:height) * 0.5).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.5).floor
          }
        }
      })
      @cplayer_one.play   clip_one
      @cplayer_two.play   clip_samsung
      @cplayer_three.play clip_ink
    end

    private

    def needs_cursor?
      return true
    end

    def button_down btnid
      seek_secs = 10
      case btnid
      when Gosu::KB_Q, Gosu::KB_ESCAPE
        close
      when Gosu::KB_SPACE
        if (Gosu.button_down? Gosu::KB_LEFT_SHIFT)
          @cplayer_two.toggle
        else
          @cplayer_one.toggle
        end
      when Gosu::KB_L, Gosu::KB_RIGHT
        @cplayer_one.seek seek_secs
      when Gosu::KB_H, Gosu::KB_LEFT
        @cplayer_one.seek -seek_secs
      when Gosu::KB_K, Gosu::KB_UP
        @cplayer_two.seek seek_secs
      when Gosu::KB_J, Gosu::KB_DOWN
        @cplayer_two.seek -seek_secs
      when Gosu::KB_S
        if (Gosu.button_down? Gosu::KB_LEFT_SHIFT)
          @cplayer_one.increment_speed_by -0.1
        else
          @cplayer_one.increment_speed_by 0.1
        end
      end
    end

    def update
      puts "FPS: #{get_fps}"
      #puts "#{@cplayer.get_current_time} - #{get_fps}"
      #puts get_fps  if (get_tick % get_fps == 0)  unless (get_fps == 0)
      super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
    end

    def draw
      [@cplayer_one, @cplayer_two, @cplayer_three].each &:draw
    end
  end
end

module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      puts get_mem

      AdventureRL::Clip.root = DIR[:clips]
      AdventureRL::Clip.default_settings = DIR[:clip_configs].join('default.yml')
      #clip = AdventureRL::Clip.new DIR[:clip_configs].join('one.yml')
      #clip = AdventureRL::Clip.new DIR[:clip_configs].join('samsung_color.yml')
      #clip = AdventureRL::Clip.new DIR[:clip_configs].join('ink.yml')
      clip = AdventureRL::Clip.new DIR[:clip_configs].join('america.yml')
      #clip = AdventureRL::Clip.new DIR[:clip_configs].join('anime.yml')
      #clip = AdventureRL::Clip.new DIR[:clip_configs].join('ultra.yml')

      AdventureRL::Audio.root = DIR[:audio]
      AdventureRL::Audio.default_settings = DIR[:audio_configs].join('default.yml')
      audio = AdventureRL::Audio.new DIR[:audio_configs].join('america.yml')

      @cplayer = AdventureRL::ClipPlayer.new({
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
      @aplayer = AdventureRL::AudioPlayer.new

      @cplayer.play clip
      @aplayer.play audio

      puts get_mem
    end

    private

    def needs_cursor?
      return true
    end

    def button_down btnid
      seek_secs  = 10
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
      when Gosu::KB_S
        if (Gosu.button_down? Gosu::KB_LEFT_SHIFT)
          @cplayer.increase_speed -speed_incr
        else
          @cplayer.increase_speed speed_incr
        end
      when Gosu::KB_C
        clear_interval :increase_speed
        clear_interval :puts_speed
      end
    end

    def update
      @cplayer.update
      @aplayer.update
      #puts get_mem  if (get_tick % get_fps == 0)  unless (get_fps == 0)

      #puts "FPS: #{get_fps}"
      #puts "#{@cplayer.get_current_time} - #{get_fps}"
      #puts get_fps  if (get_tick % get_fps == 0)  unless (get_fps == 0)
      super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
    end

    def draw
      @cplayer.draw
    end

    private

      def get_mem
        free = `free -h`.strip.split ?\n
        return free[1].split(' ')[2]
      end
  end
end

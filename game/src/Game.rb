module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      AdventureRL::Clip.root = DIR[:clips]
      AdventureRL::Clip.default_settings = DIR[:clips].join 'default.yml'
      clip_one     = AdventureRL::Clip.new DIR[:clips].join('one.yml')
      clip_samsung = AdventureRL::Clip.new DIR[:clips].join('samsung_color.yml')
      clip_ink     = AdventureRL::Clip.new DIR[:clips].join('ink.yml')
      @cplayers    = []
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: 0,
            y: 0
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.5).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: 0,
            y: (get_size(:height) * 0.5).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.25).floor,
            height: (get_size(:height) * 0.5).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width)  * 0.25).ceil,
            y: (get_size(:height) * 0.5).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.25).floor,
            height: (get_size(:height) * 0.5).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: 0
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.25).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: (get_size(:height) * 0.25).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.25).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: (get_size(:height) * 0.5).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.5).floor,
            height: (get_size(:height) * 0.25).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.5).ceil,
            y: (get_size(:height) * 0.75).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.25).floor,
            height: (get_size(:height) * 0.25).floor
          }
        }
      })
      @cplayers << AdventureRL::ClipPlayer.new({
        mask: {
          position: {
            x: (get_size(:width) * 0.75).ceil,
            y: (get_size(:height) * 0.75).ceil
          },
          size: {
            width:  (get_size(:width)  * 0.25).floor,
            height: (get_size(:height) * 0.25).floor
          }
        }
      })
      @cplayers.each.with_index do |cplayer, index|
        cplayer.increment_speed_by 0.25 * index
      end
      @cplayers[0].play clip_one
      @cplayers[1].play clip_samsung
      @cplayers[2].play clip_ink
      @cplayers[3].play clip_ink
      @cplayers[4].play clip_samsung
      @cplayers[5].play clip_one
      @cplayers[6].play clip_samsung
      @cplayers[7].play clip_ink
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
        @cplayers.each &:toggle
      when Gosu::KB_L, Gosu::KB_RIGHT
        @cplayers.each { |cp| cp.seek seek_secs }
      when Gosu::KB_H, Gosu::KB_LEFT
        @cplayers.each { |cp| cp.seek seek_secs }
      when Gosu::KB_S
        if (Gosu.button_down? Gosu::KB_LEFT_SHIFT)
          @cplayers.each { |cp| cp.increment_speed_by -speed_incr }
        else
          @cplayers.each { |cp| cp.increment_speed_by speed_incr }
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
      @cplayers.each &:draw
    end
  end
end

module Demo
  class Game < AdventureRL::Window
    def setup args
      # #setup will be called after #initialize
      # args are the arguments that were passed to #initialize,
      # or an empty hash if none were passed
      AdventureRL::Clip.root = DIR[:clips]
      AdventureRL::Clip.default_settings = DIR[:clips].join 'default.yml'
      clip_settings = DIR[:clips].join 'one.yml'
      @clip         = AdventureRL::Clip.new clip_settings
      @cplayer      = AdventureRL::ClipPlayer.new
      @cplayer     << @clip
      @cplayer.play :one
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
      #puts get_fps  if (get_tick % get_fps == 0)  unless (get_fps == 0)
      super  # Call AdventureRL::Window's #update method to be able to use a bunch of methods.
    end

    def draw
      @cplayer.draw
    end
  end
end

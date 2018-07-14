module Demo
  class Smth < AdventureRL::Window
    include AdventureRL

    def setup settings
      Clip.root  = DIR[:clips]
      Audio.root = DIR[:audio]
      $cplayer = ClipPlayer.new(
        mask: {
          size: get_size
        }
      )
      $clips = [
        Clip.new(DIR[:clip_configs].join('america.yml')),
        #Clip.new(DIR[:clip_configs].join('samsung_color.yml')),
        #Clip.new(DIR[:clip_configs].join('cyanide.yml')),
        #Clip.new(DIR[:clip_configs].join('anime.yml')),
        #Clip.new(DIR[:clip_configs].join('ultra.yml')),
      ]
      btn_size = {
        width:  64,
        height: 64
      }
      padding = 32
      @btns = [
        Rectangle.new(
          mask: {
            position: {
              x: padding,
              y: padding
            },
            size: btn_size,
            origin: {
              x: :left,
              y: :top
            },
            mouse_events: true
          },
          color: 0x88_0000ff
        ),
        Rectangle.new(
          mask: {
            position: {
              x: get_size(:width) - padding,
              y: padding
            },
            size: btn_size,
            origin: {
              x: :right,
              y: :top
            },
            mouse_events: true
          },
          color: 0x88_0000ff
        ),
        Rectangle.new(
          mask: {
            position: {
              x: padding,
              y: get_size(:height) - padding
            },
            size: btn_size,
            origin: {
              x: :left,
              y: :bottom
            },
            mouse_events: true
          },
          color: 0x88_0000ff
        ),
        Rectangle.new(
          mask: {
            position: {
              x: get_size(:width)  - padding,
              y: get_size(:height) - padding
            },
            size: btn_size,
            origin: {
              x: :right,
              y: :bottom
            },
            mouse_events: true
          },
          color: 0x88_0000ff
        )
      ]

      $current_clip = 0
      $cplayer.play $clips[0]

      add $cplayer
      @btns.each.with_index do |btn, index|
        case index % 4
        when 0
          btn.define_singleton_method :on_mouse_down do |btnid|
            $current_clip -= 1
            $current_clip = $clips.size + $current_clip  if ($current_clip < 0)
            $cplayer.play $clips[$current_clip]
          end
        when 1
          btn.define_singleton_method :on_mouse_down do |btnid|
            $current_clip += 1
            $current_clip = $current_clip - $clips.size  if ($current_clip >= $clips.size)
            $cplayer.play $clips[$current_clip]
          end
        when 2
          btn.define_singleton_method :on_mouse_down do |btnid|
            $cplayer.pause  if ($cplayer.is_playing?)
          end
        when 3
          btn.define_singleton_method :on_mouse_down do |btnid|
            $cplayer.resume  if ($cplayer.has_filegroup?)
          end
        end
        add btn
      end

      set_interval seconds: 0.5 do
        puts "clip:  #{$cplayer.get_current_time}"
        puts "audio: #{$cplayer.get_audio_player.get_current_time}"
      end

    end

    def needs_cursor?
      return true
    end

    def button_down btnid
      super
      case btnid
      when Gosu::KB_Q, Gosu::KB_ESCAPE
        close
      end
    end

    def update
      super
    end

    def draw
      super
    end
  end
end

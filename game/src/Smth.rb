module Demo
  class Smth < AdventureRL::Window
    include AdventureRL

    def setup settings
      Clip.root  = DIR[:clips]
      Audio.root = DIR[:audio]
      Clip.default_settings  = DIR[:clip_configs].join('default.yml')
      Audio.default_settings = DIR[:audio_configs].join('default.yml')
      $cplayer = ClipPlayer.new(
        position: {
          x: get_size(:width)  * 0.5,
          y: get_size(:height) * 0.5,
        },
        size: get_size,
        origin: {
          x: :center,
          y: :center
        }
      )
      $clip_configs = [
        DIR[:clip_configs].join('america.yml'),
        DIR[:clip_configs].join('samsung.yml'),
        DIR[:clip_configs].join('cyanide.yml'),
        DIR[:clip_configs].join('anime.yml')
      ]
      $clips = []
      $clip_layer = Layer.new(
        position: {
          x: get_size(:width)  * 0.5,
          y: get_size(:height) * 0.5
        },
        size: get_size,
        origin: {
          x: :center,
          y: :center
        }
      )
      $btns_layer = Layer.new(
        mask: {
          size: get_size
        }
      )
      btn_size = {
        width:  64,
        height: 64
      }
      padding = 32
      @btns = [
        Rectangle.new(
          position: {
            x: padding,
            y: padding
          },
          size: btn_size,
          origin: {
            x: :left,
            y: :top
          },
          color: 0x88_0000ff
        ),
        Rectangle.new(
          position: {
            x: get_size(:width) - padding,
            y: padding
          },
          size: btn_size,
          origin: {
            x: :right,
            y: :top
          },
          color: 0x88_0000ff
        ),
        Rectangle.new(
          position: {
            x: padding,
            y: get_size(:height) - padding
          },
          size: btn_size,
          origin: {
            x: :left,
            y: :bottom
          },
          color: 0x88_00ff00
        ),
        Rectangle.new(
          position: {
            x: (get_size(:width) - padding) - (btn_size[:width] + padding),
            y: (get_size(:height) - padding)
          },
          size: btn_size,
          origin: {
            x: :right,
            y: :bottom
          },
          color: 0x88_ffff00
        ),
        Rectangle.new(
          position: {
            x: get_size(:width)  - padding,
            y: get_size(:height) - padding
          },
          size: btn_size,
          origin: {
            x: :right,
            y: :bottom
          },
          color: 0x88_ffff00
        ),
        Rectangle.new(
          position: {
            x: (get_size(:width) * 0.5) - (padding * 0.5),
            y: get_size(:height) - padding
          },
          size: {
            width:  btn_size[:width],
            height: btn_size[:height] * 2
          },
          origin: {
            x: :right,
            y: :bottom
          },
          color: 0x88_00ffff
        ),
        Rectangle.new(
          position: {
            x: (get_size(:width) * 0.5) + (padding * 0.5),
            y: get_size(:height) - padding
          },
          size: {
            width:  btn_size[:width],
            height: btn_size[:height] * 2
          },
          origin: {
            x: :left,
            y: :bottom
          },
          color: 0x88_ffcc66
        )
      ]

      @btns.each do |btn|
        get_mouse_buttons_event_handler.subscribe btn
      end

      $current_clip = 0
      $clips[0] = Clip.new $clip_configs[0]
      $cplayer.play $clips[0]
      $speed_step = 0.025
      $seek_step  = 4
      $scale_step = 0.1

      $clip_layer.add $cplayer
      add $clip_layer
      add $btns_layer

      @btns.each.with_index do |btn, index|
        case index % @btns.size
        when 0
          btn.define_singleton_method :on_mouse_down do |btnid|
            $current_clip -= 1
            $current_clip = $clip_configs.size + $current_clip             if ($current_clip < 0)
            $clips[$current_clip] = Clip.new $clip_configs[$current_clip]  unless ($clips[$current_clip])
            $cplayer.play $clips[$current_clip]
          end
        when 1
          btn.define_singleton_method :on_mouse_down do |btnid|
            $current_clip += 1
            $current_clip = $current_clip - $clip_configs.size             if ($current_clip >= $clip_configs.size)
            $clips[$current_clip] = Clip.new $clip_configs[$current_clip]  unless ($clips[$current_clip])
            $cplayer.play $clips[$current_clip]
          end
        when 2
          btn.define_singleton_method :on_mouse_down do |btnid|
            $cplayer.toggle        if ($cplayer.has_filegroup?)
            set_color 0x88_ff0000  if (!$cplayer.is_playing?)
            set_color 0x88_00ff00  if ($cplayer.is_playing?)
          end
        when 3
          btn.define_singleton_method :on_mouse_down do |btnid|
            $cplayer.seek -$seek_step  if ($cplayer.has_filegroup?)
          end
        when 4
          btn.define_singleton_method :on_mouse_down do |btnid|
            $cplayer.seek $seek_step   if ($cplayer.has_filegroup?)
          end
        when 5
          btn.define_singleton_method :on_mouse_down do |btnid|
            case btnid
            when :wheel_up
              $cplayer.increase_speed $speed_step
            when :wheel_down
              $cplayer.increase_speed -$speed_step
            when :left
              $cplayer.set_speed 1.0
            end
          end
        when 6
          btn.define_singleton_method :on_mouse_down do |btnid|
            case btnid
            when :wheel_up
              $clip_layer.increase_scale :x, $scale_step
              $clip_layer.increase_scale :y, $scale_step
            when :wheel_down
              $clip_layer.increase_scale :x, -$scale_step
              $clip_layer.increase_scale :y, -$scale_step
            when :left
              $clip_layer.set_scale :x, 1.0
              $clip_layer.set_scale :y, 1.0
            end
          end
        end
        $btns_layer << btn
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

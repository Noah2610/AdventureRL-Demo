module Demo
	class Game < Gosu::Window
		def initialize
			@size = SETTINGS.get :window, :size
			super @size[:width], @size[:height]
			setup
		end

		private

		def setup
			self.caption = SETTINGS.get :window, :caption
		end

		def button_down btnid
			case btnid
			when Gosu::KB_Q, Gosu::KB_ESCAPE
				close
			end
		end
	end
end

module System

	module Windows

		class UIElement
			def refresh
				Workarounds.refresh self
			end
		end

	end

end
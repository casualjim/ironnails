class Symbol

  def to_brush
    case self
      when :black
        Brushes.black
      when :white
        Brushes.white
      when :green
        Brushes.green
      when :alice_blue
        Brushes.alice_blue
      when :red
        Brushes.red
    end
  end

  def to_orientation
    case self
      when :horizontal
        Orientation.horizontal
      when :vertical
        Orientation.vertical
    end
  end

  def to_visibility
    case self
      when :visible
        Visibility.visible
      when :hidden
        Visibility.hidden
      when :collapsed
        Visibility.collapsed
    end
  end

  def to_vertical_alignment
    case self
      when :center
        VerticalAlignment.center
      when :top
        VerticalAlignment.top
      when :bottom
        VerticalAlignment.bottom
      when :stretch
        VerticalAlignment.strecht
    end
  end

  def to_horizontal_alignment
    case self
      when :center
        HorizontalAlignment.center
      when :left
        HorizontalAlignment.left
      when :right
        HorizontalAlignment.right
      when :stretch
        HorizontalAlignment.stretch
    end
  end

  def to_binding_mode
    case self
      when :default
        BindingMode.default
      when :one_time
        BindingMode.one_time
      when :one_way
        BindingMode.one_way
      when :one_way_to_source
        BindingMode.one_way_to_source
      when :two_way
        BindingMode.two_way
    end
  end
end
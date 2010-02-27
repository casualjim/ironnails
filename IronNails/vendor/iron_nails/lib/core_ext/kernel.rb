module Kernel

  # Sets $VERBOSE to nil for the duration of the block and back to its original value afterwards.
  #
  #   silence_warnings do
  #     value = noisy_call # no warning voiced
  #   end
  #
  #   noisy_call # warning voiced
  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end

  def using(o)
    begin
      yield if block_given?
    ensure
      # TODO: When IronRuby is fixed so that it can call the public overload
      # of the parent class again remove the bool, some classes don't follow that convention.
      o.dispose true if o
    end
  end


end
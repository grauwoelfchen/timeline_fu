module TimelineFu
  module Macros
    def should_fire_event(action, opts = {})
      should "fire #{action} on #{opts[:on]}" do
        matcher = fire_event(action, opts)

        assert_accepts matcher, self.class.name.gsub(/Test$/, '').constantize
      end
    end

    def should_not_fire_event(action, opts = {})
      should "fire #{action} on #{opts[:on]}" do
        matcher = fire_event(action, opts)

        assert_rejects matcher, self.class.name.gsub(/Test$/, '').constantize
      end
    end

  end
end

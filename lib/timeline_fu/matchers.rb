module TimelineFu
  module Matchers
    class FireEvent
      def initialize(action, opts = {})
        @action = action
        @opts = opts
        @method = :"fire_#{@action}_after_#{@opts[:on]}"
      end

      def matches?(subject)
        @subject = subject

        defines_callback_method? && setups_up_callback?
      end

      def defines_callback_method?
        if @subject.instance_methods.include?(@method.to_s)
          true
        else
          @missing = "#{@subject.name} does not respond to #{@method}"
          false
        end
      end

      def setups_up_callback?
        callback_chain_name = "after_#{@opts[:on]}_callback_chain"
        callback_chain = @subject.send(callback_chain_name)
        if callback_chain.any? {|chain| chain.method == @method }
          true
        else
          @missing = "does setup after #{@opts[:on]} callback for #{@method}"
          false
        end
      end

      def description
        "fire a #{@action} event"
      end

      def expectation
        expected = "#{@subject.name} to #{description}"
      end

      def failure_message
        "Expected #{expectation} (#{@missing})"
      end

      def negative_failure_message
        "Did not expect #{expectation}"
      end

    end

    def fire_event(action, opts)
      FireEvent.new(action, opts)
    end
  end
end

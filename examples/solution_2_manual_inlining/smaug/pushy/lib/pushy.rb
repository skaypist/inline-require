
module Pushy
  class Subscription
    attr_reader :block

    def initialize(&blk)
      @block = blk
    end

    def next(next_value)
      @block.call(next_value)
    end
  end

  class Observable
    attr_reader :listeners, :transformer

    def initialize(transformer = Transformers.idempotent)
      @transformer = transformer
      @listeners = []
    end

    def subscribe(&blk)
      subscription = Subscription.new(&blk)
      register(subscription)
      subscription
    end

    def link(transformer)
      # like links in a #chain
      built_link = Observable.new(transformer)
      register built_link
      built_link
    end

    def register(listener)
      @listeners << listener
    end

    def next(next_value)
      @listeners.each do |listener|
        transformer.call(next_value, listener)
      end
    end

    def chain(*chained_transformers)
      chained_transformers.reduce(self) do |previous_observable, link_transformer|
        previous_observable.link link_transformer
      end
    end
  end

  module Transformers

    # class Pipe
    #   def initialize(*transformers)
    #     @transformers = transformers || []
    #   end
    #
    #   def call(next_value)
    #     stacked = [Idempotent,*@transformers].zip([*@transformers, Idempotent])
    #
    #
    #     stacked.reduce(next_value) do |memo, (from, to)|
    #       from.call(memo, to)
    #     end
    #
    #     stacked.each do |(from, to)|
    #       from.call(memo, to)
    #     end
    #   end
    # end

    class Idempotent
      def call(next_value, to)
        to.next(next_value)
      end
    end

    def self.idempotent; Idempotent.new; end


    class Map
      attr_reader :mapper

      def initialize &blk
        @mapper = blk
      end

      def call(next_value, to)
        to.next(mapper.call(next_value))
      end
    end

    def map(&blk)
      Map.new(&blk)
    end
    module_function :map

    #
    # def step(value); StepResult.new(value); end
    # module_function :step
    # def skip; StepResult.new(nil, true); end
    # module_function :skip
    #
    # class StepResult
    #   attr_reader :value, :skip
    #   def initialize(value, skip = false)
    #     @value, @skip = value, skip
    #   end
    # end


    class Filter
      attr_reader :filterer

      def initialize &blk
        @filterer = blk
      end

      def call(next_value, to)
        to.next(next_value) if filterer.call(next_value)
      end
    end

    def filter(&blk)
      Filter.new(&blk)
    end
    module_function :filter
  end
end

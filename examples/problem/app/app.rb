class App
  include ::Pushy::Transformers

  def initialize
    @mouse_actions = Pushy::Observable.new
    # @mouse_actions_subscription = @mouse_actions

    @square_double_click = @mouse_actions.chain(
      filter { |click| click.inside_rect?(TILE) }
    ).subscribe do |mouse_action|
      puts mouse_action
    end
  end

  TILE = {
    x: 200,
    y: 300,
    w: 150,
    h: 150
  }

  def perform_tick args
    update_tile_click!(args)
    args.outputs.labels << [100, 620, "Hello World", 2]
    args.outputs.solids << [TILE[:x], TILE[:y], TILE[:w], TILE[:h], 255]
  end

  def update_tile_click! args
    mouse_action = args.inputs.mouse.down || args.inputs.mouse.up
    @mouse_actions.next(mouse_action) if mouse_action
  end
end

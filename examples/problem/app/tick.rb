

def tick args
  $app ||= App.new
  $app.perform_tick(args)
end

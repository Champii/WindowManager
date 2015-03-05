class WindowManager

  # layer: 0
  wid: 1
  windows: {}
  baseX: 20
  baseY: 20

  constructor: (params) ->
    console.log 'WindowManager ctor'

    if not params.layer?
      throw new Error 'No layer defined'

    for name, param of params
      @[name] = param

  NewWindow: (params) ->
    params.layer = @layer
    win = new Window params

    win.wid = @wid++
    @windows[win.wid] = win

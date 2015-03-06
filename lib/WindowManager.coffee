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
    params = {} if not params?

    params.layer = @layer

    if not params.x?
      params.x = @baseX
      @baseX += 20

    if not params.y?
      params.y = @baseY
      @baseY += 20

    if not params.width?
      params.width = 100

    if not params.height?
      params.height = 100

    win = new Window params

    win.wid = @wid++
    @windows[win.wid] = win

    win.on 'close', =>
      delete @windows[win.wid]

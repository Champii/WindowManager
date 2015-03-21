class WindowManager

  # layer: 0
  wid: 1
  windows: {}
  baseX: 20
  baseY: 20
  focus: 0

  constructor: (params) ->
    console.log 'WindowManager ctor'

    accepted = [
      'layer'
      'layerOverride'
      'height'
      'width'
    ]

    if not params.layer?
      throw new Error 'No layer defined'

    for name, param of params when name in accepted
      @[name] = param

  NewWindow: (params) ->
    params = {} if not params?

    params.layer = @layer

    if params.override
      params.layer = @layerOverride

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

    win.wid = @wid++ if not win.wid?

    win.on 'close', =>
      delete @windows[win.wid]

    # win.on 'mousedown', =>
    #   if win.wid isnt focus
        # @windows[focus].UnFocus() if focus
        # win.Focus()
        # focus = win.wid

    @windows[win.wid] = win

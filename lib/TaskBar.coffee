class TaskBar

  constructor: (params) ->

    for name, param of params
      @[name] = param

    @bar = new Kinetic.Rect
      x: 0
      y: document.body.scrollHeight - 25
      height: 25
      width: document.body.scrollWidth
      stroke: 'black'
      strockWidth: 1
      fill: '#888888'

    @layer.add @bar

    @button = new Kinetic.Rect
      x: 5
      y: document.body.scrollHeight - 20
      height: 15
      width: 40
      fill: 'black'

    @layer.add @button

    @button.on 'mousedown', =>
      @wm.NewWindow()



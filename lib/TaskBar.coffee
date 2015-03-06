class TaskBar

  constructor: (params) ->

    accepted = [
      'layer'
      'wm'
    ]

    console.log params
    for name, param of params when name in accepted
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
      width: 70
      fill: '#444444'
      strokeWidth: 1
      stroke: 'black'

    @layer.add @button

    @button.on 'mousedown', =>
      @wm.NewWindow()



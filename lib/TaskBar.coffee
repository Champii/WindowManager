class Button

  constructor: (params) ->
    for name, param of params
      @[name] = param

    @button = new Kinetic.Rect params
    @layer.add @button

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


    @button = new Button
      x: 5
      y: document.body.scrollHeight - 20
      height: 15
      width: 40
      layer: @layer
      fill: 'black'



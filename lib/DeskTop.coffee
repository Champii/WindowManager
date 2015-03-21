class DeskTop

  constructor: ->
    @_InitKinetic()

  NewWindow: (params) ->
    @wm.NewWindow params

  _InitKinetic: ->
    @stage = new Kinetic.Stage
      container: 'render'
      height: document.body.scrollHeight
      width: document.body.scrollWidth

    @layer = new Kinetic.Layer
    @layerOverride = new Kinetic.Layer

    @stage.add @layer
    @stage.add @layerOverride

    @wm = new WindowManager
      layer: @layer
      layerOverride: @layerOverride
      height: document.body.scrollHeight
      width: document.body.scrollWidth

    @taskBar = new TaskBar
      layer: @layer
      wm: @wm

    document.getElementsByTagName('canvas')[0].style.background = '#BBBBBB'

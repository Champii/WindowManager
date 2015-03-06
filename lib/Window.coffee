class Window extends EventEmitter

  constructor: (params) ->

    for name, param of params
      @[name] = param

    @group = new Kinetic.Group
      x: @x
      y: @y
      stroke: 'black'
      strokeWidth: 4
      cornerRadius: 20

    @title = new Kinetic.Rect
      x: 0
      y: 0
      width: @width
      height: 20
      fill: 'green'
      strokeWidth: 1
      stroke: 'black'

    @closeButton = new Kinetic.Rect
      x: @width - 15
      y: 5
      width: 10
      height: 10
      fill: 'black'
      strokeWidth: 1
      stroke: 'black'

    @closeButton.on 'mousedown', =>
      @Close()

    @titleGroup = new Kinetic.Group
      x: 0
      y: 0

    @titleGroup.add @title
    @titleGroup.add @closeButton

    @group.add @titleGroup

    @title.on 'mousedown', (e) =>
      document.body.style.cursor = 'pointer';
      @group.draggable true

    @title.on 'mouseup', (e) =>
      document.body.style.cursor = 'default';
      @group.draggable false

    @content = new Kinetic.Rect
      # sceneFunc: (ctx) =>
        # ctx.putImageData @offscreen.getContext('2d').getImageData(0, 0, @width, @height), @group.getX(), @group.getY() + @title.getHeight()
        # ctx.fillStrokeShape(@content);
      x: 0
      y: 20
      width: @width
      height: @height
      fill: "#AAAAAA"
      strokeWidth: 1
      stroke: 'black'

    # @group.add @title
    @group.add @content

    @layer.add @group
    @layer.draw()

    @_AddAnchors()

    # @on 'drawn', (region) =>
    #   @content.draw()
    #   @title.draw()

  Close: ->
    @emit 'close'
    @group.remove()
    @layer.draw()

  _AddAnchors: ->
    corners =
      topLeft:
        x: 0
        y: 0
      topRight:
        x: 0
        y: @width + @title.getHeight()
      bottomLeft:
        x: @height
        y: 0
      bottomRight:
        x: @height
        y: @width + @title.getHeight()

    for name, corner of corners
      @_AddAnchor name, corner

  _AddAnchor: (name, corner) ->
    test = new Kinetic.Circle
      x: corner.x
      y: corner.y
      stroke: '#666'
      fill: '#ddd'
      strokeWidth: 2
      radius: 8
      name: name
      draggable: true
      dragOnTop: false
      opacity: 0

    @group.add test

    test.on 'mouseover', =>
      # console.log 'lol'
      test.setOpacity 0.5
      test.draw()

    test.on 'mouseout', =>
      # console.log 'mdr'
      test.setOpacity 0
      @layer.draw()

    test.on 'dragmove', =>
      @_Resize test

    @layer.draw()

  _Resize: (anchor) ->

    switch anchor.name()
      when 'bottomRight'
        if anchor.x() < 100
          anchor.x @width
        if anchor.y() < 100
          anchor.y @height + @title.getHeight()

        @content.width anchor.x()
        @content.height anchor.y() - @title.getHeight()

        @title.width anchor.x()

        @closeButton.x anchor.x() - 15

        @width = @content.width()
        @height = @content.height()

        @layer.draw()

    @emit 'resize'



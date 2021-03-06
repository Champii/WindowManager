class Window extends EventEmitter

  constructor: (params) ->
    super()
    accepted = [
      'wid'
      'width'
      'height'
      'x'
      'y'
      'layer'
      'offscreen'
      'properties'
      # 'xpra'
      'override'
    ]

    for name, param of params when name in accepted
      @[name] = param

    if @override
      #FIXME
      @y += 20

    @group = new Kinetic.Group
      x: @x
      y: @y
      stroke: 'black'

    @_MakeDecoration() if not @override
    @_PrepareContent()

  Focus: ->
    if not @override
      console.log 'tamere'
      @emit 'focus'
      @IsFocused()

  IsFocused: ->
    if not @override
      @group.moveToTop()
      @layer.draw()

  # UnFocus: ->
  #   @emit 'unfocus'
  #   @IsUnfocused()

  # IsUnfocused: ->

  Close: ->
    @emit 'close'
    @IsClosed()

  IsClosed: ->
    @group.remove()
    @layer.draw()

  _MakeDecoration: ->
    @_MakeTitleBar()
    @_AddAnchors()

  _MakeTitleBar: ->
    @title = new Kinetic.Rect
      x: 0
      y: 0
      width: @width
      height: 20
      fill: 'green'
      strokeWidth: 1
      stroke: 'black'
      cornerRadius: 3

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
      document.body.style.cursor = 'move';
      @group.draggable true
      @Focus()
      @group.opacity 0.5
      # @layer.draw()

    @title.on 'mouseup', (e) =>
      document.body.style.cursor = 'default';
      @group.draggable false
      @group.opacity 1
      @layer.draw()
      @x = @group.x()
      @y = @group.y()
      @emit 'move', @


  _PrepareContent: ->
    # console.log 'offscreen', @offscreen
    @content = new Kinetic.Shape
      hitFunc: (context) =>
        # console.log context
        context.beginPath();
        context.rect @content.x(), @content.y(), @content.width(), @content.height()
        # context.arc(0, 0, this.getOuterRadius() + 10, 0, Math.PI * 2, true);
        context.closePath();
        context.fillStrokeShape(@content);
      sceneFunc: (ctx) =>
        return if not @offscreen?
        ctx.putImageData @offscreen.getContext('2d').getImageData(0,0, @width, @height), @group.getX(), @group.getY() + (@title?.getHeight() || 0)
        ctx.fillStrokeShape(@content);
        # console.log @offscreen
      x: 0
      y: 20
      width: @width
      height: @height
      fill: "#AAAAAA"
      strokeWidth: 1
      stroke: 'black'
      cornerRadius: 3

    @content.on 'mousedown', (e) =>
      console.log 'mousedown'
      @Focus()
      @emit 'mousedown', 
        x: e.evt.x - @group.x()
        y: e.evt.y - @group.y() - (@title?.height() || 20)
        button: Math.max(0, e.evt.which)

    @content.on 'mouseup', (e) =>
      @emit 'mouseup', 
        x: e.evt.x - @group.x()
        y: e.evt.y - @group.y() - (@title?.height() || 20)
        button: Math.max(0, e.evt.which)

    @content.on 'mousemove', (e) =>
      @emit 'mousemove',
        x: e.evt.x - @group.x()
        y: e.evt.y - @group.y() - (@title?.height() || 20)

    @group.add @content

    @layer.add @group
    @layer.draw()

  Draw: ->
    @content.draw()
    @titleGroup?.draw()
    # @group.draw()

  _AddAnchors: ->
    @anchors = []

    corners =
      topLeft:
        x: 0
        y: 0
      topRight:
        x: @width
        y: 0
      bottomLeft:
        x: 0
        y: @height + @title.getHeight()
      bottomRight:
        x: @width
        y: @height + @title.getHeight()


    for name, corner of corners
      @_AddAnchor name, corner

  _AddAnchor: (name, corner) ->

    anchor = new Kinetic.Circle
      x: corner.x
      y: corner.y
      stroke: '#666'
      fill: '#ddd'
      strokeWidth: 2
      radius: 6
      name: name
      draggable: true
      dragOnTop: false
      opacity: 0

    @group.add anchor

    anchor.on 'mouseover', =>
      anchor.setOpacity 0.5
      anchor.draw()

    anchor.on 'mouseout', =>
      anchor.setOpacity 0
      @layer.draw()

    anchor.on 'dragmove', =>
      @_Resize anchor

    @anchors.push anchor
    @layer.draw()

  _UpdateAnchors: ->
    corners =
      topLeft:
        x: 0
        y: 0
      topRight:
        x: @width
        y: 0
      bottomLeft:
        x: 0
        y: @height + @title.getHeight()
      bottomRight:
        x: @width
        y: @height + @title.getHeight()

    for anchor in @anchors
      anchor.x corners[anchor.name()].x
      anchor.y corners[anchor.name()].y

  _Resize: (anchor) ->

    switch anchor.name()
      when 'bottomRight'
        if anchor.x() <= 100
          anchor.x @width
        if anchor.y() <= 100
          anchor.y @height + @title.getHeight()

        @content.width anchor.x()
        @content.height anchor.y() - @title.getHeight()

      when 'topLeft'
        if @width - anchor.x() <= 100
          anchor.x 0
        if @height - anchor.y() <= 100
          anchor.y 0

        @content.width @width - anchor.x()
        @content.height @height - anchor.y()

        @group.x @group.x() + anchor.x()
        @group.y @group.y() + anchor.y()

      when 'topRight'
        if anchor.x() <= 100
          anchor.x @width
        if @height - anchor.y() <= 100
          anchor.y 0

        @content.width anchor.x()

        @content.height @height - anchor.y()
        @group.y @group.y() + anchor.y()

      when 'bottomLeft'
        if anchor.y() <= 100
          anchor.y @height + @title.getHeight()
        if @width - anchor.x() <= 100
          anchor.x 0

        @content.width @width - anchor.x()
        @group.x @group.x() + anchor.x()

        @content.height anchor.y() - @title.getHeight()

    @title.width @content.width()
    @closeButton.x @content.width() - 15

    @width = @content.width()
    @height = @content.height()

    @_UpdateAnchors()
    @layer.draw()

    @emit 'resize', @

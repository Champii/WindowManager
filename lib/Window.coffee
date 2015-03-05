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

    @group.add @title
    @group.add @content

    @layer.add @group
    @layer.draw()

    # @on 'drawn', (region) =>
    #   @content.draw()
    #   @title.draw()


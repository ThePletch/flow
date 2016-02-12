class Field
  @timeScalar: 1
  @dampingSpeedThreshold: 1.5
  @dampingFactor: 0.95
  @pointCharge: 20.0
  @flowPerFrame: 0.4
  @radius:
    tracer: 1
  flowPoints: []
  tracers: []
  fieldVectors: []
  constructor: (@width, @height) ->
  addFlowPoint: (flowPoint) ->
    @flowPoints.push(flowPoint)
  flowAtPoint: (x, y, exclude = []) ->
    # todo restrict this to small subset
    flows = @flowPoints.exclude(exclude).map (flowPoint) ->
      flowPoint.flowOnCoord(x, y)

    VectorMath.addVectors(flows)
  fieldAtPoint: (x, y, exclude = []) ->
    forces = @flowPoints.exclude(exclude).map (flowPoint) ->
      flowPoint.forceOnCoord(x, y)

    VectorMath.addVectors(forces)
  randomCoords: (width, height) ->
    width ?= @width
    height ?= @height
    [
      Math.random() * width,
      Math.random() * height
    ]
  placeRandomTracer: ->
    [randX, randY] = @randomCoords()
    @tracers.push(new Tracer(this, randX, randY))
  tick: ->
    @tracers.map (tracer) -> tracer.tick()
    @renderToCanvas('that-canvas')
  renderToCanvas: (canvasSelector) ->
    canvas = document.getElementById(canvasSelector)
    context = canvas.getContext('2d')
    @render(context)
  render: (context) ->
    context.fillStyle = "white"
    context.fillRect(0, 0, @width, @height)
    context.fillStyle = "black"
    @tracers.map (tracer) -> tracer.render(context)
    @flowPoints.map (flowPoint) -> flowPoint.render(context)

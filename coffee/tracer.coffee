class Tracer
  frameCounter: 0
  enabled: true
  constructor: (@field, @x, @y) ->
    @velocity = [0, 0]
    @flowPoints = []
  accelerate: ->
    chargeVector = @field.fieldAtPoint(@x, @y, @flowPoints)
    flowVector = @field.flowAtPoint(@x, @y, @flowPoints)
    @velocity = VectorMath.addVectors([@velocity, chargeVector, flowVector])
  clamp: ->
    xSquared = Math.pow(@velocity[0], 2)
    ySquared = Math.pow(@velocity[1], 2)
    if Math.sqrt(xSquared + ySquared) > Field.dampingSpeedThreshold
      [vx, vy] = @velocity
      angle = VectorMath.angleForVector(vx, vy)
      unitVector = VectorMath.unitVectorForAngle(angle)
      @velocity = VectorMath.scaleVector(unitVector, Field.dampingSpeedThreshold)
  move: ->
    @x = @x + @velocity[0] * Field.timeScalar
    @y = @y + @velocity[1] * Field.timeScalar
  placeFlowPoint: ->
    if @frameCounter < Tracer.framesPerFlowPoint
      @frameCounter++
      return
    @frameCounter = 0
    [vx, vy] = @velocity
    @flowPoints.push(new FlowPoint(@field, @x, @y, VectorMath.angleForVector(vx, vy)))
  isOffMap: ->
    @x < 0 or @x > @field.width or @y < 0 or @y > @field.height
  tick: ->
    return unless @enabled

    if @isOffMap()
      @placeFlowPoint()
      @remove()
      @field.placeRandomTracer()
      return
    @accelerate()
    @clamp()
    @placeFlowPoint()
    @move()
  render: (context) ->
    if @enabled
      context.beginPath()
      context.arc(@x, @y, Field.radius.tracer, 0, 2 * Math.PI)
      context.stroke()
    @renderFlowPoints(context)
  renderFlowPoints: (context) ->
    return if @flowPoints.length < 2
    context.beginPath()
    @flowPoints.slice(1).preduce @flowPoints[0], (prev, next) ->
      context.moveTo(prev.x, prev.y)
      context.lineTo(next.x, next.y)

      next
    context.stroke()
  remove: ->
    @enabled = false

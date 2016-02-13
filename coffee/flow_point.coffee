class FlowPoint
  @framesPerFlowPoint: 2
  radius: 2
  constructor: (@field, @x, @y, @flowAngle) ->
    @field.addFlowPoint(this)
  forceOnCoord: (x, y) ->
    return [0, 0] if @charge() == 0
    [dx, dy] = VectorMath.vectorBetween(@x, @y, x, y)
    angle = VectorMath.angleForVector(dx, dy)
    angleDelta = VectorMath.normalizeAngle(angle - @flowAngle)
    forceAngle = (if angleDelta < Math.PI then Math.PI else -Math.PI)/2 + @flowAngle

    unitVector = VectorMath.unitVectorForAngle(forceAngle)
    VectorMath.scaleVector(unitVector, @charge() * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))
  flowOnCoord: (x, y) ->
    return [0, 0] if @flow() == 0

    unitVector = VectorMath.unitVectorForAngle(@flowAngle)
    VectorMath.scaleVector(unitVector, @flow() * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))
  charge: ->
    0.01 * Field.pointCharge * FlowPoint.framesPerFlowPoint
  flow: ->
    Field.flowPerFrame * FlowPoint.framesPerFlowPoint
  render: ->
    # flow points get rendered by their parent tracer

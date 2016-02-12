class FlowPoint
  @framesPerFlowPoint: 2
  radius: 2
  constructor: (@field, @x, @y, @flowAngle) ->
    @field.addFlowPoint(this)
  forceOnCoord: (x, y) ->
    return [0, 0] if @charge() == 0
    [dx, dy] = VectorMath.vectorBetween(@x, @y, x, y)
    angle = VectorMath.angleForVector(dx, dy)
    unitVector = VectorMath.unitVectorForAngle(angle)
    orthogonality = Math.abs(Math.sin(angle - @flowAngle))
    VectorMath.scaleVector(unitVector, @charge() * orthogonality * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))
  flowOnCoord: (x, y) ->
    return [0, 0] if @flow() == 0

    unitVector = VectorMath.unitVectorForAngle(@flowAngle)
    VectorMath.scaleVector(unitVector, @flow() * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))
  charge: ->
    0.05 * Field.pointCharge * FlowPoint.framesPerFlowPoint
  flow: ->
    Field.flowPerFrame * FlowPoint.framesPerFlowPoint
  render: ->
    # flow points get rendered by their parent tracer

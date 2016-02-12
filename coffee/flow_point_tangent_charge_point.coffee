class TangentChargePoint extends ChargePoint
  radius: 5
  constructor: (field, x, y, @clockwise = true) ->
    super(field, x, y)
  charge: ->
    2 * super()
  tangentDelta: ->
    (if @clockwise then Math.PI else -Math.PI)/2
  forceOnCoord: (x, y) ->
    return [0, 0] if @charge() == 0

    [dx, dy] = VectorMath.vectorBetween(@x, @y, x, y)
    normalAngle = VectorMath.angleForVector(dx, dy)
    angle = normalAngle + @tangentDelta()
    unitVector = VectorMath.unitVectorForAngle(angle)
    VectorMath.scaleVector(unitVector, @charge() * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))

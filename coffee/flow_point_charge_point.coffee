class @ChargePoint extends FlowPoint
  radius: 3
  constructor: (field, x, y) ->
    super(field, x, y, 0)
  forceOnCoord: (x, y) ->
    return [0, 0] if @charge() == 0

    unitVector = VectorMath.unitVectorBetween(@x, @y, x, y)
    VectorMath.scaleVector(unitVector, @charge() * VectorMath.invSquareMagnitudeBetween(@x, @y, x, y))
  charge: ->
    Field.pointCharge
  flow: ->
    0
  render: (context) ->
    context.beginPath()
    context.arc(@x, @y, @radius, 0, 2 * Math.PI)
    context.stroke()

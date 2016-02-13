class @VectorMath
  @addVectors: (vectors) ->
    baseVector = [0, 0]
    vectors.map (vector) ->
      baseVector[0] += vector[0]
      baseVector[1] += vector[1]

    baseVector
  @scaleVector: (vector, scalar) ->
    [vector[0] * scalar, vector[1] * scalar]
  @vectorBetween: (xa, ya, xb, yb) ->
    [xb - xa, yb - ya]
  @distanceBetween: (xa, ya, xb, yb) ->
    [dx, dy] = VectorMath.vectorBetween(xa, ya, xb, yb)

    Math.sqrt(dx * dx + dy * dy)
  @unitVectorBetween: (xa, ya, xb, yb) ->
    [dx, dy] = VectorMath.vectorBetween(xa, ya, xb, yb)

    return [0, 0] if dy == 0 and dx == 0

    VectorMath.unitVectorForAngle(VectorMath.angleForVector(dx, dy))
  @unitVectorForAngle: (theta) ->
    [Math.cos(theta), Math.sin(theta)]
  @angleForVector: (x, y) ->
    Math.atan2(y, x)
  @invMagnitudeBetween: (xa, ya, xb, yb) ->
    return 0 if xa is xb and ya is yb # division by zero escape

    1 / VectorMath.distanceBetween(xa, ya, xb, yb)
  @invSquareMagnitudeBetween: (xa, ya, xb, yb) ->
    return 0 if xa is xb and ya is yb # division by zero escape

    [dx, dy] = VectorMath.vectorBetween(xa, ya, xb, yb)

    1 / (dx * dx + dy * dy)
  @normalizeAngle: (angle) ->
    (angle + 2 * Math.PI) % (2 * Math.PI)

Array::preduce = (initial, func) ->
  @reduce(func, initial)
Array::exclude = (otherArray) ->
  @filter (element) ->
    otherArray.indexOf(element) is -1

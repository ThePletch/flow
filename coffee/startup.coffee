constants =
  width: 200
  height: 200
  chargePoints: [
    [100, 25],
    [25, 100],
    [100, 100],
    [175, 100],
    [100, 175]
  ]
  tangentChargePoints: [
    [100,   25, true],
    [25, 100, true],
    [100,  175, true],
    [175, 100, true],
    [100, 100, false]
  ]
  tracers: 10
  frameDelayMs: 100
doEvery = (ms, func) ->
  return window.setInterval(func, ms)
window.onload = ->
  window.field = new Field(constants.width, constants.height)
  constants.tangentChargePoints.map (coords) ->
    [x, y, clockwise] = coords
    field.addFlowPoint(new TangentChargePoint(field, x, y, clockwise))
  constants.chargePoints.map (coords) ->
    [x, y] = coords
    field.addFlowPoint(new ChargePoint(field, x, y))
  [0...constants.tracers].map ->
    field.placeRandomTracer()
  window.tickInterval = doEvery constants.frameDelayMs, ->
    field.tick()

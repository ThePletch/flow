// Generated by CoffeeScript 1.10.0
(function() {
  var ChargePoint, Field, FlowPoint, Tracer, VectorMath,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  ChargePoint = (function(superClass) {
    extend(ChargePoint, superClass);

    function ChargePoint() {
      return ChargePoint.__super__.constructor.apply(this, arguments);
    }

    ChargePoint.prototype.charge = function() {
      return this.field.pointCharge;
    };

    ChargePoint.prototype.flow = function() {
      return 0;
    };

    return ChargePoint;

  })(FlowPoint);

  Field = (function() {
    Field.timeScalar = 1;

    Field.dampingSpeedThreshold = 3;

    Field.dampingFactor = 0.95;

    Field.pointCharge = 1;

    Field.pointFlow = 1;

    Field.prototype.flowPoints = [];

    Field.prototype.tracers = [];

    Field.prototype.fieldVectors = [];

    function Field(width, height) {
      this.fieldVectors = height.map(function() {
        return width.map(function() {
          return [0, 0];
        });
      });
    }

    Field.prototype.addFlowPoint = function(flowPoint) {
      flowPoints.push(flowPoint);
      if (flowPoint.charge === 0) {
        return;
      }
      return this.fieldVectors = this.fieldVectors.map(function(row, y) {
        return row.map(function(vector, x) {
          return Field.addVectors(vector, flowPoint.forceOnCoord(x, y));
        });
      });
    };

    Field.prototype.flowAtPoint = function(x, y) {
      return Math.sum(flowPoints.map(function(flowPoint) {
        return flowPoint.flowOnCoord(x, y);
      }));
    };

    Field.prototype.tick = function() {
      return tracers.map(function(tracer) {
        return tracer.tick();
      });
    };

    Field.prototype.renderToCanvas = function(canvasSelector) {};

    return Field;

  })();

  FlowPoint = (function() {
    function FlowPoint(field, x1, y1, flowAngle) {
      this.field = field;
      this.x = x1;
      this.y = y1;
      this.flowAngle = flowAngle;
      this.field.addFlowPoint(this);
    }

    FlowPoint.prototype.forceOnCoord = function(x, y) {
      var unitVector;
      if (this.charge() === 0) {
        return 0;
      }
      unitVector = VectorMath.unitVectorBetween(this.x, this.y, x, y);
      return VectorMath.scaleVector(unitVector, this.charge() * VectorMath.invSquareMagnitudeBetween(this.x, this.y, x, y));
    };

    FlowPoint.prototype.flowOnCoord = function(x, y) {
      var unitVector;
      if (this.flow() === 0) {
        return 0;
      }
      unitVector = VectorMath.unitVectorForAngle(this.flowAngle);
      return VectorMath.scaleVector(unitVector, this.flow() * VectorMath.invMagnitudeBetween(this.x, this.y, x, y));
    };

    FlowPoint.prototype.charge = function() {
      return 0;
    };

    FlowPoint.prototype.flow = function() {
      return this.field.pointFlow;
    };

    return FlowPoint;

  })();

  Tracer = (function() {
    function Tracer(field, x1, y1) {
      this.field = field;
      this.x = x1;
      this.y = y1;
      this.velocity = [0, 0];
      this.flowPoints = [];
    }

    Tracer.prototype.accelerate = function() {
      var chargeVector, flowVector;
      chargeVector = this.field.fieldVectors[this.x][this.y];
      flowVector = this.field.flowAtPoint(this.x, this.y);
      return this.velocity = VectorMath.addVectors(this.velocity, chargeVector, flowVector);
    };

    Tracer.prototype.damp = function() {
      var xSquared, ySquared;
      xSquared = Math.pow(this.velocity[0], 2);
      ySquared = Math.pow(this.velocity[1], 2);
      if (Math.sqrt(xSquared + ySquared) > Field.dampingSpeedThreshold) {
        return this.velocity = [this.velocity[0] * Field.dampingFactor, this.velocity[1] * Field.dampingFactor];
      }
    };

    Tracer.prototype.move = function() {
      this.x = this.x + this.velocity[0] * Field.timeScalar;
      return this.y = this.y + this.velocity[1] * Field.timeScalar;
    };

    Tracer.prototype.placeFlowPoint = function() {
      var ref, vx, vy;
      ref = this.velocity, vx = ref[0], vy = ref[1];
      return this.flowPoints.push(new FlowPoint(this.field, this.x, this.y, VectorMath.angleForVector(vx, vy)));
    };

    Tracer.prototype.tick = function() {
      this.accelerate();
      this.damp();
      return this.move();
    };

    return Tracer;

  })();

  VectorMath = (function() {
    function VectorMath() {}

    VectorMath.addVectors = function() {
      var baseVector, vectors;
      vectors = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      baseVector = [0, 0];
      return vectors.forEach(function(vector) {
        baseVector[0] += vector[0];
        return baseVector[1] += vector[1];
      });
    };

    VectorMath.scaleVector = function(vector, scalar) {
      return [vector[0] * scalar, vector[1] * scalar];
    };

    VectorMath.vectorBetween = function(xa, ya, xb, yb) {
      return [yb - ya, xb - xa];
    };

    VectorMath.distanceBetween = function(xa, ya, xb, yb) {
      var dx, dy, ref;
      ref = VectorMath.vectorBetween(xa, ya, xb, yb), dy = ref[0], dx = ref[1];
      return Math.sqrt(dx * dx + dy * dy);
    };

    VectorMath.unitVectorBetween = function(xa, ya, xb, yb) {
      var dx, dy, ref;
      ref = VectorMath.vectorBetween(xa, ya, xb, yb), dy = ref[0], dx = ref[1];
      return VectorMath.unitVectorForAngle(VectorMath.angleForVector(dx, dy));
    };

    VectorMath.unitVectorForAngle = function(theta) {
      return [Math.cos(theta), Math.sin(theta)];
    };

    VectorMath.angleForVector = function(x, y) {
      return Math.atan2(y / x);
    };

    VectorMath.invMagnitudeBetween = function(xa, ya, xb, yb) {
      return 1 / VectorMath.distanceBetween(xa, ya, xb, yb);
    };

    VectorMath.invSquareMagnitudeBetween = function(xa, ya, xb, yb) {
      var dx, dy, ref;
      ref = VectorMath.vectorBetween(xa, ya, xb, yb), dy = ref[0], dx = ref[1];
      return 1 / (dx * dx + dy * dy);
    };

    return VectorMath;

  })();

}).call(this);

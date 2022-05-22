within MPC_Motor.Examples;
model OpenLoop_FreeAcceleration_IM
extends Modelica.Icons.Example;
  Modelica.Electrical.MultiPhase.Sources.SineVoltage sineVoltage(V = {163.3, 163.3, 163.3}, freqHz = {60, 60, 60}, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-26, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.Star star annotation(
    Placement(visible = true, transformation(origin = {-74, 32}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-84, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Machines.SimplifiedInductionMotor SIM annotation(
    Placement(visible = true, transformation(origin = {-2, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {54, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(star.plug_p, sineVoltage.plug_p) annotation(
    Line(points = {{-64, 32}, {-36, 32}}, color = {0, 0, 255}));
  connect(ground.p, star.pin_n) annotation(
    Line(points = {{-84, 12}, {-84, 32}}, color = {0, 0, 255}));
  connect(sineVoltage.plug_n, SIM.plug_sp) annotation(
    Line(points = {{-16, 32}, {-9, 32}}, color = {0, 0, 255}));
  connect(speedSensor.flange, SIM.flange) annotation(
    Line(points = {{44, 32}, {9, 32}}));
  annotation(
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-3, Interval = 1e-5),
    Icon(graphics = {Rectangle(origin = {-2, 2}, lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}));
end OpenLoop_FreeAcceleration_IM;
 

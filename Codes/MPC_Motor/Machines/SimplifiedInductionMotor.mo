within MPC_Motor.Machines;
model SimplifiedInductionMotor
  extends MPC_Motor.Interfaces.PartialBasicMachine_IM(inertiaRotor.J = data_Motor.J);
  Modelica.Electrical.MultiPhase.Basic.Star star annotation(
    Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-64, -54}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  MPC_Motor.Components.simplifiedAirGap_IM airGap annotation(
    Placement(visible = true, transformation(origin = {-14, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerSensor annotation(
    Placement(visible = true, transformation(origin = {16, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean(f = 1) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(star.pin_n, ground.p) annotation(
    Line(points = {{-80, -34}, {-80, -41}, {-64, -41}, {-64, -48}}, color = {0, 0, 255}));
  connect(spacePhasorS.spacePhasor, airGap.spacePhasor) annotation(
    Line(points = {{-54, 42}, {-24, 42}, {-24, 44}, {-24, 44}}, color = {0, 0, 255}));
  connect(support, airGap.support) annotation(
    Line(points = {{-28, -100}, {-26, -100}, {-26, 34}, {-14, 34}, {-14, 40}, {-14, 40}}));
  connect(powerSensor.flange_a, airGap.flange) annotation(
    Line(points = {{6, 26}, {-4, 26}, {-4, 44}, {-2, 44}}));
  connect(powerSensor.flange_b, inertiaRotor.flange_a) annotation(
    Line(points = {{26, 26}, {62, 26}, {62, 56}, {62, 56}}));
  connect(mean.u, powerSensor.power) annotation(
    Line(points = {{18, 0}, {8, 0}, {8, 16}, {8, 16}}, color = {0, 0, 127}));
end SimplifiedInductionMotor;
 

within MPC_Motor.Examples;
model OpenLoop_WithInverter_PMSM
extends Modelica.Icons.Example;

MPC_Motor.Components.SignalGenerator SG annotation(
    Placement(visible = true, transformation(origin = {-33, 61}, extent = {{-17, 17}, {17, -17}}, rotation = -90)));
  MPC_Motor.Components.TwoLevelInverterBooleanOutput VSI annotation(
    Placement(visible = true, transformation(origin = {-32, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(V = 560) annotation(
    Placement(visible = true, transformation(origin = {-72, -4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Machines.SimplifiedPMSM simplifiedPMSM annotation(
    Placement(visible = true, transformation(origin = {0, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {50, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.TorqueStep torqueStep(startTime = 3, stepTorque = -5) annotation(
    Placement(visible = true, transformation(origin = {32, -28}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(SG.Sa, VSI.Sa) annotation(
    Line(points = {{-40, 42}, {-40, 27}, {-38, 27}, {-38, 16}}, color = {255, 0, 255}));
  connect(VSI.Sb, SG.Sb) annotation(
    Line(points = {{-32, 16}, {-34, 16}, {-34, 42}, {-33, 42}}, color = {255, 0, 255}));
  connect(SG.Sc, VSI.Sc) annotation(
    Line(points = {{-24.5, 42}, {-26, 42}, {-26, 16}}, color = {255, 0, 255}));
  connect(ground.p, stepVoltage.n) annotation(
    Line(points = {{-70, -40}, {-70, -27}, {-72, -27}, {-72, -14}}, color = {0, 0, 255}));
  connect(stepVoltage.p, VSI.DC_In) annotation(
    Line(points = {{-72, 6}, {-72, 10}, {-44, 10}, {-44, 8}}, color = {0, 0, 255}));
  connect(VSI.DC_Out, stepVoltage.n) annotation(
    Line(points = {{-44, 2}, {-52, 2}, {-52, -14}, {-72, -14}}, color = {0, 0, 255}));
  connect(VSI.Plug_p, simplifiedPMSM.plug_sp) annotation(
    Line(points = {{-20, 6}, {-6, 6}, {-6, 6}, {-6, 6}}, color = {0, 0, 255}));
  connect(speedSensor.flange, simplifiedPMSM.flange) annotation(
    Line(points = {{40, 6}, {10, 6}}));
  connect(simplifiedPMSM.flange, torqueStep.flange) annotation(
    Line(points = {{10, 6}, {22, 6}, {22, -28}}));
protected
  annotation(
    Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}),
    Diagram(graphics = {Text(origin = {49, 60}, lineColor = {85, 0, 255}, extent = {{-41, 16}, {41, -16}}, textString = "1. Please select Rungekutta Solver in Simulation Setup"), Text(origin = {42, 49}, lineColor = {85, 0, 255}, extent = {{-34, 11}, {34, -11}}, textString = "2.  Verify if, Step Size :0.0001, tolerance: 0.0001")}),
    experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-3, Interval = 1e-5));
end OpenLoop_WithInverter_PMSM;

within MPC_Motor.Examples;
model Closed_Loop_MPC_PMSM
extends Modelica.Icons.Example;

  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(V = 560) annotation(
    Placement(visible = true, transformation(origin = {-68, 42}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {12, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Components.TwoLevelInverterBooleanOutput VSI annotation(
    Placement(visible = true, transformation(origin = {-26, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MPC_Motor.Blocks.Predictive_Controller_PMSM predictive_Controller_PMSM annotation(
    Placement(visible = true, transformation(origin = {-28, 80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
Modelica.Blocks.Continuous.PI PI(T = 0.5, k = 1) annotation(
    Placement(visible = true, transformation(origin = {-28, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Sources.Ramp Ra(duration = 5, height = 150, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-92, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Math.Feedback F annotation(
    Placement(visible = true, transformation(origin = {-62, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
MPC_Motor.Blocks.abcToDQ abcToDQ annotation(
    Placement(visible = true, transformation(origin = {12, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor annotation(
    Placement(visible = true, transformation(origin = {42, 2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {24, 104}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
Machines.SimplifiedPMSM simplifiedPMSM annotation(
    Placement(visible = true, transformation(origin = {44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(ground.p, stepVoltage.n) annotation(
    Line(points = {{-68, 14}, {-68, 32}}, color = {0, 0, 255}));
connect(VSI.Plug_p, currentSensor.plug_p) annotation(
    Line(points = {{-14, 35.5}, {2, 35.5}, {2, 44}}, color = {0, 0, 255}));
connect(stepVoltage.p, VSI.DC_In) annotation(
    Line(points = {{-68, 52}, {-68, 54}, {-44, 54}, {-44, 39}, {-37.5, 39}}, color = {0, 0, 255}));
connect(ground.p, VSI.DC_Out) annotation(
    Line(points = {{-68, 14}, {-44, 14}, {-44, 32.5}, {-37.5, 32.5}}, color = {0, 0, 255}));
connect(predictive_Controller_PMSM.Sa, VSI.Sa) annotation(
    Line(points = {{-34, 68}, {-34, 52.5}, {-32, 52.5}, {-32, 45}}, color = {255, 0, 255}));
connect(predictive_Controller_PMSM.Sb, VSI.Sb) annotation(
    Line(points = {{-28, 68}, {-28, 52.5}, {-26, 52.5}, {-26, 45}}, color = {255, 0, 255}));
connect(predictive_Controller_PMSM.Sc, VSI.Sc) annotation(
    Line(points = {{-22, 68}, {-22, 52.5}, {-20, 52.5}, {-20, 45}}, color = {255, 0, 255}));
  connect(F.y, PI.u) annotation(
    Line(points = {{-53, -50}, {-43, -50}, {-43, -50}, {-41, -50}}, color = {0, 0, 127}));
  connect(Ra.y, F.u1) annotation(
    Line(points = {{-81, -50}, {-73, -50}, {-73, -50}, {-71, -50}}, color = {0, 0, 127}));
  connect(predictive_Controller_PMSM.wm, speedSensor.w) annotation(
    Line(points = {{-16, 86}, {88, 86}, {88, -20}, {60, -20}, {60, -4}, {60, -4}}, color = {0, 0, 127}));
  connect(abcToDQ.Is, currentSensor.i) annotation(
    Line(points = {{14, 18}, {12, 18}, {12, 34}, {12, 34}}, color = {0, 0, 127}, thickness = 0.5));
  connect(angleSensor.flange, speedSensor.flange) annotation(
    Line(points = {{42, 12}, {51, 12}, {51, 16}, {60, 16}}));
  connect(angleSensor.phi, abcToDQ.angle) annotation(
    Line(points = {{42, -8}, {42, -8}, {42, -18}, {26, -18}, {26, 24}, {8, 24}, {8, 18}, {8, 18}}, color = {0, 0, 127}));
  connect(abcToDQ.Idq, predictive_Controller_PMSM.Idq) annotation(
    Line(points = {{14, -6}, {14, -6}, {14, -12}, {-6, -12}, {-6, 82}, {-16, 82}, {-16, 82}}, color = {0, 0, 127}, thickness = 0.5));
  connect(predictive_Controller_PMSM.phi, abcToDQ.angle) annotation(
    Line(points = {{-16, 76}, {-12, 76}, {-12, 18}, {8, 18}, {8, 18}}, color = {0, 0, 127}));
  connect(F.u2, speedSensor.w) annotation(
    Line(points = {{-62, -58}, {-62, -58}, {-62, -78}, {60, -78}, {60, -4}, {60, -4}}, color = {0, 0, 127}));
  connect(PI.y, predictive_Controller_PMSM.iq_ref) annotation(
    Line(points = {{-16, -50}, {-10, -50}, {-10, -14}, {-86, -14}, {-86, 100}, {-22, 100}, {-22, 92}, {-22, 92}}, color = {0, 0, 127}));
  connect(predictive_Controller_PMSM.id_ref, const.y) annotation(
    Line(points = {{-30, 92}, {-28, 92}, {-28, 104}, {13, 104}}, color = {0, 0, 127}));
connect(currentSensor.plug_n, simplifiedPMSM.plug_sp) annotation(
    Line(points = {{22, 44}, {36, 44}, {36, 44}, {38, 44}, {38, 44}}, color = {0, 0, 255}));
connect(simplifiedPMSM.flange, speedSensor.flange) annotation(
    Line(points = {{54, 44}, {60, 44}, {60, 16}, {60, 16}}));
protected
  annotation(
    Documentation(info = "
 <html>
 <p>
 Step Time:0.0001, Solver: RungeKutta, Time:10(optional) </p>
</html> "),
    Icon(graphics = {Rectangle(origin = {-2, 2}, lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}),
    Diagram(graphics = {Text(origin = {-6, 145}, lineColor = {85, 0, 255}, extent = {{-64, 9}, {64, -9}}, textString = "1. Please select Rungekutta Solver in Simulation Setup")}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-3, Interval= 1e-6));
end Closed_Loop_MPC_PMSM;
 

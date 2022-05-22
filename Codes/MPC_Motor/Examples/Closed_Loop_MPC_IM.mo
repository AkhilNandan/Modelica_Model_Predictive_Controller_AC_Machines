within MPC_Motor.Examples;
model Closed_Loop_MPC_IM
extends Modelica.Icons.Example;
  Real torque = SIM.airGap.flange.tau;
  Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(V = 250) annotation(
    Placement(visible = true, transformation(origin = {-68, 42}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Sensors.CurrentSensor currentSensor annotation(
    Placement(visible = true, transformation(origin = {12, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Machines.SimplifiedInductionMotor SIM annotation(
    Placement(visible = true, transformation(origin = {42, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Blocks.abcToAlphaBeta AtoB annotation(
    Placement(visible = true, transformation(origin = {12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-40, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Fref(k = 0.4) annotation(
    Placement(visible = true, transformation(origin = {-72, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground annotation(
    Placement(visible = true, transformation(origin = {-68, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Interfaces.DataBus D1 annotation(
    Placement(visible = true, transformation(origin = {-28, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-18, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  MPC_Motor.Interfaces.DataBus D2 annotation(
    Placement(visible = true, transformation(origin = {36, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-16, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  MPC_Motor.Interfaces.DataBus D3 annotation(
    Placement(visible = true, transformation(origin = {68, 106}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-16, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  MPC_Motor.Interfaces.DataBus D4 annotation(
    Placement(visible = true, transformation(origin = {-68, 106}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-14, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  MPC_Motor.Blocks.Estimator E annotation(
    Placement(visible = true, transformation(origin = {44, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MPC_Motor.Components.TwoLevelInverterBooleanOutput VSI annotation(
    Placement(visible = true, transformation(origin = {-28, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Ramp ramp(duration = 3, height = 120) annotation(
    Placement(visible = true, transformation(origin = {-70, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Sources.TorqueStep torqueStep(offsetTorque = 0, startTime = 3.5, stepTorque = -20) annotation(
    Placement(visible = true, transformation(origin = {132, 44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  MPC_Motor.Blocks.Predictive_Controller_IM predictive_Controller_IM annotation(
    Placement(visible = true, transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI pi(T = 1.5, k = 15) annotation(
    Placement(visible = true, transformation(origin = {-16, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(currentSensor.plug_n, SIM.plug_sp) annotation(
    Line(points = {{22, 44}, {36, 44}, {36, 44}, {36, 44}}, color = {0, 0, 255}));
  connect(currentSensor.i, AtoB.Is) annotation(
    Line(points = {{12, 33}, {12, 11}, {13, 11}}, color = {0, 0, 127}, thickness = 0.5));
  connect(speedSensor.flange, SIM.flange) annotation(
    Line(points = {{60, 16}, {60, 16}, {60, 44}, {52, 44}, {52, 44}}));
  connect(ground.p, stepVoltage.n) annotation(
    Line(points = {{-68, 14}, {-68, 32}}, color = {0, 0, 255}));
  connect(D4, D3) annotation(
    Line(points = {{-68, 106}, {68, 106}, {68, 106}, {68, 106}}, thickness = 0.5));
  connect(D4, D1) annotation(
    Line(points = {{-68, 106}, {-110, 106}, {-110, -104}, {-28, -104}, {-28, -102}}, thickness = 0.5));
  connect(D1, D2) annotation(
    Line(points = {{-28, -102}, {32, -102}, {32, -102}, {36, -102}}, thickness = 0.5));
  connect(D2, D3) annotation(
    Line(points = {{36, -102}, {106, -102}, {106, 106}, {68, 106}, {68, 106}}, thickness = 0.5));
  connect(Fref.y, D1.Fsref) annotation(
    Line(points = {{-60, -66}, {-48, -66}, {-48, -98}, {-28, -98}, {-28, -102}}, color = {0, 0, 127}));
  connect(feedback.u2, D1.Wm) annotation(
    Line(points = {{-40, -42}, {-40, -42}, {-40, -102}, {-28, -102}}, color = {0, 0, 127}));
  connect(AtoB.Iab, D2.Is) annotation(
    Line(points = {{13, -12}, {13, -98}, {36, -98}, {36, -102}}, color = {0, 0, 127}, thickness = 0.5));
  connect(speedSensor.w, D2.Wm) annotation(
    Line(points = {{60, -4}, {60, -4}, {60, -98}, {36, -98}, {36, -102}}, color = {0, 0, 127}));
  connect(E.Fs, D3.Fs) annotation(
    Line(points = {{56, 82}, {72, 82}, {72, 106}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Fr, D3.Fr) annotation(
    Line(points = {{56, 75}, {74, 75}, {74, 106}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Is, D3.Is) annotation(
    Line(points = {{33, 82}, {22, 82}, {22, 96}, {68, 96}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Ws, D3.Wm) annotation(
    Line(points = {{33, 75}, {18, 75}, {18, 94}, {68, 94}, {68, 106}}, color = {0, 0, 127}));
  connect(E.x_opt_in, D3.x_opt) annotation(
    Line(points = {{44, 67}, {44, 58}, {76, 58}, {76, 106}, {68, 106}}, color = {255, 127, 0}));
  connect(E.x_opt_in, D3.x_opt) annotation(
    Line(points = {{44, 67}, {44, 58}, {76, 58}, {76, 106}, {68, 106}}, color = {255, 127, 0}));
  connect(E.Fs, D3.Fs) annotation(
    Line(points = {{56, 82}, {72, 82}, {72, 106}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Fr, D3.Fr) annotation(
    Line(points = {{56, 75}, {74, 75}, {74, 106}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Is, D3.Is) annotation(
    Line(points = {{33, 82}, {22, 82}, {22, 96}, {68, 96}, {68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(E.Ws, D3.Wm) annotation(
    Line(points = {{33, 75}, {18, 75}, {18, 94}, {68, 94}, {68, 106}}, color = {0, 0, 127}));
  connect(VSI.Plug_p, currentSensor.plug_p) annotation(
    Line(points = {{-16, 40}, {2, 40}, {2, 44}, {2, 44}}, color = {0, 0, 255}));
  connect(stepVoltage.p, VSI.DC_In) annotation(
    Line(points = {{-68, 52}, {-68, 52}, {-68, 54}, {-44, 54}, {-44, 42}, {-40, 42}, {-40, 42}}, color = {0, 0, 255}));
  connect(ground.p, VSI.DC_Out) annotation(
    Line(points = {{-68, 14}, {-44, 14}, {-44, 36}, {-40, 36}, {-40, 36}}, color = {0, 0, 255}));
  connect(ramp.y, feedback.u1) annotation(
    Line(points = {{-59, -34}, {-48, -34}}, color = {0, 0, 127}));
  connect(torqueStep.flange, SIM.flange) annotation(
    Line(points = {{122, 44}, {52, 44}}));
  connect(predictive_Controller_IM.Fr, D4.Fr) annotation(
    Line(points = {{-42, 86}, {-72, 86}, {-72, 106}, {-68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(predictive_Controller_IM.Fs, D4.Fs) annotation(
    Line(points = {{-42, 78}, {-68, 78}, {-68, 106}, {-68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(predictive_Controller_IM.Is, D4.Is) annotation(
    Line(points = {{-38, 92}, {-66, 92}, {-66, 106}, {-68, 106}}, color = {0, 0, 127}, thickness = 0.5));
  connect(predictive_Controller_IM.Tref, D4.Tref) annotation(
    Line(points = {{-34, 92}, {-34, 92}, {-34, 102}, {-68, 102}, {-68, 106}}, color = {0, 0, 127}));
  connect(predictive_Controller_IM.Fsref, D3.Fsref) annotation(
    Line(points = {{-30, 92}, {-30, 92}, {-30, 104}, {68, 104}, {68, 106}}, color = {0, 0, 127}));
  connect(predictive_Controller_IM.Ws, D3.Wm) annotation(
    Line(points = {{-26, 92}, {-26, 92}, {-26, 102}, {68, 102}, {68, 106}}, color = {0, 0, 127}));
  connect(predictive_Controller_IM.x_opt_in, D4.x_opt) annotation(
    Line(points = {{-30, 70}, {-30, 70}, {-30, 74}, {-74, 74}, {-74, 106}, {-68, 106}}, color = {255, 127, 0}));
  connect(VSI.Sa, predictive_Controller_IM.Sa) annotation(
    Line(points = {{-34, 50}, {-34, 50}, {-34, 66}, {-18, 66}, {-18, 74}, {-18, 74}}, color = {255, 0, 255}));
  connect(VSI.Sb, predictive_Controller_IM.Sb) annotation(
    Line(points = {{-28, 50}, {-28, 50}, {-28, 62}, {-10, 62}, {-10, 78}, {-18, 78}, {-18, 80}, {-18, 80}}, color = {255, 0, 255}));
  connect(predictive_Controller_IM.Sc, VSI.Sc) annotation(
    Line(points = {{-18, 86}, {-18, 86}, {-18, 84}, {-4, 84}, {-4, 58}, {-22, 58}, {-22, 50}, {-22, 50}}, color = {255, 0, 255}));
  connect(feedback.y, pi.u) annotation(
    Line(points = {{-31, -34}, {-28, -34}}, color = {0, 0, 127}));
  connect(pi.y, D1.Tref) annotation(
    Line(points = {{-5, -34}, {-2, -34}, {-2, -100}, {-28, -100}, {-28, -102}}, color = {0, 0, 127}));
protected
  annotation(
    Documentation(info = "
<html>
<p>
Step Time:0.0001, Solver: RungeKutta, Time:10(optional) </p>
</html> "),
    Icon(graphics = {Rectangle(origin = {-2, 2}, lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}),
    Diagram,
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-3, Interval = 1e-6));
end Closed_Loop_MPC_IM;
 

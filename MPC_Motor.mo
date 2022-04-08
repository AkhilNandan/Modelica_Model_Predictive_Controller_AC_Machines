package MPC_Motor
  package UserGuide
    annotation(
      Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Ellipse(origin = {7.5, 56.5}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12.5, -12.5}, {12.5, 12.5}}, endAngle = 360), Polygon(origin = {-4.167, -15}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-15.833, 20}, {-15.833, 30}, {14.167, 40}, {24.167, 20}, {4.167, -30}, {14.167, -30}, {24.167, -30}, {24.167, -40}, {-5.833, -50}, {-15.833, -30}, {4.167, 20}, {-5.833, 20}, {-15.833, 20}}, smooth = Smooth.Bezier)}));
  end UserGuide;

  package Examples
    model OpenLoop_WithInverter_IM
      MPC_Motor.Components.SignalGenerator SG annotation(
        Placement(visible = true, transformation(origin = {-33, 59}, extent = {{-17, 17}, {17, -17}}, rotation = -90)));
      MPC_Motor.Components.TwoLevelInverterBooleanOutput VSI annotation(
        Placement(visible = true, transformation(origin = {-32, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Electrical.Analog.Sources.StepVoltage stepVoltage(V = 250) annotation(
        Placement(visible = true, transformation(origin = {-72, -4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(visible = true, transformation(origin = {-70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MPC_Motor.Machines.SimplifiedInductionMotor SIM annotation(
        Placement(visible = true, transformation(origin = {2, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Sources.TorqueStep torqueStep(startTime = 3, stepTorque = -5) annotation(
        Placement(visible = true, transformation(origin = {34, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    equation
      connect(SG.Sa, VSI.Sa) annotation(
        Line(points = {{-40, 40}, {-38, 40}, {-38, 16}, {-38, 16}}, color = {255, 0, 255}));
      connect(VSI.Sb, SG.Sb) annotation(
        Line(points = {{-32, 16}, {-34, 16}, {-34, 40}, {-32, 40}}, color = {255, 0, 255}));
      connect(SG.Sc, VSI.Sc) annotation(
        Line(points = {{-24, 40}, {-26, 40}, {-26, 16}, {-26, 16}}, color = {255, 0, 255}));
      connect(ground.p, stepVoltage.n) annotation(
        Line(points = {{-70, -40}, {-70, -27}, {-72, -27}, {-72, -14}}, color = {0, 0, 255}));
      connect(stepVoltage.p, VSI.DC_In) annotation(
        Line(points = {{-72, 6}, {-72, 10}, {-44, 10}, {-44, 8}}, color = {0, 0, 255}));
      connect(VSI.DC_Out, stepVoltage.n) annotation(
        Line(points = {{-44, 2}, {-52, 2}, {-52, -14}, {-72, -14}}, color = {0, 0, 255}));
      connect(VSI.Plug_p, SIM.plug_sp) annotation(
        Line(points = {{-20, 6}, {-5, 6}}, color = {0, 0, 255}));
      connect(SIM.flange, torqueStep.flange) annotation(
        Line(points = {{12, 6}, {24, 6}, {24, 2}, {24, 2}}));
    protected
      annotation(
        Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}),
        Diagram(graphics = {Text(origin = {49, 60}, lineColor = {85, 0, 255}, extent = {{-41, 16}, {41, -16}}, textString = "1. Please select Rungekutta Solver in Simulation Setup"), Text(origin = {42, 49}, lineColor = {85, 0, 255}, extent = {{-34, 11}, {34, -11}}, textString = "2.  Verify if, Step Size :0.0001, tolerance: 0.0001")}),
        experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-3, Interval = 1e-5));
    end OpenLoop_WithInverter_IM;

    model Closed_Loop_MPC_IM
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

    model OpenLoop_FreeAcceleration_IM
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

    model OpenLoop_WithInverter_PMSM
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
    protected
      annotation(
        Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}),
        Diagram(graphics = {Text(origin = {49, 60}, lineColor = {85, 0, 255}, extent = {{-41, 16}, {41, -16}}, textString = "1. Please select Rungekutta Solver in Simulation Setup"), Text(origin = {42, 49}, lineColor = {85, 0, 255}, extent = {{-34, 11}, {34, -11}}, textString = "2.  Verify if, Step Size :0.0001, tolerance: 0.0001")}),
        experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-3, Interval = 1e-5));
    end OpenLoop_WithInverter_PMSM;

    model OpenLoop_FreeAcceleration_PMSM
      Modelica.Electrical.MultiPhase.Sources.SineVoltage sineVoltage(V = {560, 560, 560}, freqHz = {60, 60, 60}, m = 3) annotation(
        Placement(visible = true, transformation(origin = {-30, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Electrical.MultiPhase.Basic.Star star annotation(
        Placement(visible = true, transformation(origin = {-74, 32}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(visible = true, transformation(origin = {-84, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedSensor annotation(
        Placement(visible = true, transformation(origin = {54, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MPC_Motor.Machines.SimplifiedPMSM simplifiedPMSM annotation(
        Placement(visible = true, transformation(origin = {0, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor annotation(
        Placement(visible = true, transformation(origin = {54, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(star.plug_p, sineVoltage.plug_p) annotation(
        Line(points = {{-64, 32}, {-40, 32}}, color = {0, 0, 255}));
      connect(ground.p, star.pin_n) annotation(
        Line(points = {{-84, 12}, {-84, 32}}, color = {0, 0, 255}));
      connect(sineVoltage.plug_n, simplifiedPMSM.plug_sp) annotation(
        Line(points = {{-20, 32}, {-6, 32}, {-6, 32}, {-6, 32}}, color = {0, 0, 255}));
      connect(simplifiedPMSM.flange, speedSensor.flange) annotation(
        Line(points = {{10, 32}, {44, 32}, {44, 32}, {44, 32}}));
      connect(speedSensor.flange, angleSensor.flange) annotation(
        Line(points = {{44, 32}, {44, 32}, {44, 2}, {44, 2}}));
      annotation(
        experiment(StartTime = 0, StopTime = 5, Tolerance = 1e-3, Interval = 1e-5),
        Icon(graphics = {Rectangle(origin = {-2, 2}, lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {10, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}})}));
    end OpenLoop_FreeAcceleration_PMSM;
    annotation(
      Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {8, 14}, lineColor = {78, 138, 73}, fillColor = {78, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-58, 46}, {42, -14}, {-58, -74}, {-58, 46}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25)}));
  end Examples;

  package Machines
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

    model SimplifiedPMSM
      extends MPC_Motor.Interfaces.PartialBasicMachine_PMSM(inertiaRotor.J = 0.0027);
      Modelica.Electrical.MultiPhase.Basic.Star star annotation(
        Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Basic.Ground ground annotation(
        Placement(visible = true, transformation(origin = {-80, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MPC_Motor.Components.simplifiedAirGap_PMSM simplifiedAirGap_PMSM annotation(
        Placement(visible = true, transformation(origin = {-32, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    equation
      connect(star.pin_n, ground.p) annotation(
        Line(points = {{-80, -34}, {-80, -34}, {-80, -48}, {-80, -48}}, color = {0, 0, 255}));
      connect(spacePhasorS.spacePhasor, simplifiedAirGap_PMSM.spacePhasor) annotation(
        Line(points = {{-54, 42}, {-32, 42}, {-32, 42}, {-32, 42}}, color = {0, 0, 255}));
      connect(simplifiedAirGap_PMSM.support, support) annotation(
        Line(points = {{-36, 32}, {-44, 32}, {-44, -100}, {-28, -100}, {-28, -100}}));
      connect(simplifiedAirGap_PMSM.flange, inertiaRotor.flange_a) annotation(
        Line(points = {{-32, 22}, {-32, 22}, {-32, 4}, {62, 4}, {62, 56}, {62, 56}}));
    end SimplifiedPMSM;
    annotation(
      Icon(graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {6.2593, 48}, points = {{53.7407, -58}, {53.7407, -93}, {-66.2593, -93}, {-66.2593, -58}}), Line(origin = {-3, 45}, points = {{-72, -55}, {-42, -55}}), Line(origin = {7, 50}, points = {{18, -10}, {53, -10}, {53, -45}}), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {8, 48}, points = {{32, -58}, {72, -58}}), Line(origin = {9, 54}, points = {{31, -49}, {71, -49}}), Line(origin = {1, 50}, points = {{-61, -45}, {-61, -10}, {-26, -10}}), Rectangle(origin = {20.3125, 82.8571}, extent = {{-45.3125, -57.8571}, {4.6875, -27.8571}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {-2, 55}, points = {{-83, -50}, {-33, -50}})}));
  end Machines;

  package Interfaces
    expandable connector DataBus
      extends Modelica.Icons.SignalBus;
      Modelica.SIunits.AngularVelocity Wm(displayUnit = "rad/s") "Actual speed";
      Modelica.SIunits.Current Is[2] "Actual current";
      Modelica.SIunits.ElectricFlux Fs[2];
      Modelica.SIunits.ElectricFlux Fr[2];
      Integer x_opt;
      Modelica.SIunits.Torque Tref;
      Modelica.SIunits.ElectricFlux Fsref;
    end DataBus;

    partial model PartialBasicMachine_IM
      Modelica.Mechanics.Rotational.Components.Inertia inertiaRotor(J = data_Motor.J) annotation(
        Placement(visible = true, transformation(origin = {62, 66}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
      Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_sp(m = data_Motor.m) annotation(
        Placement(visible = true, transformation(extent = {{-112, 48}, {-92, 68}}, rotation = 0), iconTransformation(extent = {{-78, -8}, {-58, 12}}, rotation = 0)));
      Modelica.Electrical.Machines.SpacePhasors.Components.SpacePhasor spacePhasorS(turnsRatio = 1) annotation(
        Placement(visible = true, transformation(origin = {-67, 29}, extent = {{13, 13}, {-13, -13}}, rotation = 180)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
        Placement(visible = true, transformation(extent = {{-48, 88}, {-28, 108}}, rotation = 0), iconTransformation(extent = {{98, -10}, {118, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a support annotation(
        Placement(visible = true, transformation(extent = {{-38, -110}, {-18, -90}}, rotation = 0), iconTransformation(extent = {{90, -110}, {110, -90}}, rotation = 0)));
      Modelica.Electrical.MultiPhase.Basic.Star star annotation(
        Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
        Placement(visible = true, transformation(origin = {14, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MPC_Motor.Records.Induction_Motor_record data_Motor annotation(
        Placement(visible = true, transformation(origin = {-86, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(plug_sp, spacePhasorS.plug_p) annotation(
        Line(points = {{-102, 58}, {-80, 58}, {-80, 42}}, color = {0, 0, 255}));
      connect(flange, inertiaRotor.flange_b) annotation(
        Line(points = {{-38, 98}, {-38, 88}, {62, 88}, {62, 76}}));
      connect(star.plug_p, spacePhasorS.plug_n) annotation(
        Line(points = {{-80, -14}, {-80, -14}, {-80, 16}, {-80, 16}}, color = {0, 0, 255}));
      connect(support, fixed.flange) annotation(
        Line(points = {{-28, -100}, {14, -100}, {14, -98}, {14, -98}}));
      annotation(
        Icon(graphics = {Line(visible = false, points = {{120, -100}, {110, -120}}), Line(visible = false, points = {{100, -100}, {90, -120}}), Line(visible = false, points = {{90, -100}, {80, -120}}), Line(visible = false, points = {{90, -100}, {80, -120}}), Polygon(fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-10, -20}, {40, -20}, {70, -90}, {80, -90}, {80, -100}, {-50, -100}, {-50, -90}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{80, 10}, {100, -10}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {80, -60}}), Line(visible = false, points = {{80, -100}, {120, -100}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{80, 10}, {100, -10}}), Line(visible = false, points = {{110, -100}, {100, -120}}), Line(visible = false, points = {{100, -100}, {90, -120}}), Rectangle(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, extent = {{80, -80}, {120, -120}}), Rectangle(lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-40, 70}, {40, 50}}), Polygon(fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-10, -20}, {40, -20}, {70, -90}, {80, -90}, {80, -100}, {-50, -100}, {-50, -90}}), Line(visible = false, points = {{120, -100}, {110, -120}}), Line(visible = false, points = {{80, -100}, {120, -100}}), Text(lineColor = {0, 0, 255}, extent = {{-150, -120}, {150, -160}}, textString = "%name"), Rectangle(fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {-60, -60}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {80, -60}}), Rectangle(origin = {12, 0}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-40, 70}, {40, 50}}), Text(lineColor = {0, 0, 255}, extent = {{-150, -120}, {150, -160}}, textString = "%name"), Rectangle(fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {-60, -60}}), Line(visible = false, points = {{110, -100}, {100, -120}}), Rectangle(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, extent = {{80, -80}, {120, -120}})}));
    end PartialBasicMachine_IM;

    partial model PartialInverter
      Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_p annotation(
        Placement(visible = true, transformation(origin = {87, 1}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {117, 15}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.PositivePin DC_In annotation(
        Placement(visible = true, transformation(origin = {-114, 46}, extent = {{-32, -32}, {32, 32}}, rotation = 0), iconTransformation(origin = {-115, 47}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.PositivePin DC_Out annotation(
        Placement(visible = true, transformation(origin = {-114, -14}, extent = {{-32, -32}, {32, 32}}, rotation = 0), iconTransformation(origin = {-115, -15}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      input Modelica.Blocks.Interfaces.RealInput Sa "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {-50, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      input Modelica.Blocks.Interfaces.RealInput Sb "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {-6, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      input Modelica.Blocks.Interfaces.RealInput Sc "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {35, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    equation

      annotation(
        Diagram(graphics = {Text(origin = {-87, 48}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "+"), Text(origin = {-87, -16}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "-")}),
        Icon(graphics = {Text(origin = {-87, -16}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "-"), Bitmap(origin = {47, 11}, rotation = 180, extent = {{-31, 41}, {31, -41}}, imageSource = "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"), Rectangle(lineColor = {85, 0, 255}, lineThickness = 0.75, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, -63}, lineColor = {85, 85, 255}, extent = {{-56, 13}, {56, -13}}, textString = "TwoLevelVSI"), Text(origin = {-87, 48}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "+"), Line(origin = {-1, 14}, points = {{-93, 80}, {93, -80}, {93, -80}}, color = {0, 0, 255})}));
    end PartialInverter;

    partial model PartialInverterBoolean
      Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_p annotation(
        Placement(visible = true, transformation(origin = {135, 15}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {117, 15}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.PositivePin DC_In annotation(
        Placement(visible = true, transformation(origin = {-114, 46}, extent = {{-32, -32}, {32, 32}}, rotation = 0), iconTransformation(origin = {-115, 47}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.NegativePin DC_Out annotation(
        Placement(visible = true, transformation(origin = {-114, -22}, extent = {{-30, -30}, {30, 30}}, rotation = 0), iconTransformation(origin = {-115, -15}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
      input Modelica.Blocks.Interfaces.BooleanInput Sa "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {-50, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      input Modelica.Blocks.Interfaces.BooleanInput Sb "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {-6, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      input Modelica.Blocks.Interfaces.BooleanInput Sc "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {35, 111}, extent = {{-11, -11}, {11, 11}}, rotation = -90), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    equation

      annotation(
        Diagram(graphics = {Text(origin = {-87, 48}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "+"), Text(origin = {-87, -16}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "-")}),
        Icon(graphics = {Text(origin = {-87, -16}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "-"), Bitmap(origin = {47, 11}, rotation = 180, extent = {{-31, 41}, {31, -41}}, imageSource = "/9j/4AAQSkZJRgABAQEAZABkAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wAARCAEsASwDASIAAhEBAxEB/8QAHQABAAICAwEBAAAAAAAAAAAAAAcIBgkDBAUBAv/EAEAQAAEDAgMGAwQIAwcFAAAAAAABAgMEBQYHERIhMUFRYQgTgSIyYnEUI0JScpGhsRUzoiRDY4KSweElc8LR0v/EABQBAQAAAAAAAAAAAAAAAAAAAAD/xAAUEQEAAAAAAAAAAAAAAAAAAAAA/9oADAMBAAIRAxEAPwC1IAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVURNV4AAQ9mL4gMJYSdLS0Ei3y5s3eTRvTymL0dLvT/TtL1RCt+MfETjnEL5I6OrjstG7ckVAmy/TvIurtfkqfIC9lVUwUkSy1U0cMacXyORqJ6qeM/GeF43ox+I7K168GrXRIq/1Gta6XSuutR59yrKmrnXjJUSukcvqq6nSA2mUNdS18Pm0NTBUxffhkR7fzQ7Bq4tV0rrTVJU2ysqaOoThLTyujenq1dSZsA+I/F9hfHDfHR36gboipUexOidpETev4kcBeEGA5b5sYWx/EjLRWeRcUTV9BU6MmTqqJro5O7VXvoZ8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAiXOvOa2Ze07qGjSOvxFI3VlNtexAi8HSqnDqjU3r2TeBmOP8eWHAdoWvxDWJFtapDTs9qWdycmN5/PgnNUKZ5sZ5YjxxJLRwOdarE7clHA/R0qf4r03u+SaN7LxI5xZiW64svM10v1ZLV1kq73vXc1OTWpwa1OibiUcmsiLzjfyrldHSWvD7lRUmc362dP8ACavL4l3dNQImsVmuF+uMdBZ6OorayT3IYI1e5e+icu5YXAXhbutaxlTjK5MtsbtF+iUqJLNpzRX+61fltFm8EYKsOCbYlFh2gipmKieZLptSzL1e/iv7JyRDIwIww9kRl7ZI2bNiZXyt4y173TK75tX2PyaZZFgTCMUKxR4WsTY1TRWpb4URfTZMjAEXYoyHwBf43qllbbKh3Ca3O8lW/Jm9n9JXbMrw3Yjw7FJWYdl/jtAzerIo9moYn4NV2v8AKuvZC7QA1bwy1NrrWywSSwVUL9WuaqsfG5F5Km9FRSz2SPiMc58NlzBlbsbmQ3XTenRJk/8ANPXmpKmcGS1ix/BLWQMZbsQI3VlZG3Rsq8klanvfi95N3FE0KRY4wheME3yW1YgpXU9S3e13FkreT2O5ov8Awui6oBswgmjqIWTQPZJFI1HMexdWuRd6Ki80P2UhyBzuqsGTxWXED5KjDT3IjXe8+jVftN6s6t9U36ot16Grp6+jhq6KaOemmYkkcsbkc17VTVFRU4oBzgAAAAAAAAAAAAAAAAAAAAAAAAAAAAABwV0MlRRzwwzvppZI3MZMxEV0aqmiORFRU1TjvRUAhXxAZ1Q4KglsWHXxzYkkb7Ui6OZRovBVTm9U4N5cV5ItKamoq7xXyT1Ms1TWTyK573qr3yPcvNeKqqmc5vZc4jwbil0F486vbWyufT17UVyVTlX1Xb1Xe1d+vVNFLI+H3JCHC0VNiHFULZcQOTbgpnaObRovNesnf7PLfvAx7Inw9x07ae/49g8yddJKe1PTVrOaOmTmvwcE568Es6xqMajWoiNTciInA+gAAAAAAAAAYnmTgOz5gYffbL1Fo9urqeqYieZTv+81enVOC/kqZYANbGZmA7tl7iOS03liORUV9PUMT6uePXc5v+6cUX0VZJ8O2csuDK9lkv8AK9+Gqh+jXKquWjeq+8nwLzT1TfrrbLMzAtqzAw1LarszZemr6apamr6eTTc5O3VOaeipr5x5hG6YIxJU2W9RbFTEurXt9yVi+69q82r/AO0XeioBsvgmjqIY5oHskikaj2PY5FRyKmqKipxQ/ZUzwsZvLTT0+CsRTL9Gkds22oe7+W5f7lyryX7PRd3BU0tmAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAcNTS09V5X0mCKbynpLH5jEdsPTg5NeCp1OYAAAAAAAAAAAAAAAEa55ZZUuYuGXMiayK+UjXPoqhd2q843L9136LovVFkoAaua6kqrPcJqWrikp62nkWOSN6K10b2roqL31LveG3NNuN8PJabvPriK3xoj1cu+piTckn4k3I7vovPdjHioyoW70kmMbBArrjTsT6fCxu+aJqbpETm5qcerU7b6oYXv9wwxfKS72ad0FdTPR8b0X80VOaKm5U5ooGz4GE5S5hW7MTC8dxolbFWxaR1lJr7UEn/yu9UXmndFQzYAAAAAAAAAAAAAAAhbOLPa3YDvVJabdTx3SvbIjq9iSaJBH91FT+8Xjpy58STMFYstGM7DDdrDVNnpZNzk4PidzY9vJydPVNUVFA90AAAAAAAAAAAAAAAAAAAAAAAAAAAAAVEVNF4FMfExk6/DlfLifDlP/ANCqH61MEbd1JIq8UTlGq8OSKunDQuccNZSwVtLNTVcUc1PMxY5IpGo5r2qmioqLxQDW1lxje64BxJDeLNJ7bfZmhcvsTx82OTp34ou9DYDlvjq0Y/w7HdbNLoqaNqKZ6/WU7/uuT9l4KhUfxBZL1GCa194sTJJsMzP6K51G5fsO6t6O9F36KsbZd44vGAcQR3WxTbL9zZoXL9XOzmx6c078U4oBsrBgmVeZtjzEtKT2yXybhG1FqaGR31kS9U+83Xg5PXRdxnYAAAAAAAOtc7hSWuhmrblUw0tJC3akmmejGMTqqqB2SvHiAz1iw8yow9g6dkt6XWOorGaOZS9Wt5LJ+jfnwwfPDxD1F2bPZMCvlpbc7Vk1xRVZLMnNI+bG9/eXtzrzabbW3u4wUNrppqqtnfsRwxNVznqvb/cD41tVd69GtSaprJ5NERNZHyvcv5qqr+5eDw5ZVT4Bs81xvE0qXq4saktM2RfLgYi6o1UTc5/V3LgnNV4shclKTA0Ed4vrY6rEsjd2ntMo0VN7WdXcld6Ju1VZrAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4aylgraWWmq4Y56eZiskikajmvaqaKiovFCnWe+QNXh+SovuDopKqyb5JqRur5aVOapzcxPzTnrxLlgDV5YbzcLBc4bjZ6uakrYXbUc0Ltlzf+F5pwUtnlT4lLfcGRW/HjEoaxNGpcIm6wyd3tTexe6ap+FD283vD5aMVvmumGHRWi9P8AafHs6U869XIiasd8SbuqKq6lRcY4Iv8Ag24LR4jt09HIq+w9zdqOTux6bnei/MDZRQ1lNcKSOqoaiGpppE2mSwvR7HJ1RU3Kc5rPwpjfEeEp1lw5d6ugVV1cyN+sb1+Ji6td6oSxafFJjWkiSOuorPX6J/MfC+N6/PZcjf0AuwfHuaxqueqNaiaqqroiIUmufijxxVRuZS0lloteD4qd7nJ/reqfoRnizMbFmLdW3++VtVCq6rB5mxFr/wBtujf0AuJmN4gMJYTbLTW2ZL7dG6okNG9Fiavxy70T/LtL8ipGZGaWJMwKzzL1VbFGx2sVDAqthj77P2nfE7VfkYpY7Ncb7XsorPRVNdVv92GniWRy99E5dyyWVvhjqZXR12P6jyIV0d/DaZ+r3dpJE3N+TdV7oBB2XeXV/wAf3RKOwUqvjaqJPVSJswwJ1c7r2TVV6F38pcqbHlzb/wCxt+l3aVulRXytTbd8LE+y3snHmq7jNbFZrdYbZDbrNRwUVFCmjIYW7LU7916qu9TvgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6l1tlDd6GSiutHT1lJImj4aiNJGO+aLuO2AILxd4Z8H3h75rLNWWSd29GxO86HX8Dt/ojkQjKv8J1/ZKqW/Edrnj5OnikiX8k2v3LggCoNB4Tb096JX4mt0DOaw075V/JVb+5ImGfDDhG3PbLe6y4XiROLHOSCJfRvtf1E9ADycOYcs2GqL6JYLZSW+Dm2niRu13cvFy911U9YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP/Z"), Rectangle(lineColor = {85, 0, 255}, lineThickness = 0.75, extent = {{-100, 100}, {100, -100}}), Text(origin = {-8, -63}, lineColor = {85, 85, 255}, extent = {{-56, 13}, {56, -13}}, textString = "TwoLevelVSI"), Text(origin = {-87, 48}, lineColor = {85, 0, 255}, extent = {{-11, 14}, {11, -14}}, textString = "+"), Line(origin = {-1, 14}, points = {{-93, 80}, {93, -80}, {93, -80}}, color = {0, 0, 255})}));
    end PartialInverterBoolean;

    partial model PartialMPC_IM
      Modelica.Blocks.Interfaces.RealInput Fs[2] annotation(
        Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Fr[2] annotation(
        Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
        Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Tref annotation(
        Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Fsref annotation(
        Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Ws annotation(
        Placement(visible = true, transformation(origin = {13, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanInput Sa annotation(
        Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanInput Sb annotation(
        Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanInput Sc annotation(
        Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      MPC_Motor.Records.MPC_IM_Record data_MPC annotation(
        Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation

      annotation(
        Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {26, 206, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-153, 59}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fr"), Text(origin = {-147, -17}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fs"), Text(origin = {-75, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Is"), Text(origin = {-37, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Tref"), Text(origin = {3, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fsref"), Text(origin = {45, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Ws"), Text(origin = {7, -143}, lineColor = {255, 85, 0}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Opt"), Text(origin = {155, 67}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sc"), Text(origin = {155, -53}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sa"), Text(origin = {155, 7}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sb")}));
    end PartialMPC_IM;

    partial model PartialMPC_PMSM
      Modelica.Blocks.Interfaces.RealInput id_ref annotation(
        Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput iq_ref annotation(
        Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Wm annotation(
        Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Idq[2] annotation(
        Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput phi annotation(
        Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanInput Sa annotation(
        Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanInput Sb annotation(
        Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanInput Sc annotation(
        Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    equation

      annotation(
        Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {26, 206, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-153, 59}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fr"), Text(origin = {-147, -17}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fs"), Text(origin = {-75, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Is"), Text(origin = {-37, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Tref"), Text(origin = {3, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fsref"), Text(origin = {45, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Ws"), Text(origin = {7, -143}, lineColor = {255, 85, 0}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Opt"), Text(origin = {155, 67}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sc"), Text(origin = {155, -53}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sa"), Text(origin = {155, 7}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sb")}));
    end PartialMPC_PMSM;

    partial model PartialBasicMachine_PMSM
      Modelica.Mechanics.Rotational.Components.Inertia inertiaRotor(J = data_Motor.J) annotation(
        Placement(visible = true, transformation(origin = {62, 66}, extent = {{10, 10}, {-10, -10}}, rotation = 270)));
      Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_sp(m = data_Motor.m) annotation(
        Placement(visible = true, transformation(extent = {{-112, 48}, {-92, 68}}, rotation = 0), iconTransformation(extent = {{-78, -8}, {-58, 12}}, rotation = 0)));
      Modelica.Electrical.Machines.SpacePhasors.Components.SpacePhasor spacePhasorS(turnsRatio = 1) annotation(
        Placement(visible = true, transformation(origin = {-67, 29}, extent = {{13, 13}, {-13, -13}}, rotation = 180)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
        Placement(visible = true, transformation(extent = {{-48, 88}, {-28, 108}}, rotation = 0), iconTransformation(extent = {{98, -10}, {118, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a support annotation(
        Placement(visible = true, transformation(extent = {{-38, -110}, {-18, -90}}, rotation = 0), iconTransformation(extent = {{90, -110}, {110, -90}}, rotation = 0)));
      Modelica.Electrical.MultiPhase.Basic.Star star annotation(
        Placement(visible = true, transformation(origin = {-80, -24}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Mechanics.Rotational.Components.Fixed fixed annotation(
        Placement(visible = true, transformation(origin = {14, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      MPC_Motor.Records.Induction_Motor_record data_Motor annotation(
        Placement(visible = true, transformation(origin = {-86, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      connect(plug_sp, spacePhasorS.plug_p) annotation(
        Line(points = {{-102, 58}, {-80, 58}, {-80, 42}}, color = {0, 0, 255}));
      connect(flange, inertiaRotor.flange_b) annotation(
        Line(points = {{-38, 98}, {-38, 88}, {62, 88}, {62, 76}}));
      connect(star.plug_p, spacePhasorS.plug_n) annotation(
        Line(points = {{-80, -14}, {-80, -14}, {-80, 16}, {-80, 16}}, color = {0, 0, 255}));
      connect(support, fixed.flange) annotation(
        Line(points = {{-28, -100}, {14, -100}, {14, -98}, {14, -98}}));
      annotation(
        Icon(graphics = {Line(visible = false, points = {{120, -100}, {110, -120}}), Line(visible = false, points = {{100, -100}, {90, -120}}), Line(visible = false, points = {{90, -100}, {80, -120}}), Line(visible = false, points = {{90, -100}, {80, -120}}), Polygon(fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-10, -20}, {40, -20}, {70, -90}, {80, -90}, {80, -100}, {-50, -100}, {-50, -90}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{80, 10}, {100, -10}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {80, -60}}), Line(visible = false, points = {{80, -100}, {120, -100}}), Rectangle(fillColor = {95, 95, 95}, fillPattern = FillPattern.HorizontalCylinder, extent = {{80, 10}, {100, -10}}), Line(visible = false, points = {{110, -100}, {100, -120}}), Line(visible = false, points = {{100, -100}, {90, -120}}), Rectangle(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, extent = {{80, -80}, {120, -120}}), Rectangle(lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-40, 70}, {40, 50}}), Polygon(fillPattern = FillPattern.Solid, points = {{-50, -90}, {-40, -90}, {-10, -20}, {40, -20}, {70, -90}, {80, -90}, {80, -100}, {-50, -100}, {-50, -90}}), Line(visible = false, points = {{120, -100}, {110, -120}}), Line(visible = false, points = {{80, -100}, {120, -100}}), Text(lineColor = {0, 0, 255}, extent = {{-150, -120}, {150, -160}}, textString = "%name"), Rectangle(fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {-60, -60}}), Rectangle(fillColor = {0, 128, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {80, -60}}), Rectangle(origin = {12, 0}, lineColor = {95, 95, 95}, fillColor = {95, 95, 95}, fillPattern = FillPattern.Solid, extent = {{-40, 70}, {40, 50}}), Text(lineColor = {0, 0, 255}, extent = {{-150, -120}, {150, -160}}, textString = "%name"), Rectangle(fillColor = {128, 128, 128}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-40, 60}, {-60, -60}}), Line(visible = false, points = {{110, -100}, {100, -120}}), Rectangle(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, extent = {{80, -80}, {120, -120}})}));
    end PartialBasicMachine_PMSM;
    annotation(
      Icon(graphics = {Polygon(origin = {20, 0}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10, 70}, {10, 70}, {40, 20}, {80, 20}, {80, -20}, {40, -20}, {10, -70}, {-10, -70}, {-10, 70}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(fillColor = {102, 102, 102}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-100, 20}, {-60, 20}, {-30, 70}, {-10, 70}, {-10, -70}, {-30, -70}, {-60, -20}, {-100, -20}, {-100, 20}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Polygon(origin = {20, 0}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10, 70}, {10, 70}, {40, 20}, {80, 20}, {80, -20}, {40, -20}, {10, -70}, {-10, -70}, {-10, 70}}), Polygon(fillColor = {102, 102, 102}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-100, 20}, {-60, 20}, {-30, 70}, {-10, 70}, {-10, -70}, {-30, -70}, {-60, -20}, {-100, -20}, {-100, 20}})}));
  end Interfaces;

  package Components
    model simplifiedAirGap_IM
      Modelica.Electrical.Machines.Interfaces.SpacePhasor spacePhasor annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
        Placement(visible = true, transformation(extent = {{-8, 92}, {12, 112}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a support annotation(
        Placement(visible = true, transformation(extent = {{-6, -104}, {14, -84}}, rotation = 0), iconTransformation(extent = {{-4, -56}, {16, -36}}, rotation = 0)));
      import Modelica.Math;
      import Modelica.Constants;
      import Modelica.ComplexMath;
      Modelica.SIunits.ElectricCurrent Is_alpha "Connector of Real output signal";
      Modelica.SIunits.ElectricCurrent Is_beta "Connector of Real output signal";
      Complex Fs;
      Complex Is;
      Complex Ir;
      Modelica.SIunits.ElectricCurrent Ir_alpha(start = 0);
      Modelica.SIunits.ElectricCurrent Ir_beta(start = 0);
      Complex Fr;
      Modelica.SIunits.ElectricFlux Fs_alpha;
      Modelica.SIunits.ElectricFlux Fs_beta;
      Modelica.SIunits.ElectricFlux Fr_alpha;
      Modelica.SIunits.ElectricFlux Fr_beta;
      Modelica.SIunits.AngularFrequency Ws;
      Records.Induction_Motor_record data_Motor annotation(
        Placement(visible = true, transformation(origin = {-10, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Real y;
    equation
// All dynamic equations are modelled in stator reference frame
      der(y) = spacePhasor.v_[1];
      spacePhasor.v_[1] = data_Motor.Rs * Is_alpha + der(Fs_alpha);
      spacePhasor.v_[2] = data_Motor.Rs * Is_beta + der(Fs_beta);
      0 = data_Motor.Rr * Ir_alpha + der(Fr_alpha) + Ws * Fr_beta;
      0 = data_Motor.Rr * Ir_beta + der(Fr_beta) - Ws * Fr_alpha;
      Fs_alpha = data_Motor.Ls * Is_alpha + data_Motor.Lm * Ir_alpha;
      Fs_beta = data_Motor.Ls * Is_beta + data_Motor.Lm * Ir_beta;
      Fr_alpha = data_Motor.Lm * Is_alpha + data_Motor.Lr * Ir_alpha;
      Fr_beta = data_Motor.Lm * Is_beta + data_Motor.Lr * Ir_beta;
      Is = Complex(Is_alpha, Is_beta);
      Ir = Complex(Ir_alpha, Ir_beta);
      Fs = data_Motor.Ls * Is + data_Motor.Lm * Ir;
      Fr = data_Motor.Lm * Is + data_Motor.Ls * Is;
      spacePhasor.i_[1] = Is_alpha;
      spacePhasor.i_[2] = Is_beta;
      der(flange.phi - support.phi) * data_Motor.P = Ws;
      flange.tau = -1.5 * data_Motor.P * (Fs_alpha * Is_beta - Fs_beta * Is_alpha);
      support.tau = -flange.tau;
      annotation(
        Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {70, -30}}), Line(points = {{-90, 0}, {-70, 0}}), Line(points = {{-70, 10}, {70, 10}}, color = {0, 0, 255}), Line(points = {{-70, -30}, {70, -30}}, color = {0, 0, 255}), Line(points = {{-70, -10}, {70, -10}}, color = {0, 0, 255}), Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}), Line(points = {{80, 20}, {80, -20}}, color = {0, 0, 255}), Line(points = {{90, 14}, {90, -14}}, color = {0, 0, 255}), Line(points = {{100, 8}, {100, -8}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
        Documentation(info = "<html> </html>"));
    end simplifiedAirGap_IM;

    model TwoLevelInverterRealOutput
      extends MPC_Motor.Interfaces.PartialInverter;
    equation
      DC_In.i + DC_Out.i = 0;
      DC_In.i = Sa * Plug_p.pin[1].i + Sb * Plug_p.pin[2].i + Sc * Plug_p.pin[3].i;
      Plug_p.pin[1].v = Sa * (DC_In.v - DC_Out.v);
      Plug_p.pin[2].v = Sb * (DC_In.v - DC_Out.v);
      Plug_p.pin[3].v = Sc * (DC_In.v - DC_Out.v);
    end TwoLevelInverterRealOutput;

    model TwoLevelInverterBooleanOutput
      extends MPC_Motor.Interfaces.PartialInverterBoolean;
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch annotation(
        Placement(visible = true, transformation(origin = {-50, 56}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch annotation(
        Placement(visible = true, transformation(origin = {-24, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1 annotation(
        Placement(visible = true, transformation(origin = {10, 56}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch2 annotation(
        Placement(visible = true, transformation(origin = {-22, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch3 annotation(
        Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch4 annotation(
        Placement(visible = true, transformation(origin = {12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      Modelica.Blocks.Logical.Not not1 annotation(
        Placement(visible = true, transformation(origin = {-37, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
      Modelica.Blocks.Logical.Not not2 annotation(
        Placement(visible = true, transformation(origin = {7, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
      Modelica.Blocks.Logical.Not not3 annotation(
        Placement(visible = true, transformation(origin = {49, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
      MPC_Motor.Components.pins_pToPlug Connector annotation(
        Placement(visible = true, transformation(origin = {78, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
      Modelica.Electrical.Analog.Sensors.PowerSensor powerSensor annotation(
        Placement(visible = true, transformation(origin = {-74, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Math.Mean mean(f = 1) annotation(
        Placement(visible = true, transformation(origin = {-106, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    equation
// DC_In.i + DC_Out.i = 0;
// DC_In.i = Ma * Plug_p.pin[1].i + Mb * Plug_p.pin[2].i + Mc * Plug_p.pin[3].i;
//  Plug_p.pin[1].v = Ma * (DC_In.v - DC_Out.v);
//  Plug_p.pin[2].v = Mb * (DC_In.v - DC_Out.v);
//  Plug_p.pin[3].v = Mc * (DC_In.v - DC_Out.v);
      connect(switch.p, idealClosingSwitch.p) annotation(
        Line(points = {{-50, 66}, {-24, 66}, {-24, 64}, {-24, 64}, {-24, 64}}, color = {0, 0, 255}));
      connect(idealClosingSwitch.p, idealClosingSwitch1.p) annotation(
        Line(points = {{-24, 64}, {10, 64}, {10, 66}, {10, 66}}, color = {0, 0, 255}));
      connect(switch.n, idealClosingSwitch3.p) annotation(
        Line(points = {{-50, 46}, {-48, 46}, {-48, 10}, {-48, 10}, {-48, 10}}, color = {0, 0, 255}));
      connect(idealClosingSwitch.n, idealClosingSwitch2.p) annotation(
        Line(points = {{-24, 44}, {-22, 44}, {-22, 8}, {-22, 8}}, color = {0, 0, 255}));
      connect(idealClosingSwitch1.n, idealClosingSwitch4.p) annotation(
        Line(points = {{10, 46}, {12, 46}, {12, 10}, {12, 10}}, color = {0, 0, 255}));
      connect(idealClosingSwitch3.n, idealClosingSwitch4.n) annotation(
        Line(points = {{-48, -10}, {-48, -10}, {-48, -24}, {12, -24}, {12, -10}, {12, -10}}, color = {0, 0, 255}));
      connect(idealClosingSwitch2.n, idealClosingSwitch3.n) annotation(
        Line(points = {{-22, -12}, {-22, -12}, {-22, -24}, {-48, -24}, {-48, -10}, {-48, -10}}, color = {0, 0, 255}));
      connect(Sa, not1.u) annotation(
        Line(points = {{-50, 112}, {-50, 112}, {-50, 84}, {-42, 84}, {-42, 86}}, color = {255, 0, 255}));
      connect(Sb, not2.u) annotation(
        Line(points = {{-6, 112}, {-6, 112}, {-6, 86}, {2, 86}, {2, 86}}, color = {255, 0, 255}));
      connect(Sc, not3.u) annotation(
        Line(points = {{35, 111}, {35, 111}, {35, 83}, {43, 83}, {43, 85}}, color = {255, 0, 255}));
      connect(switch.control, Sa) annotation(
        Line(points = {{-38, 56}, {-38, 56}, {-38, 74}, {-50, 74}, {-50, 116}, {-50, 116}}, color = {255, 0, 255}));
      connect(idealClosingSwitch.control, Sb) annotation(
        Line(points = {{-12, 54}, {-12, 54}, {-12, 76}, {-6, 76}, {-6, 116}, {-6, 116}}, color = {255, 0, 255}));
      connect(idealClosingSwitch1.control, Sc) annotation(
        Line(points = {{22, 56}, {36, 56}, {36, 108}, {36, 108}, {36, 116}}, color = {255, 0, 255}));
      connect(not1.y, idealClosingSwitch3.control) annotation(
        Line(points = {{-31.5, 89}, {-33.5, 89}, {-33.5, -1}, {-35.5, -1}}, color = {255, 0, 255}));
      connect(not2.y, idealClosingSwitch2.control) annotation(
        Line(points = {{12.5, 89}, {14.5, 89}, {14.5, 71}, {-9.5, 71}, {-9.5, -3}, {-9.5, -3}}, color = {255, 0, 255}));
      connect(not3.y, idealClosingSwitch4.control) annotation(
        Line(points = {{54.5, 89}, {52.5, 89}, {52.5, -1}, {24.5, -1}, {24.5, -1}}, color = {255, 0, 255}));
      connect(DC_Out, idealClosingSwitch2.n) annotation(
        Line(points = {{-114, -22}, {-22, -22}, {-22, -16}, {-22, -16}}, color = {0, 0, 255}));
      connect(Connector.R, idealClosingSwitch3.p) annotation(
        Line(points = {{64.8, 26}, {-47.2, 26}, {-47.2, 10}, {-47.2, 10}, {-47.2, 10}}, color = {0, 0, 255}));
      connect(Connector.Y, idealClosingSwitch2.p) annotation(
        Line(points = {{64.8, 19.2}, {-23.2, 19.2}, {-23.2, 9.2}, {-21.2, 9.2}, {-21.2, 7.2}}, color = {0, 0, 255}));
      connect(Connector.B, idealClosingSwitch4.p) annotation(
        Line(points = {{64.8, 12.4}, {12.8, 12.4}, {12.8, 10.4}, {12.8, 10.4}, {12.8, 10.4}}, color = {0, 0, 255}));
      connect(Connector.Plug_p, Plug_p) annotation(
        Line(points = {{85.2, 19.6}, {131.2, 19.6}, {131.2, 19.6}, {135.2, 19.6}}, color = {0, 0, 255}));
      connect(powerSensor.nc, switch.p) annotation(
        Line(points = {{-64, 66}, {-50, 66}, {-50, 66}, {-50, 66}}, color = {0, 0, 255}));
      connect(powerSensor.pc, DC_In) annotation(
        Line(points = {{-84, 66}, {-108, 66}, {-108, 46}, {-114, 46}}, color = {0, 0, 255}));
      connect(powerSensor.nv, DC_Out) annotation(
        Line(points = {{-74, 56}, {-76, 56}, {-76, -14}, {-114, -14}, {-114, -22}}, color = {0, 0, 255}));
      connect(powerSensor.pv, DC_In) annotation(
        Line(points = {{-74, 76}, {-110, 76}, {-110, 46}, {-114, 46}}, color = {0, 0, 255}));
      connect(mean.u, powerSensor.power) annotation(
        Line(points = {{-94, 88}, {-84, 88}, {-84, 56}, {-84, 56}}, color = {0, 0, 127}));
      annotation(
        Diagram);
    end TwoLevelInverterBooleanOutput;

    model pins_pToPlug
      Modelica.Electrical.Analog.Interfaces.PositivePin R "R-phase pole" annotation(
        Placement(visible = true, transformation(extent = {{-42, 6}, {-22, 26}}, rotation = 0), iconTransformation(extent = {{-76, 20}, {-56, 40}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.PositivePin Y "Y-phase pole" annotation(
        Placement(visible = true, transformation(extent = {{-42, -14}, {-22, 6}}, rotation = 0), iconTransformation(extent = {{-76, -14}, {-56, 6}}, rotation = 0)));
      Modelica.Electrical.Analog.Interfaces.PositivePin B "B-phase pole" annotation(
        Placement(visible = true, transformation(extent = {{-42, -36}, {-22, -16}}, rotation = 0), iconTransformation(extent = {{-76, -48}, {-56, -28}}, rotation = 0)));
      Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_p annotation(
        Placement(visible = true, transformation(extent = {{8, -12}, {28, 8}}, rotation = 0), iconTransformation(extent = {{26, -12}, {46, 8}}, rotation = 0)));
    equation
      connect(R, Plug_p.pin[1]);
      connect(Y, Plug_p.pin[2]);
      connect(B, Plug_p.pin[3]);
      annotation(
        Icon(graphics = {Rectangle(origin = {28.6667, -9}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {170, 213, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-55.3333, 67}, {110.667, -67}}), Text(origin = {-16, 20}, lineColor = {0, 0, 255}, extent = {{-150, 40}, {150, 80}}, textString = "%name"), Ellipse(origin = {16, -2}, rotation = 180, fillColor = {170, 213, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 20}, {0, -20}}, endAngle = 360), Rectangle(origin = {1.01, -9}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-83.15, 67.06}, {83.15, -67.06}})}));
    end pins_pToPlug;

    model SignalGenerator
      Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
        Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, 50}, {120, 30}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
        Placement(visible = true, transformation(origin = {110, -4}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, 8}, {120, -12}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
        Placement(visible = true, transformation(origin = {112, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, -40}, {120, -60}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput i(start = 1, fixed = true) annotation(
        Placement(visible = true, transformation(origin = {6, -112}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {4, -110}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
      parameter Real Ts = 0.02;
      parameter Boolean X[6, 3] = {{true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}};
      //  parameter Real X[6, 3] = {{1, 0, 0}, {1, 0, 1}, {0, 0, 1}, {0, 1, 1}, {0, 1, 0}, {1, 1, 0}};
    algorithm
      when sample(0, Ts / 6) then
        Sa := X[i, 1];
        Sb := X[i, 2];
        Sc := X[i, 3];
        i := if i == 6 then 1 else pre(i) + 1;
      end when;
      annotation(
        Icon(graphics = {Rectangle(origin = {-2, -1}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-100, 101}, {100, -101}}), Ellipse(origin = {-5, -1}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-67, 69}, {67, -69}}, endAngle = 360), Text(origin = {-8, 3}, extent = {{-28, 29}, {28, -29}}, textString = "S")}));
    end SignalGenerator;

    model simplifiedAirGap_PMSM
      Modelica.Electrical.Machines.Interfaces.SpacePhasor spacePhasor annotation(
        Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
        Placement(visible = true, transformation(extent = {{-8, 92}, {12, 112}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
      Modelica.Mechanics.Rotational.Interfaces.Flange_a support annotation(
        Placement(visible = true, transformation(extent = {{-6, -104}, {14, -84}}, rotation = 0), iconTransformation(extent = {{-4, -56}, {16, -36}}, rotation = 0)));
      import Modelica.Math;
      import Modelica.Constants;
      //Machine Parameters
      constant Real Rs = 0.0485;
      constant Real Ls = 0.000395;
      constant Real P = 1;
      constant Real J = 0.0027;
      constant Real B = 0.0004924;
      constant Real Lambda_m = 0.1194;
      Modelica.SIunits.Voltage Vdq[2];
      Modelica.SIunits.Current Idq[2];
      Modelica.SIunits.AngularFrequency Ws;
      Modelica.SIunits.Angle angle;
      Real RotationMatrix[2, 2] = {{+cos(-angle), -sin(-angle)}, {+sin(-angle), +cos(-angle)}};
    equation
// All dynamic equations are modelled in stator reference frame
      angle = flange.phi - support.phi;
      Vdq = RotationMatrix * spacePhasor.v_;
      Idq = RotationMatrix * spacePhasor.i_;
      Vdq[1] = Rs * Idq[1] + Ls * der(Idq[1]) - Ls * Ws * Idq[2];
      Vdq[2] = Rs * Idq[2] + Ls * der(Idq[2]) + Ls * Ws * Idq[1] + Lambda_m * Ws;
      der(angle) * P = Ws;
      flange.tau = -1.5 * Lambda_m * Idq[2];
      support.tau = -flange.tau;
      annotation(
        Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {70, -30}}), Line(points = {{-90, 0}, {-70, 0}}), Line(points = {{-70, 10}, {70, 10}}, color = {0, 0, 255}), Line(points = {{-70, -30}, {70, -30}}, color = {0, 0, 255}), Line(points = {{-70, -10}, {70, -10}}, color = {0, 0, 255}), Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}), Line(points = {{80, 20}, {80, -20}}, color = {0, 0, 255}), Line(points = {{90, 14}, {90, -14}}, color = {0, 0, 255}), Line(points = {{100, 8}, {100, -8}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
        Documentation(info = "<html> </html>"));
    end simplifiedAirGap_PMSM;
    annotation(
      Icon(graphics = {Ellipse(origin = {10, 10}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{0, 0}, {60, 60}}, endAngle = 360), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Ellipse(origin = {10, 10}, fillColor = {76, 76, 76}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {-20, -20}}, endAngle = 360), Ellipse(origin = {10, 10}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-80, 0}, {-20, 60}}, endAngle = 360), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Ellipse(origin = {10, 10}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{0, -80}, {60, -20}}, endAngle = 360), Ellipse(origin = {10, 10}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{0, 0}, {60, 60}}, endAngle = 360), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Ellipse(origin = {10, 10}, fillColor = {76, 76, 76}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-80, -80}, {-20, -20}}, endAngle = 360), Ellipse(origin = {10, 10}, lineColor = {128, 128, 128}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-80, 0}, {-20, 60}}, endAngle = 360), Ellipse(origin = {10, 10}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{0, -80}, {60, -20}}, endAngle = 360)}));
  end Components;

  package Blocks
    block Predictive_Controller_IM
      import MPC_Motor.Functions;
      Modelica.Blocks.Interfaces.RealInput Fs[2] annotation(
        Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Fr[2] annotation(
        Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
        Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Tref annotation(
        Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-39, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Fsref annotation(
        Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Ws annotation(
        Placement(visible = true, transformation(origin = {13, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
        Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
        Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
        Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      MPC_Motor.Records.MPC_IM_Record data_MPC annotation(
        Placement(visible = true, transformation(origin = {-188, -76}, extent = {{-24, -24}, {24, 24}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput x_opt_in "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {0, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      Integer indices[8];
      Real sort_Array[8];
      Real cost_Array[8];
      Real Isp_beta;
      Real Isp_alpha;
      discrete Integer x_opt_out(start = 1);
    algorithm
      when sample(0, data_MPC.Ts) then
        (cost_Array, Isp_beta, Isp_alpha) := Functions.MPC_Test_IM(Tref, Fsref, Ws, Fr, Fs, Is, x_opt_in, data_MPC);
        (sort_Array, indices) := Modelica.Math.Vectors.sort(cost_Array, ascending = true);
        x_opt_out := indices[1];
        if noEvent(Is[1] > 25 and Is[1] < 25.2) then
          x_opt_in := 1;
        else
          x_opt_in := x_opt_out;
        end if;
      end when;
      Sa := data_MPC.states[x_opt_in, 1];
      Sb := data_MPC.states[x_opt_in, 2];
      Sc := data_MPC.states[x_opt_in, 3];
      annotation(
        Icon(graphics = {Rectangle(origin = {4, 2}, lineColor = {48, 255, 221}, fillColor = {221, 221, 221}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-156, 58}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fr"), Text(origin = {53.7266, 152.043}, lineColor = {85, 0, 255}, extent = {{15.8633, -17.5658}, {-15.8633, 17.5658}}, textString = "Ws"), Text(origin = {3, 158}, lineColor = {85, 0, 255}, extent = {{25, -56}, {-25, 56}}, textString = "Fsref"), Text(origin = {-40, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Tr"), Text(origin = {-84, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Is"), Text(origin = {-154, -16}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fs"), Text(origin = {152, 68}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sc"), Text(origin = {154, -52}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sa"), Text(origin = {155, 10}, lineColor = {255, 0, 255}, extent = {{17, -16}, {-17, 16}}, textString = "Sb"), Text(origin = {0, -138}, lineColor = {255, 85, 0}, extent = {{12, -16}, {-12, 16}}, textString = "Opt"), Ellipse(origin = {4.69854, -3.63424}, lineColor = {85, 170, 127}, pattern = LinePattern.Dot, lineThickness = 2, extent = {{-82.6985, 77.6342}, {82.6985, -77.6342}}), Text(extent = {{-20, 14}, {-20, 14}}, textString = "MPC", fontName = "Mongolian Baiti"), Text(origin = {0, -3}, lineThickness = 2.25, extent = {{-44, 23}, {44, -23}}, textString = "MPC", fontSize = 36, fontName = "Segoe Script")}));
    end Predictive_Controller_IM;

    model Estimator
      Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
        Placement(visible = true, transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Ws annotation(
        Placement(visible = true, transformation(origin = {-112, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerInput x_opt_in "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {-2, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {4, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
      Modelica.Blocks.Interfaces.RealOutput Fs[2](start = {0, 0}) annotation(
        Placement(visible = true, transformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Fr[2] annotation(
        Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {118, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      constant Real V_alpha[8] = 2 / 3 * {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = 2 / 3 * {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      MPC_Motor.Records.MPC_IM_Record data_MPC annotation(
        Placement(visible = true, transformation(origin = {-80, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    equation
      der(Fs[1]) = data_MPC.Vdc * V_alpha[x_opt_in] - data_MPC.Rs * Is[1];
      der(Fs[2]) = data_MPC.Vdc * V_beta[x_opt_in] - data_MPC.Rs * Is[2];
      Fr = data_MPC.Lr / data_MPC.Lm * Fs + Is * (data_MPC.Lm - data_MPC.Lr * data_MPC.Ls / data_MPC.Lm);
      annotation(
        Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {85, 170, 127}, fillColor = {255, 221, 250}, fillPattern = FillPattern.VerticalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Ellipse(origin = {5, 2}, lineColor = {85, 85, 0}, lineThickness = 4.5, extent = {{-59, 58}, {59, -58}}, endAngle = 360), Text(origin = {2, 7}, lineColor = {85, 85, 0}, lineThickness = 6, extent = {{-46, 37}, {46, -37}}, textString = "E"), Text(origin = {5, -134}, lineColor = {255, 85, 0}, extent = {{-15, 18}, {15, -18}}, textString = "Opt"), Text(origin = {143, -24}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Fr"), Text(origin = {141, 44}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Fs"), Text(origin = {-141, 46}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Is"), Text(origin = {-151, -28}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Ws"), Text(origin = {1, 119}, extent = {{-85, 13}, {85, -13}}, textString = "%name")}));
    end Estimator;

    block abcToAlphaBeta
      import Modelica.SIunits;
      import Modelica.Constants;
      input Modelica.Blocks.Interfaces.RealInput Is[3] annotation(
        Placement(visible = true, transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Iab[2] annotation(
        Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      constant Real k = 2 / 3;
      constant Integer m = 3;
      constant Real pi = Constants.pi;
      constant SIunits.Angle phi = 2 * pi / 3;
      parameter Real TransformationMatrix[2, m] = 2 / m * {{cos(+(k - 1) / m * 2 * pi) for k in 1:m}, {+sin(+(k - 1) / m * 2 * pi) for k in 1:m}};
      parameter Real InverseTransformation[m, 2] = {{cos(-(k - 1) / m * 2 * pi), -sin(-(k - 1) / m * 2 * pi)} for k in 1:m};
    equation
      Iab = TransformationMatrix * Is;
      annotation(
        Icon(graphics = {Rectangle(origin = {0, -1}, lineColor = {99, 255, 250}, fillColor = {255, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 3.25, extent = {{-100, 99}, {100, -99}}), Text(origin = {125, -68}, extent = {{-15, 6}, {15, -6}}, textString = "%name"), Line(points = {{-96, 96}, {96, -96}, {96, -96}}, color = {85, 0, 255}, thickness = 1.25), Line(origin = {-71.21, -14.21}, points = {{13.2071, 30.2071}, {13.2071, -3.79289}, {13.2071, -3.79289}, {-12.7929, -29.7929}}, color = {0, 0, 127}, thickness = 4), Line(origin = {-44, -31}, points = {{-14, 13}, {14, -13}}, color = {0, 0, 127}, thickness = 4), Line(origin = {46, 36}, points = {{-22, 26}, {-22, -26}, {22, -26}, {22, -26}, {22, -26}}, color = {0, 0, 127}, thickness = 4)}));
    end abcToAlphaBeta;

    block Predictive_Controller_RealOut
      import MPC_Motor.Functions;
      Modelica.Blocks.Interfaces.RealInput Fs[2] annotation(
        Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Fr[2] annotation(
        Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
        Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Tref annotation(
        Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-39, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Fsref annotation(
        Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Ws annotation(
        Placement(visible = true, transformation(origin = {13, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealOutput Sa annotation(
        Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Sb annotation(
        Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Sc annotation(
        Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      MPC_Motor.Records.MPC_Record data_MPC annotation(
        Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput x_opt_in "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {0, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      Integer indices[8];
      Real sort_Array[8];
      Real cost_Array[8];
      Integer x_opt_out(start = 1);
    algorithm
      when sample(0, data_MPC.Ts) then
        cost_Array := Functions.MPC_Test(Tref, Fsref, Ws, Fr, Fs, Is, x_opt_in);
        (sort_Array, indices) := Modelica.Math.Vectors.sort(cost_Array, ascending = true);
        x_opt_out := indices[1];
      end when;
      x_opt_in := x_opt_out;
      Sa := data_MPC.states[x_opt_in, 1];
      Sb := data_MPC.states[x_opt_in, 2];
      Sc := data_MPC.states[x_opt_in, 3];
      annotation(
        Icon(graphics = {Rectangle(origin = {4, 2}, lineColor = {48, 255, 221}, fillColor = {221, 221, 221}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-156, 58}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fr"), Text(origin = {53.7266, 152.043}, lineColor = {85, 0, 255}, extent = {{15.8633, -17.5658}, {-15.8633, 17.5658}}, textString = "Ws"), Text(origin = {3, 158}, lineColor = {85, 0, 255}, extent = {{25, -56}, {-25, 56}}, textString = "Fsref"), Text(origin = {-40, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Tr"), Text(origin = {-84, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Is"), Text(origin = {-154, -16}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fs"), Text(origin = {152, 68}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sc"), Text(origin = {154, -52}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sa"), Text(origin = {155, 10}, lineColor = {255, 0, 255}, extent = {{17, -16}, {-17, 16}}, textString = "Sb"), Text(origin = {0, -138}, lineColor = {255, 85, 0}, extent = {{12, -16}, {-12, 16}}, textString = "Opt"), Ellipse(origin = {4.69854, -3.63424}, lineColor = {85, 170, 127}, pattern = LinePattern.Dot, lineThickness = 2, extent = {{-82.6985, 77.6342}, {82.6985, -77.6342}}, endAngle = 360), Text(extent = {{-20, 14}, {-20, 14}}, textString = "MPC", fontName = "Mongolian Baiti"), Text(origin = {0, -3}, lineThickness = 2.25, extent = {{-44, 23}, {44, -23}}, textString = "MPC", fontSize = 36, fontName = "Segoe Script")}));
    end Predictive_Controller_RealOut;

    block Predictive_Controller_PMSM
      import MPC_Motor.Functions;
      Modelica.Blocks.Interfaces.RealInput Fs[2] annotation(
        Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Fr[2] annotation(
        Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
        Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Tref annotation(
        Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-39, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Fsref annotation(
        Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.RealInput Ws annotation(
        Placement(visible = true, transformation(origin = {13, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
      Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
        Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
        Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
        Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
      MPC_Motor.Records.MPC_Record data_MPC annotation(
        Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.IntegerOutput x_opt_in "Connector of Real output signal" annotation(
        Placement(visible = true, transformation(origin = {0, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
      constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      Integer indices[8];
      Real sort_Array[8];
      Real cost_Array[8];
      Real Isp_beta;
      Real Isp_alpha;
      discrete Integer x_opt_out(start = 1);
    algorithm
      when sample(0, data_MPC.Ts) then
        (cost_Array, Isp_beta, Isp_alpha) := Functions.MPC_Test(Tref, Fsref, Ws, Fr, Fs, Is, x_opt_in);
        (sort_Array, indices) := Modelica.Math.Vectors.sort(cost_Array, ascending = true);
        x_opt_out := indices[1];
      end when;
      x_opt_in := x_opt_out;
      Sa := data_MPC.states[x_opt_in, 1];
      Sb := data_MPC.states[x_opt_in, 2];
      Sc := data_MPC.states[x_opt_in, 3];
      annotation(
        Icon(graphics = {Rectangle(origin = {4, 2}, lineColor = {48, 255, 221}, fillColor = {221, 221, 221}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-156, 58}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fr"), Text(origin = {53.7266, 152.043}, lineColor = {85, 0, 255}, extent = {{15.8633, -17.5658}, {-15.8633, 17.5658}}, textString = "Ws"), Text(origin = {3, 158}, lineColor = {85, 0, 255}, extent = {{25, -56}, {-25, 56}}, textString = "Fsref"), Text(origin = {-40, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Tr"), Text(origin = {-84, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Is"), Text(origin = {-154, -16}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fs"), Text(origin = {152, 68}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sc"), Text(origin = {154, -52}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sa"), Text(origin = {155, 10}, lineColor = {255, 0, 255}, extent = {{17, -16}, {-17, 16}}, textString = "Sb"), Text(origin = {0, -138}, lineColor = {255, 85, 0}, extent = {{12, -16}, {-12, 16}}, textString = "Opt"), Ellipse(origin = {4.69854, -3.63424}, lineColor = {85, 170, 127}, pattern = LinePattern.Dot, lineThickness = 2, extent = {{-82.6985, 77.6342}, {82.6985, -77.6342}}, endAngle = 360), Text(extent = {{-20, 14}, {-20, 14}}, textString = "MPC", fontName = "Mongolian Baiti"), Text(origin = {0, -3}, lineThickness = 2.25, extent = {{-44, 23}, {44, -23}}, textString = "MPC", fontSize = 36, fontName = "Segoe Script")}));
    end Predictive_Controller_PMSM;

    block abcToDQ
      import Modelica.SIunits;
      import Modelica.Constants;
      input Modelica.Blocks.Interfaces.RealInput Is[3] annotation(
        Placement(visible = true, transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      input Modelica.Blocks.Interfaces.RealInput angle annotation(
        Placement(visible = true, transformation(origin = {-110, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput Idq[2] annotation(
        Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      constant Real k = 2 / 3;
      constant Integer m = 3;
      constant Real pi = Constants.pi;
      constant SIunits.Angle phi = 2 * pi / 3;
      Real RotationMatrix[2, 2] = {{+cos(-angle), -sin(-angle)}, {+sin(-angle), +cos(-angle)}};
      parameter Real TransformationMatrix[2, m] = 2 / m * {{cos(+(k - 1) / m * 2 * pi) for k in 1:m}, {+sin(+(k - 1) / m * 2 * pi) for k in 1:m}};
      parameter Real InverseTransformation[m, 2] = {{cos(-(k - 1) / m * 2 * pi), -sin(-(k - 1) / m * 2 * pi)} for k in 1:m};
    equation
      Idq = RotationMatrix * (TransformationMatrix * Is);
      annotation(
        Icon(graphics = {Rectangle(origin = {0, -1}, lineColor = {99, 255, 250}, fillColor = {255, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 3.25, extent = {{-100, 99}, {100, -99}}), Text(origin = {125, -68}, extent = {{-15, 6}, {15, -6}}, textString = "%name"), Line(points = {{-96, 96}, {96, -96}, {96, -96}}, color = {85, 0, 255}, thickness = 1.25), Line(origin = {-71.21, -14.21}, points = {{13.2071, 30.2071}, {13.2071, -3.79289}, {13.2071, -3.79289}, {-12.7929, -29.7929}}, color = {0, 0, 127}, thickness = 4), Line(origin = {-44, -31}, points = {{-14, 13}, {14, -13}}, color = {0, 0, 127}, thickness = 4), Line(origin = {46, 36}, points = {{-22, 26}, {-22, -26}, {22, -26}, {22, -26}, {22, -26}}, color = {0, 0, 127}, thickness = 4)}));
    end abcToDQ;
    annotation(
      Icon(graphics = {Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Polygon(origin = {40, -35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-10, 0}, {5, 5}, {5, -5}, {-10, 0}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-6.25, -35}}), Polygon(origin = {-40, 35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{10, 0}, {-5, 5}, {-5, -5}, {10, 0}}), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {6.25, 35}}), Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Polygon(origin = {40, -35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-10, 0}, {5, 5}, {5, -5}, {-10, 0}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-6.25, -35}}), Polygon(origin = {-40, 35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{10, 0}, {-5, 5}, {-5, -5}, {10, 0}}), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {6.25, 35}}), Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Polygon(origin = {40, -35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-10, 0}, {5, 5}, {5, -5}, {-10, 0}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-6.25, -35}}), Polygon(origin = {-40, 35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{10, 0}, {-5, 5}, {-5, -5}, {10, 0}}), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {6.25, 35}}), Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}), Polygon(origin = {40, -35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-10, 0}, {5, 5}, {5, -5}, {-10, 0}}), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-6.25, -35}}), Polygon(origin = {-40, 35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{10, 0}, {-5, 5}, {-5, -5}, {10, 0}}), Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {6.25, 35}}), Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}})}));
  end Blocks;

  package Functions
    function MPC_Test_IM
      import Modelica.SIunits;
      import Modelica.Constants;
      // Input arguments
      input Real Tref;
      input Real Fref;
      input Real Ws;
      input Real Fr[2];
      input Real Fs[2];
      input Real Is[2];
      input Integer x_opt_in;
      input MPC_Motor.Records.MPC_IM_Record data_MPC;
      output Real cost_Array[8];
      output Real Isp_beta;
      output Real Isp_alpha;
    protected
      Real Isp_beta1;
      Real Isp_alpha1;
      constant Real Ts = data_MPC.Ts;
      //Supply DC Voltages
      //Machine Parameters
      parameter Real Vdc = data_MPC.Vdc;
      constant Real Rs = data_MPC.Rs;
      constant Real Rr = data_MPC.Rr;
      constant Real Lr = data_MPC.Lr;
      constant Real Ls = data_MPC.Ls;
      constant Real Lm = data_MPC.Lm;
      constant Real P = data_MPC.P;
      //pole pairs
      constant Real Fs_nom = 0.4;
      constant Real T_nom = 25;
      //Electrical Time Constants
      constant Real tr = Lr / Rr;
      //Constants in equation
      constant Real sigma = 1 - Lm ^ 2 / (Ls * Lr);
      constant Real kr = Lm / Lr;
      constant Real r_sigma = Rs + Rr * kr ^ 2;
      constant Real t_sigma = sigma * Ls / r_sigma;
      //Constants in equation
      constant Real A = t_sigma / (t_sigma + Ts);
      constant Real B = Ts * kr / (r_sigma * tr * (t_sigma + Ts));
      constant Real C = Ts / (r_sigma * (t_sigma + Ts));
      constant Real D = Ts * kr / (r_sigma * (Ts + t_sigma));
      Real cost_opt;
      Real Tp;
      Real Fsp_alpha;
      Real Fsp_beta;
      //Real Isp_alpha;
      Real Fsp;
      //Voltage vectors
      constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      Real V_alpha_i;
      Real V_beta_i;
    algorithm
      cost_Array := zeros(8);
      cost_opt := 1e10;
      for i in 1:8 loop
        V_alpha_i := 2 / 3 * Vdc * V_alpha[i];
        V_beta_i := 2 / 3 * Vdc * V_beta[i];
        Fsp_alpha := Fs[1] + Ts * V_alpha_i - Rs * Ts * Is[1];
        Fsp_beta := Fs[2] + Ts * V_beta_i - Rs * Ts * Is[2];
        Isp_alpha := A * Is[1] + B * Fr[1] + C * V_alpha_i + D * Fr[2] * Ws;
        Isp_alpha1 := A * Isp_alpha + B * Fr[1] + C * V_alpha_i + D * Fr[2] * Ws;
        Isp_beta := A * Is[2] + B * Fr[2] + C * V_beta_i - D * Fr[1] * Ws;
        Isp_beta1 := A * Isp_beta + B * Fr[2] + C * V_beta_i - D * Fr[1] * Ws;
        Tp := 1.5 * P * (Fsp_alpha * Isp_beta - Fsp_beta * Isp_alpha);
        Fsp := sqrt(Fsp_alpha ^ 2 + Fsp_beta ^ 2);
        cost_Array[i] := 1.25 * (abs(Tref - Tp) / data_MPC.T_nom) + 5 * (abs(Fref - Fsp) / data_MPC.Fs_nom);
      end for;
//Tp := 1.5 * P * (Fsp_alpha * Isp_beta1 - Fsp_beta * Isp_alpha1);
      annotation(
        Icon(graphics = {Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name"), Ellipse(lineColor = {108, 88, 49}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name")}));
    end MPC_Test_IM;

    function MPC_Test_PMSM
      import Modelica.SIunits;
      import Modelica.Constants;
      // Input arguments
      input Real Tref;
      input Real Fref;
      input Real Ws;
      input Real Fr[2];
      input Real Fs[2];
      input Real Is[2];
      input Integer x_opt_in;
      output Real cost_Array[8];
      output Real Isp_beta;
      output Real Isp_alpha;
    protected
      constant Real Ts = 0.0001;
      //Supply DC Voltage
      //Machine Parameters
      parameter Real Vdc = 250;
      constant Real Rs = 0.277;
      constant Real Rr = 0.183;
      constant Real Lr = 0.056;
      constant Real Ls = 0.0553;
      constant Real Lm = 0.0538;
      constant Real P = 2;
      //pole pairs
      constant Real Fs_nom = 0.4;
      constant Real T_nom = 25;
      //Electrical Time Constants
      constant Real tr = Lr / Rr;
      //Constants in equation
      constant Real sigma = 1 - Lm ^ 2 / (Ls * Lr);
      constant Real kr = Lm / Lr;
      constant Real r_sigma = Rs + Rr * kr ^ 2;
      constant Real t_sigma = sigma * Ls / r_sigma;
      //Constants in equation
      constant Real A = t_sigma / (t_sigma + Ts);
      constant Real B = Ts * kr / (r_sigma * tr * (t_sigma + Ts));
      constant Real C = Ts / (r_sigma * (t_sigma + Ts));
      constant Real D = Ts * kr / (r_sigma * (Ts + t_sigma));
      Real cost_opt;
      Real Tp;
      Real Fsp_alpha;
      Real Fsp_beta;
      //Real Isp_alpha;
      Real Fsp;
      //Voltage vectors
      constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
      constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
      Real V_alpha_i;
      Real V_beta_i;
    algorithm
      cost_Array := zeros(8);
      cost_opt := 1e10;
      for i in 1:8 loop
        V_alpha_i := 2 / 3 * Vdc * V_alpha[i];
        V_beta_i := 2 / 3 * Vdc * V_beta[i];
        Fsp_alpha := Fs[1] + Ts * V_alpha_i - Rs * Ts * Is[1];
        Fsp_beta := Fs[2] + Ts * V_beta_i - Rs * Ts * Is[2];
        Isp_alpha := A * Is[1] + B * Fr[1] + C * V_alpha_i + D * Fr[2] * Ws;
        Isp_beta := A * Is[2] + B * Fr[2] + C * V_beta_i - D * Fr[1] * Ws;
        Tp := 1.5 * P * (Fsp_alpha * Isp_beta - Fsp_beta * Isp_alpha);
        Fsp := sqrt(Fsp_alpha ^ 2 + Fsp_beta ^ 2);
        cost_Array[i] := 1.25 * (abs(Tref - Tp) / T_nom) + 5 * (abs(Fref - Fsp) / Fs_nom);
      end for;
//cost_Array[i] := 10*abs(T_ref - Tp) / T_nom;
//cost_Array[i]:=(abs(T_ref -Tp) / (T_nom))+34*(abs(Fs_ref -Fsp) / (Fs_ref));
      annotation(
        Icon(graphics = {Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name"), Ellipse(lineColor = {108, 88, 49}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name")}));
    end MPC_Test_PMSM;
    annotation(
      Icon(graphics = {Text(lineColor = {128, 128, 128}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Text(lineColor = {128, 128, 128}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Rectangle(lineColor = {200, 200, 200}, fillColor = {248, 248, 248}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25), Text(lineColor = {128, 128, 128}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25)}));
  end Functions;

  package Records
    record Induction_Motor_record
      //Machine Parameters
      parameter Modelica.SIunits.Resistance Rs = 0.277;
      parameter Modelica.SIunits.Resistance Rr = 0.183;
      parameter Modelica.SIunits.Inductance Lr = 0.056;
      parameter Modelica.SIunits.Inductance Ls = 0.0553;
      parameter Modelica.SIunits.Inductance Lm = 0.0538;
      parameter Real P = 2;
      parameter Modelica.SIunits.MomentOfInertia J = 0.0165;
      parameter Modelica.SIunits.DampingCoefficient B = 0;
      //pole pairs
      parameter Modelica.SIunits.ElectricFlux Fs_nom = 0.4;
      parameter Modelica.SIunits.Torque T_nom = 25;
      //Electrical Time Constants
      parameter Real tr = Lr / Rr;
      //Constants in equation
      parameter Real sigma = 1 - Lm ^ 2 / (Ls * Lr);
      parameter Real kr = Lm / Lr;
      parameter Real r_sigma = Rs + Rr * kr ^ 2;
      parameter Real t_sigma = sigma * Ls / r_sigma;
      parameter Integer m = 3;
      annotation(
        Icon(graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {0, -25}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Line(origin = {0, -50}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64})}));
    end Induction_Motor_record;

    record MPC_IM_Record
      parameter Real Ts = 1e-5;
      //Supply DC Voltage
      //Machine Parameters
       parameter Real Vdc = 250;
       parameter Real Rs = 0.277;
       parameter Real Rr = 0.183;
       parameter Real Lr = 0.056;
       parameter Real Ls = 0.0553;
       parameter Real Lm = 0.0538;
       parameter Real P = 2;
       parameter Real J = 0.0165;
       parameter Real B = 0;
      //pole pairs
      parameter Real Fs_nom = 1.25;
      parameter Real T_nom = 25;
      //Electrical Time Constants
      parameter Real tr = Lr / Rr;
      //Constants in equation
      parameter Real sigma = 1 - Lm ^ 2 / (Ls * Lr);
      parameter Real kr = Lm / Lr;
      parameter Real r_sigma = Rs + Rr * kr ^ 2;
      parameter Real t_sigma = sigma * Ls / r_sigma;
      //Switching States
      constant Boolean states[8, 3] = {{false, false, false}, {true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}, {true, true, true}};
      //    constant Real states[8, 3] = {{0,0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}, {1, 1, 1}};
      annotation(
        Icon(graphics = {Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {-0.694215, -0.694215}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -50.6942}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -25.6942}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25)}));
    end MPC_IM_Record;

    record PMSM_record
      //Machine Parameters
      constant Real Rs = 0.485;
      constant Real Ls = 0.000395;
      constant Real P = 2;
      constant Real J = 0.0027;
      constant Real B = 0.0004924;
      constant Real Lambda_m = 0.1194;
      annotation(
        Icon(graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {0, -25}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Line(origin = {0, -50}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64})}));
    end PMSM_record;

    record MPC_PMSM_Record
    
      parameter Real Ts = 0.0001;
      //Supply DC Voltage
      //Machine Parameters
      parameter Real Vdc = 250;
      parameter Real Rs = 0.277;
      parameter Real Rr = 0.183;
      parameter Real Lr = 0.056;
      parameter Real Ls = 0.0553;
      parameter Real Lm = 0.0538;
      parameter Real P = 2;
      parameter Real J = 0.0165;
      parameter Real B = 0;
      //pole pairs
      parameter Real Fs_nom = 1.25;
      parameter Real T_nom = 25;
      //Electrical Time Constants
      parameter Real tr = Lr / Rr;
      //Constants in equation
      parameter Real sigma = 1 - Lm ^ 2 / (Ls * Lr);
      parameter Real kr = Lm / Lr;
      parameter Real r_sigma = Rs + Rr * kr ^ 2;
      parameter Real t_sigma = sigma * Ls / r_sigma;
      //Switching States
      constant Boolean states[8, 3] = {{false, false, false}, {true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}, {true, true, true}};
      //    constant Real states[8, 3] = {{0,0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}, {1, 1, 1}};
      annotation(
        Icon(graphics = {Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {-0.694215, -0.694215}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -50.6942}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -25.6942}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25)}));
    end MPC_PMSM_Record;
    annotation(
      Icon(graphics = {Line(origin = {0, -26}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Rectangle(origin = {0, -1}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25), Line(origin = {0, -1}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Line(points = {{-100, 24}, {100, 24}}, color = {64, 64, 64})}));
  end Records;
  annotation(
    Icon(graphics = {Bitmap(origin = {2, -2}, rotation = 180, extent = {{102, 106}, {-102, -106}}, imageSource = "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")}),
    uses(Modelica(version = "3.2.3")));
end MPC_Motor;
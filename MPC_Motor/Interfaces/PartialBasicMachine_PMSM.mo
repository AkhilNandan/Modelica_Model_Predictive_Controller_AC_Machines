within MPC_Motor.Interfaces;
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
 

within MPC_Motor.Records; 
record PMSM_record
  //Machine Parameters
  parameter Modelica.SIunits.Resistance Rs = 0.485;
  parameter Modelica.SIunits.Inductance Ls = 0.000395;
  parameter Real P = 1;
  parameter Modelica.SIunits.MomentOfInertia J = 0.0027;
  parameter Modelica.SIunits.DampingCoefficient B = 0.0004924;
  parameter Modelica.SIunits.ElectricFlux Lambda_m = 0.1194;
  parameter Integer m = 3;

  annotation(
    Icon(graphics = {Line(points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {0, -25}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Line(origin = {0, -50}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64})}));
end PMSM_record;
 

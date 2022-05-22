within MPC_Motor.Records;
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
 

within MPC_Motor.Components; 
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
  MPC_Motor.Records.Induction_Motor_record data_Motor annotation(
    Placement(visible = true, transformation(origin = {-182, -30}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

equation
// All dynamic equations are modelled in stator reference frame
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

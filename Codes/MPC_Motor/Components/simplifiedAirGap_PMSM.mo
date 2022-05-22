within MPC_Motor.Components;  
model simplifiedAirGap_PMSM
  Modelica.Electrical.Machines.Interfaces.SpacePhasor spacePhasor annotation(
    Placement(transformation(extent = {{-110, -10}, {-90, 10}}), iconTransformation(extent = {{-110, -10}, {-90, 10}})));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a flange annotation(
    Placement(visible = true, transformation(extent = {{-8, 92}, {12, 112}}, rotation = 0), iconTransformation(extent = {{100, -10}, {120, 10}}, rotation = 0)));
  Modelica.Mechanics.Rotational.Interfaces.Flange_a support annotation(
    Placement(visible = true, transformation(extent = {{-6, -104}, {14, -84}}, rotation = 0), iconTransformation(extent = {{-4, -56}, {16, -36}}, rotation = 0)));
  import Modelica.Math;
  import Modelica.Constants;
  Modelica.SIunits.Voltage Vdq[2];
  Modelica.SIunits.Current Idq[2];
  Modelica.SIunits.AngularFrequency Ws;
  Modelica.SIunits.Angle angle;
  Real RotationMatrix[2, 2] = {{+cos(-data_Motor.P*angle), -sin(-data_Motor.P*angle)}, {+sin(-data_Motor.P*angle), +cos(-data_Motor.P*angle)}};
  MPC_Motor.Records.PMSM_record data_Motor annotation(
    Placement(visible = true, transformation(origin = {-201, -7}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
equation
// All dynamic equations are modelled in stator reference frame
  angle = flange.phi - support.phi;
  Vdq = RotationMatrix * spacePhasor.v_;
  Idq = RotationMatrix * spacePhasor.i_;
  Vdq[1] = data_Motor.Rs * Idq[1] + data_Motor.Ls * der(Idq[1]) - data_Motor.Ls * Ws * Idq[2];
  Vdq[2] = data_Motor.Rs * Idq[2] + data_Motor.Ls * der(Idq[2]) + data_Motor.Ls * Ws * Idq[1] + data_Motor.Lambda_m * Ws;
  der(angle) * data_Motor.P = Ws;
  flange.tau = -1.5 * data_Motor.P*data_Motor.Lambda_m * Idq[2];
  support.tau = -flange.tau;
  annotation(
    Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-70, 30}, {70, -30}}), Line(points = {{-90, 0}, {-70, 0}}), Line(points = {{-70, 10}, {70, 10}}, color = {0, 0, 255}), Line(points = {{-70, -30}, {70, -30}}, color = {0, 0, 255}), Line(points = {{-70, -10}, {70, -10}}, color = {0, 0, 255}), Line(points = {{70, 0}, {80, 0}}, color = {0, 0, 255}), Line(points = {{80, 20}, {80, -20}}, color = {0, 0, 255}), Line(points = {{90, 14}, {90, -14}}, color = {0, 0, 255}), Line(points = {{100, 8}, {100, -8}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name")}),
    Documentation(info = "<html> </html>"));
end simplifiedAirGap_PMSM;

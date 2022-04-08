within MPC_Motor.Machines; 
model SimplifiedPMSM
  extends Modelica.Icons.MotorIcon;
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

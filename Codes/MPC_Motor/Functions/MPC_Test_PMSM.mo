within MPC_Motor.Functions; 
function MPC_Test_PMSM
  import Modelica.SIunits;
  import Modelica.Constants;
  // Input arguments
  input Real id_ref;
  input Real iq_ref;
  input Real wm;
  input Real Idq[2];
  input Real phi;
  input MPC_Motor.Records.MPC_PMSM_Record data_MPC;
  output Integer x_opt_in;
protected
  constant Real R = data_MPC.R;
  constant Real Ls = data_MPC.Ls;
  constant Real Lambda_f = data_MPC.Lambda_f;
  constant Real Ts = data_MPC.Ts;
  constant Real imax = data_MPC.imax;
  constant Real Vdc = data_MPC.Vdc;
  constant Real S[8, 3] = {{0, 0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}, {0, 1, 1}, {0, 0, 1}, {1, 0, 1}, {1, 1, 1}};
  constant Real pi = Modelica.Constants.pi;
  Real ud;
  Real uq;
  Real idp;
  Real iqp;
  Real f = 0;
  Real current_cost = 1e14;
  Real cost = 0;
algorithm
  for i in 1:8 loop
    ud := Vdc * (2 / 3) * (S[i, 1] * cos(phi) + S[i, 2] * cos(phi - 2 * pi / 3) + S[i, 3] * cos(phi + 2 * pi / 3));
    uq := Vdc * (2 / 3) * ((-S[i, 1] * sin(phi)) - S[i, 2] * sin(phi - 2 * pi / 3) - S[i, 3] * sin(phi + 2 * pi / 3));
    idp := (1 - R * Ts / Ls) * Idq[1] + Ts * ud / Ls + wm * Ts * Idq[2];
    iqp := (1 - R * Ts / Ls) * Idq[2] + Ts * uq / Ls - wm * Ts * Idq[1] - wm * Ts * Lambda_f / Ls;
    cost := (id_ref - idp) ^ 2 + (iq_ref - iqp) ^ 2 + f;
    if cost < current_cost then
      x_opt_in := i;
      current_cost := cost;
    end if;
  end for;
  annotation(
    Icon(graphics = {Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name"), Ellipse(lineColor = {108, 88, 49}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name")}));
end MPC_Test_PMSM;
 

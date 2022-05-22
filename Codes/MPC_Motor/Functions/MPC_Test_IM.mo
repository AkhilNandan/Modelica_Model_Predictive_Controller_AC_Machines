within MPC_Motor.Functions; 
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
  //Machine Parameters
  parameter Real Vdc = data_MPC.Vdc;
  constant Real Rs = data_MPC.Rs;
  constant Real Rr = data_MPC.Rr;
  constant Real Lr = data_MPC.Lr;
  constant Real Ls = data_MPC.Ls;
  constant Real Lm = data_MPC.Lm;
  constant Real P = data_MPC.P;
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
  annotation(
    Icon(graphics = {Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name"), Ellipse(lineColor = {108, 88, 49}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}, endAngle = 360), Text(lineColor = {108, 88, 49}, extent = {{-90, -90}, {90, 90}}, textString = "f"), Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name")}));
end MPC_Test_IM;

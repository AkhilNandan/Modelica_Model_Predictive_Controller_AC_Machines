within MPC_Motor.Records; 
record MPC_IM_Record
  parameter Real Ts = 1e-5;
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
  parameter Real Fs_nom =0.4 ;
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
  annotation(
    Icon(graphics = {Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {-0.694215, -0.694215}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -50.6942}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -25.6942}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25)}));
end MPC_IM_Record;

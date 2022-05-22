within MPC_Motor.Records; 
record MPC_PMSM_Record

  parameter Real Ts = 1e-5;
  parameter Real R = 0.485;
  parameter Real Ls = 0.000395;
  parameter Real Lambda_f = 0.1194;
  parameter Real imax = 80;
  parameter Real Vdc = 560;
  parameter Integer m = 3;

  constant Boolean states[8, 3] = {{false, false, false}, {true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}, {true, true, true}};
  annotation(
    Icon(graphics = {Text(origin = {12, 4}, lineColor = {0, 0, 255}, extent = {{-150, 60}, {150, 100}}, textString = "%name"), Line(origin = {-0.694215, -0.694215}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -50.6942}, points = {{-100, 0}, {100, 0}}, color = {64, 64, 64}), Line(origin = {-0.694215, -25.6942}, points = {{0, 75}, {0, -75}}, color = {64, 64, 64}), Text(lineColor = {28, 108, 200}, extent = {{-100, -14}, {100, -36}}, textString = ""), Rectangle(origin = {0, -25}, lineColor = {64, 64, 64}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -75}, {100, 75}}, radius = 25)}));
end MPC_PMSM_Record;

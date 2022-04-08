within MPC_Motor.Blocks; 
model Estimator
  Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
    Placement(visible = true, transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Ws annotation(
    Placement(visible = true, transformation(origin = {-112, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-112, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerInput x_opt_in "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {-2, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {4, -108}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput Fs[2](start = {0, 0}) annotation(
    Placement(visible = true, transformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Fr[2] annotation(
    Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {118, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  constant Real V_alpha[8] = 2 / 3 * {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
  constant Real V_beta[8] = 2 / 3 * {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
  MPC_Motor.Records.MPC_IM_Record data_MPC annotation(
    Placement(visible = true, transformation(origin = {-80, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  der(Fs[1]) = data_MPC.Vdc * V_alpha[x_opt_in] - data_MPC.Rs * Is[1];
  der(Fs[2]) = data_MPC.Vdc * V_beta[x_opt_in] - data_MPC.Rs * Is[2];
  Fr = data_MPC.Lr / data_MPC.Lm * Fs + Is * (data_MPC.Lm - data_MPC.Lr * data_MPC.Ls / data_MPC.Lm);
  annotation(
    Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {85, 170, 127}, fillColor = {255, 221, 250}, fillPattern = FillPattern.VerticalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Ellipse(origin = {5, 2}, lineColor = {85, 85, 0}, lineThickness = 4.5, extent = {{-59, 58}, {59, -58}}, endAngle = 360), Text(origin = {2, 7}, lineColor = {85, 85, 0}, lineThickness = 6, extent = {{-46, 37}, {46, -37}}, textString = "E"), Text(origin = {5, -134}, lineColor = {255, 85, 0}, extent = {{-15, 18}, {15, -18}}, textString = "Opt"), Text(origin = {143, -24}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Fr"), Text(origin = {141, 44}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Fs"), Text(origin = {-141, 46}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Is"), Text(origin = {-151, -28}, lineColor = {85, 0, 255}, extent = {{-15, 18}, {15, -18}}, textString = "Ws"), Text(origin = {1, 119}, extent = {{-85, 13}, {85, -13}}, textString = "%name")}));
end Estimator;

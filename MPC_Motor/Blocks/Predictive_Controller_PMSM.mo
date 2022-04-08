within MPC_Motor.Blocks;
block Predictive_Controller_PMSM
  import MPC_Motor.Functions;
  Modelica.Blocks.Interfaces.RealInput Fs[2] annotation(
    Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Fr[2] annotation(
    Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Is[2] annotation(
    Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Tref annotation(
    Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-39, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Fsref annotation(
    Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Ws annotation(
    Placement(visible = true, transformation(origin = {13, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
    Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
    Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
    Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  MPC_Motor.Records.MPC_Record data_MPC annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput x_opt_in "Connector of Real output signal" annotation(
    Placement(visible = true, transformation(origin = {0, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  constant Real V_alpha[8] = {0, 1, 0.5, -0.5, -1, -0.5, 0.5, 0};
  constant Real V_beta[8] = {0, 0, 0.866, 0.866, 0, -0.866, -0.866, 0};
  Integer indices[8];
  Real sort_Array[8];
  Real cost_Array[8];
  Real Isp_beta;
  Real Isp_alpha;
  discrete Integer x_opt_out(start = 1);
algorithm
  when sample(0, data_MPC.Ts) then
    (cost_Array, Isp_beta, Isp_alpha) := Functions.MPC_Test(Tref, Fsref, Ws, Fr, Fs, Is, x_opt_in);
    (sort_Array, indices) := Modelica.Math.Vectors.sort(cost_Array, ascending = true);
    x_opt_out := indices[1];
  end when;
  x_opt_in := x_opt_out;
  Sa := data_MPC.states[x_opt_in, 1];
  Sb := data_MPC.states[x_opt_in, 2];
  Sc := data_MPC.states[x_opt_in, 3];
  annotation(
    Icon(graphics = {Rectangle(origin = {4, 2}, lineColor = {48, 255, 221}, fillColor = {221, 221, 221}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-156, 58}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fr"), Text(origin = {53.7266, 152.043}, lineColor = {85, 0, 255}, extent = {{15.8633, -17.5658}, {-15.8633, 17.5658}}, textString = "Ws"), Text(origin = {3, 158}, lineColor = {85, 0, 255}, extent = {{25, -56}, {-25, 56}}, textString = "Fsref"), Text(origin = {-40, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Tr"), Text(origin = {-84, 148}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Is"), Text(origin = {-154, -16}, lineColor = {85, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Fs"), Text(origin = {152, 68}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sc"), Text(origin = {154, -52}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sa"), Text(origin = {155, 10}, lineColor = {255, 0, 255}, extent = {{17, -16}, {-17, 16}}, textString = "Sb"), Text(origin = {0, -138}, lineColor = {255, 85, 0}, extent = {{12, -16}, {-12, 16}}, textString = "Opt"), Ellipse(origin = {4.69854, -3.63424}, lineColor = {85, 170, 127}, pattern = LinePattern.Dot, lineThickness = 2, extent = {{-82.6985, 77.6342}, {82.6985, -77.6342}}, endAngle = 360), Text(extent = {{-20, 14}, {-20, 14}}, textString = "MPC", fontName = "Mongolian Baiti"), Text(origin = {0, -3}, lineThickness = 2.25, extent = {{-44, 23}, {44, -23}}, textString = "MPC", fontSize = 36, fontName = "Segoe Script")}));
end Predictive_Controller_PMSM;
 

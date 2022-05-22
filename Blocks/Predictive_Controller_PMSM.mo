within MPC_Motor.Blocks;
block Predictive_Controller_PMSM
  import MPC_Motor.Functions;
  Modelica.Blocks.Interfaces.RealInput id_ref annotation(
    Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iq_ref annotation(
    Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput wm annotation(
    Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-63, 121}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Idq[2] annotation(
    Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-11, 123}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput phi annotation(
    Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {49, 119}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));

  Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
    Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
    Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
    Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput x_opt_out "Connector of Real output signal"   annotation(
    Placement(visible = true, transformation(origin = {0, -112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  constant Boolean S[8, 3] = {{false, false, false}, {true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}, {true, true, true}};
  // Initialisation
   Real Ts = data_MPC.Ts;
   Integer x_opt_in (start = 1);
  MPC_Motor.Records.MPC_PMSM_Record data_MPC annotation(
    Placement(visible = true, transformation(origin = {-264, -40}, extent = {{-54, -54}, {54, 54}}, rotation = 0)));
algorithm
 when sample(0, Ts) then
    x_opt_in := Functions.MPC_Test_PMSM(id_ref, iq_ref, wm, Idq, phi,data_MPC);
  end when;
  x_opt_out:=x_opt_in;
  Sa := S[x_opt_in, 1];
  Sb := S[x_opt_in, 2];
  Sc := S[x_opt_in, 3];
  annotation(
    Icon(graphics = {Rectangle(origin = {4, 2}, lineColor = {48, 255, 221}, fillColor = {221, 221, 221}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {152, 68}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sc"), Text(origin = {154, -52}, lineColor = {255, 0, 255}, extent = {{12, -16}, {-12, 16}}, textString = "Sa"), Text(origin = {155, 10}, lineColor = {255, 0, 255}, extent = {{17, -16}, {-17, 16}}, textString = "Sb"), Text(origin = {0, -138}, lineColor = {255, 85, 0}, extent = {{12, -16}, {-12, 16}}, textString = "Opt"), Ellipse(origin = {4.69854, -3.63424}, lineColor = {85, 170, 127}, pattern = LinePattern.Dot, lineThickness = 2, extent = {{-82.6985, 77.6342}, {82.6985, -77.6342}}), Text(extent = {{-20, 14}, {-20, 14}}, textString = "MPC", fontName = "Mongolian Baiti"), Text(origin = {0, -3}, lineThickness = 2.25, extent = {{-44, 23}, {44, -23}}, textString = "MPC", fontSize = 36, fontName = "Segoe Script")}));
end Predictive_Controller_PMSM;

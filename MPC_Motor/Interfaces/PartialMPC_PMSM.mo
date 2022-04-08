within MPC_Motor.Interfaces;
partial model PartialMPC_PMSM
  Modelica.Blocks.Interfaces.RealInput id_ref annotation(
    Placement(visible = true, transformation(origin = {-119, -39}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, -21}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iq_ref annotation(
    Placement(visible = true, transformation(origin = {-119, 27}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {-117, 57}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Wm annotation(
    Placement(visible = true, transformation(origin = {-77, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-77, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput Idq[2] annotation(
    Placement(visible = true, transformation(origin = {-33, 133}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {-41, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput phi annotation(
    Placement(visible = true, transformation(origin = {65, 135}, extent = {{-35, -31}, {35, 31}}, rotation = -90), iconTransformation(origin = {1, 117}, extent = {{-15, -15}, {15, 15}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput Sa annotation(
    Placement(visible = true, transformation(origin = {99, -55}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, -55}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput Sb annotation(
    Placement(visible = true, transformation(origin = {101, 41}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 5}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput Sc annotation(
    Placement(visible = true, transformation(origin = {101, -7}, extent = {{-35, -31}, {35, 31}}, rotation = 0), iconTransformation(origin = {119, 65}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
equation

  annotation(
    Icon(graphics = {Rectangle(origin = {2, 0}, lineColor = {26, 206, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 2, extent = {{-100, 100}, {100, -100}}), Text(origin = {-153, 59}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fr"), Text(origin = {-147, -17}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fs"), Text(origin = {-75, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Is"), Text(origin = {-37, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Tref"), Text(origin = {3, 145}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Fsref"), Text(origin = {45, 143}, lineColor = {85, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Ws"), Text(origin = {7, -143}, lineColor = {255, 85, 0}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Opt"), Text(origin = {155, 67}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sc"), Text(origin = {155, -53}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sa"), Text(origin = {155, 7}, lineColor = {255, 0, 255}, lineThickness = 0.5, extent = {{-13, 11}, {13, -11}}, textString = "Sb")}));
end PartialMPC_PMSM;
 

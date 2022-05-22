within MPC_Motor.Blocks; 
block abcToAlphaBeta
  import Modelica.SIunits;
  import Modelica.Constants;
  input Modelica.Blocks.Interfaces.RealInput Is[3] annotation(
    Placement(visible = true, transformation(origin = {-110, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-114, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput Iab[2] annotation(
    Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {116, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  constant Real k = 2 / 3;
  constant Integer m = 3;
  constant Real pi = Constants.pi;
  constant SIunits.Angle phi = 2 * pi / 3;
  parameter Real TransformationMatrix[2, m] = 2 / m * {{cos(+(k - 1) / m * 2 * pi) for k in 1:m}, {+sin(+(k - 1) / m * 2 * pi) for k in 1:m}};
  parameter Real InverseTransformation[m, 2] = {{cos(-(k - 1) / m * 2 * pi), -sin(-(k - 1) / m * 2 * pi)} for k in 1:m};
equation
  Iab = TransformationMatrix * Is;
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -1}, lineColor = {99, 255, 250}, fillColor = {255, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, lineThickness = 3.25, extent = {{-100, 99}, {100, -99}}), Text(origin = {125, -68}, extent = {{-15, 6}, {15, -6}}, textString = "%name"), Line(points = {{-96, 96}, {96, -96}, {96, -96}}, color = {85, 0, 255}, thickness = 1.25), Line(origin = {-71.21, -14.21}, points = {{13.2071, 30.2071}, {13.2071, -3.79289}, {13.2071, -3.79289}, {-12.7929, -29.7929}}, color = {0, 0, 127}, thickness = 4), Line(origin = {-44, -31}, points = {{-14, 13}, {14, -13}}, color = {0, 0, 127}, thickness = 4), Line(origin = {46, 36}, points = {{-22, 26}, {-22, -26}, {22, -26}, {22, -26}, {22, -26}}, color = {0, 0, 127}, thickness = 4)}));
end abcToAlphaBeta;

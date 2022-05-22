within MPC_Motor.Components;
model SignalGenerator
  Modelica.Blocks.Interfaces.BooleanOutput Sa annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, 50}, {120, 30}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sb annotation(
    Placement(visible = true, transformation(origin = {110, -4}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, 8}, {120, -12}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Sc annotation(
    Placement(visible = true, transformation(origin = {112, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(extent = {{100, -40}, {120, -60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.IntegerOutput i(start = 1, fixed = true) annotation(
    Placement(visible = true, transformation(origin = {6, -112}, extent = {{-10, 10}, {10, -10}}, rotation = -90), iconTransformation(origin = {4, -110}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  parameter Real Ts = 0.02;
  parameter Boolean X[6, 3] = {{true, false, false}, {true, true, false}, {false, true, false}, {false, true, true}, {false, false, true}, {true, false, true}};
algorithm
  when sample(0, Ts / 6) then
    Sa := X[i, 1];
    Sb := X[i, 2];
    Sc := X[i, 3];
    i := if i == 6 then 1 else pre(i) + 1;
  end when;
  annotation(
    Icon(graphics = {Rectangle(origin = {-2, -1}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-100, 101}, {100, -101}}), Ellipse(origin = {-5, -1}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-67, 69}, {67, -69}}, endAngle = 360), Text(origin = {-8, 3}, extent = {{-28, 29}, {28, -29}}, textString = "S")}));
end SignalGenerator;
 

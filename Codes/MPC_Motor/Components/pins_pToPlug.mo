within MPC_Motor.Components; 
model pins_pToPlug
  Modelica.Electrical.Analog.Interfaces.PositivePin R "R-phase pole" annotation(
    Placement(visible = true, transformation(extent = {{-42, 6}, {-22, 26}}, rotation = 0), iconTransformation(extent = {{-76, 20}, {-56, 40}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin Y "Y-phase pole" annotation(
    Placement(visible = true, transformation(extent = {{-42, -14}, {-22, 6}}, rotation = 0), iconTransformation(extent = {{-76, -14}, {-56, 6}}, rotation = 0)));
  Modelica.Electrical.Analog.Interfaces.PositivePin B "B-phase pole" annotation(
    Placement(visible = true, transformation(extent = {{-42, -36}, {-22, -16}}, rotation = 0), iconTransformation(extent = {{-76, -48}, {-56, -28}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug Plug_p annotation(
    Placement(visible = true, transformation(extent = {{8, -12}, {28, 8}}, rotation = 0), iconTransformation(extent = {{26, -12}, {46, 8}}, rotation = 0)));
equation
  connect(R, Plug_p.pin[1]);
  connect(Y, Plug_p.pin[2]);
  connect(B, Plug_p.pin[3]);
  annotation(
    Icon(graphics = {Rectangle(origin = {28.6667, -9}, rotation = 180, lineColor = {0, 0, 255}, fillColor = {170, 213, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-55.3333, 67}, {110.667, -67}}), Text(origin = {-16, 20}, lineColor = {0, 0, 255}, extent = {{-150, 40}, {150, 80}}, textString = "%name"), Ellipse(origin = {16, -2}, rotation = 180, fillColor = {170, 213, 255}, fillPattern = FillPattern.Solid, extent = {{-40, 20}, {0, -20}}, endAngle = 360), Rectangle(origin = {1.01, -9}, lineColor = {85, 0, 255}, lineThickness = 3, extent = {{-83.15, 67.06}, {83.15, -67.06}})}));
end pins_pToPlug;

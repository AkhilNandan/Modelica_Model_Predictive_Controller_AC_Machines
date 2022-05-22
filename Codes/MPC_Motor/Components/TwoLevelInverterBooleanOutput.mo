within MPC_Motor.Components;
model TwoLevelInverterBooleanOutput
  extends MPC_Motor.Interfaces.PartialInverterBoolean;
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch switch annotation(
    Placement(visible = true, transformation(origin = {-50, 56}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch annotation(
    Placement(visible = true, transformation(origin = {-24, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch1 annotation(
    Placement(visible = true, transformation(origin = {10, 56}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch2 annotation(
    Placement(visible = true, transformation(origin = {-22, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch3 annotation(
    Placement(visible = true, transformation(origin = {-48, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Ideal.IdealClosingSwitch idealClosingSwitch4 annotation(
    Placement(visible = true, transformation(origin = {12, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-37, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not2 annotation(
    Placement(visible = true, transformation(origin = {7, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not3 annotation(
    Placement(visible = true, transformation(origin = {49, 89}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  MPC_Motor.Components.pins_pToPlug Connector annotation(
    Placement(visible = true, transformation(origin = {78, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Electrical.Analog.Sensors.PowerSensor powerSensor annotation(
    Placement(visible = true, transformation(origin = {-74, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean(f = 1) annotation(
    Placement(visible = true, transformation(origin = {-106, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
// DC_In.i + DC_Out.i = 0;
// DC_In.i = Ma * Plug_p.pin[1].i + Mb * Plug_p.pin[2].i + Mc * Plug_p.pin[3].i;
//  Plug_p.pin[1].v = Ma * (DC_In.v - DC_Out.v);
//  Plug_p.pin[2].v = Mb * (DC_In.v - DC_Out.v);
//  Plug_p.pin[3].v = Mc * (DC_In.v - DC_Out.v);
  connect(switch.p, idealClosingSwitch.p) annotation(
    Line(points = {{-50, 66}, {-24, 66}, {-24, 64}, {-24, 64}, {-24, 64}}, color = {0, 0, 255}));
  connect(idealClosingSwitch.p, idealClosingSwitch1.p) annotation(
    Line(points = {{-24, 64}, {10, 64}, {10, 66}, {10, 66}}, color = {0, 0, 255}));
  connect(switch.n, idealClosingSwitch3.p) annotation(
    Line(points = {{-50, 46}, {-48, 46}, {-48, 10}, {-48, 10}, {-48, 10}}, color = {0, 0, 255}));
  connect(idealClosingSwitch.n, idealClosingSwitch2.p) annotation(
    Line(points = {{-24, 44}, {-22, 44}, {-22, 8}, {-22, 8}}, color = {0, 0, 255}));
  connect(idealClosingSwitch1.n, idealClosingSwitch4.p) annotation(
    Line(points = {{10, 46}, {12, 46}, {12, 10}, {12, 10}}, color = {0, 0, 255}));
  connect(idealClosingSwitch3.n, idealClosingSwitch4.n) annotation(
    Line(points = {{-48, -10}, {-48, -10}, {-48, -24}, {12, -24}, {12, -10}, {12, -10}}, color = {0, 0, 255}));
  connect(idealClosingSwitch2.n, idealClosingSwitch3.n) annotation(
    Line(points = {{-22, -12}, {-22, -12}, {-22, -24}, {-48, -24}, {-48, -10}, {-48, -10}}, color = {0, 0, 255}));
  connect(Sa, not1.u) annotation(
    Line(points = {{-50, 112}, {-50, 112}, {-50, 84}, {-42, 84}, {-42, 86}}, color = {255, 0, 255}));
  connect(Sb, not2.u) annotation(
    Line(points = {{-6, 112}, {-6, 112}, {-6, 86}, {2, 86}, {2, 86}}, color = {255, 0, 255}));
  connect(Sc, not3.u) annotation(
    Line(points = {{35, 111}, {35, 111}, {35, 83}, {43, 83}, {43, 85}}, color = {255, 0, 255}));
  connect(switch.control, Sa) annotation(
    Line(points = {{-38, 56}, {-38, 56}, {-38, 74}, {-50, 74}, {-50, 116}, {-50, 116}}, color = {255, 0, 255}));
  connect(idealClosingSwitch.control, Sb) annotation(
    Line(points = {{-12, 54}, {-12, 54}, {-12, 76}, {-6, 76}, {-6, 116}, {-6, 116}}, color = {255, 0, 255}));
  connect(idealClosingSwitch1.control, Sc) annotation(
    Line(points = {{22, 56}, {36, 56}, {36, 108}, {36, 108}, {36, 116}}, color = {255, 0, 255}));
  connect(not1.y, idealClosingSwitch3.control) annotation(
    Line(points = {{-31.5, 89}, {-33.5, 89}, {-33.5, -1}, {-35.5, -1}}, color = {255, 0, 255}));
  connect(not2.y, idealClosingSwitch2.control) annotation(
    Line(points = {{12.5, 89}, {14.5, 89}, {14.5, 71}, {-9.5, 71}, {-9.5, -3}, {-9.5, -3}}, color = {255, 0, 255}));
  connect(not3.y, idealClosingSwitch4.control) annotation(
    Line(points = {{54.5, 89}, {52.5, 89}, {52.5, -1}, {24.5, -1}, {24.5, -1}}, color = {255, 0, 255}));
  connect(DC_Out, idealClosingSwitch2.n) annotation(
    Line(points = {{-114, -22}, {-22, -22}, {-22, -16}, {-22, -16}}, color = {0, 0, 255}));
  connect(Connector.R, idealClosingSwitch3.p) annotation(
    Line(points = {{64.8, 26}, {-47.2, 26}, {-47.2, 10}, {-47.2, 10}, {-47.2, 10}}, color = {0, 0, 255}));
  connect(Connector.Y, idealClosingSwitch2.p) annotation(
    Line(points = {{64.8, 19.2}, {-23.2, 19.2}, {-23.2, 9.2}, {-21.2, 9.2}, {-21.2, 7.2}}, color = {0, 0, 255}));
  connect(Connector.B, idealClosingSwitch4.p) annotation(
    Line(points = {{64.8, 12.4}, {12.8, 12.4}, {12.8, 10.4}, {12.8, 10.4}, {12.8, 10.4}}, color = {0, 0, 255}));
  connect(Connector.Plug_p, Plug_p) annotation(
    Line(points = {{85.2, 19.6}, {131.2, 19.6}, {131.2, 19.6}, {135.2, 19.6}}, color = {0, 0, 255}));
  connect(powerSensor.nc, switch.p) annotation(
    Line(points = {{-64, 66}, {-50, 66}, {-50, 66}, {-50, 66}}, color = {0, 0, 255}));
  connect(powerSensor.pc, DC_In) annotation(
    Line(points = {{-84, 66}, {-108, 66}, {-108, 46}, {-114, 46}}, color = {0, 0, 255}));
  connect(powerSensor.nv, DC_Out) annotation(
    Line(points = {{-74, 56}, {-76, 56}, {-76, -14}, {-114, -14}, {-114, -22}}, color = {0, 0, 255}));
  connect(powerSensor.pv, DC_In) annotation(
    Line(points = {{-74, 76}, {-110, 76}, {-110, 46}, {-114, 46}}, color = {0, 0, 255}));
  connect(mean.u, powerSensor.power) annotation(
    Line(points = {{-94, 88}, {-84, 88}, {-84, 56}, {-84, 56}}, color = {0, 0, 127}));
  annotation(
    Diagram);
end TwoLevelInverterBooleanOutput;
 

within MPC_Motor.Components;
model TwoLevelInverterRealOutput
  extends MPC_Motor.Interfaces.PartialInverter;
equation
  DC_In.i + DC_Out.i = 0;
  DC_In.i = Sa * Plug_p.pin[1].i + Sb * Plug_p.pin[2].i + Sc * Plug_p.pin[3].i;
  Plug_p.pin[1].v = Sa * (DC_In.v - DC_Out.v);
  Plug_p.pin[2].v = Sb * (DC_In.v - DC_Out.v);
  Plug_p.pin[3].v = Sc * (DC_In.v - DC_Out.v);
end TwoLevelInverterRealOutput;
 

within MPC_Motor.Interfaces;
expandable connector DataBus
  extends Modelica.Icons.SignalBus;
  Modelica.SIunits.AngularVelocity Wm(displayUnit = "rad/s") "Actual speed";
  Modelica.SIunits.Current Is[2] "Actual current";
  Modelica.SIunits.ElectricFlux Fs[2];
  Modelica.SIunits.ElectricFlux Fr[2];
  Integer x_opt;
  Modelica.SIunits.Torque Tref;
  Modelica.SIunits.ElectricFlux Fsref;
end DataBus;
 

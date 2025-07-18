# From F-16
# RAIN ==============================================================
# Rain splashes will render automatically when the weather system reports
# rain via environment/rain-norm. In addition, the user can set rain
# splashes to render via environment/aircraft-effects/ground-splash-norm
# (this is intended to allow splashes to be rendered e.g. for water landings
# of aircraft equipped with floats).
#
# By default, the rain splashes impact from above (more precisely the +z
# direction in model coordinates). This may be inadequate if the aircraft
# is moving. However, the shader can not know what the airstream at the
# glass will be, so the impact vector of rain splashes has to be modeled
# aircraft-side and set via environment/aircraft-effects/splash-vector-x
# (splash-vector-y, splash-vector-z). These are likewise in model coordinates.
#
# As long as the length of the splash vector is <1, just the impact angle will
# change, as the length of the vector increases to 2, droplets will also be
# visibly moving. This allows fine control of the visuals dependent on any
# number of factors desired. 

var fromNose  = props.globals.getNode("velocities/uBody-fps");
var fromRight = props.globals.getNode("velocities/vBody-fps");
var fromBelow = props.globals.getNode("velocities/wBody-fps");

var splashX = props.globals.getNode("environment/aircraft-effects/splash-vector-x",1);
var splashY = props.globals.getNode("environment/aircraft-effects/splash-vector-y",1);
var splashZ = props.globals.getNode("environment/aircraft-effects/splash-vector-z",1);

var airspeedProp = props.globals.getNode("velocities/airspeed-kt");

var rtimer = maketimer(0.05, func {
   var airspeed = airspeedProp.getValue();
   var airspeed_max = 120;
   if (airspeed > airspeed_max) {
      #airspeed = airspeed_max;

      var vectorAC = [fromNose.getValue(),fromRight.getValue(),fromBelow.getValue()];

      vectorAC = vector.Math.normalize(vectorAC);

      splashX.setDoubleValue(vectorAC[0]*2);
      splashY.setDoubleValue(vectorAC[1]*2);
      splashZ.setDoubleValue(vectorAC[2]*2);
      #print(vector.Math.format(vectorAC));
   } else {
      airspeed = math.sqrt(airspeed/airspeed_max);

      var splash_x = -0.1 - 2.0 * airspeed;# -0.1 to -2.10
      var splash_z = 1.0 - 1.35 * airspeed;#  1.0 to -0.35

      splashX.setDoubleValue(-splash_x);
      splashY.setDoubleValue(0);
      splashZ.setDoubleValue(-splash_z);
   }

#   setprop("environment/aircraft-effects/frost-level", getprop("/fdm/jsbsim/systems/ecs/windscreen-frost-amount"));
if (getprop("fdm/jsbsim/fcs/elec-1") == 0){
   setprop("f22/brightness",0);
}

   }
);
rtimer.start();

aircraft.tyresmoke_system.new(0, 1, 2);

# If these are not random then people who just fly might accidently be on same channel by mistake.
# Or if they are previous day was fighting together with same channels, they should now have to intentionally setup, so not to enherit old fights values.
#setprop("instrumentation/iff/channel-selection", int(rand()*10000));
#setprop("instrumentation/datalink/channel", int(rand()*10000));
# nice hiding spot. but not needed
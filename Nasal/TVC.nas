# FCS thrust vectoring handler
#--------------------------------------------------------------------
# Globals
var pitch =  getprop("")
#--------------------------------------------------------------------
# Functions
#--------------------------------------------------------------------
initialise = func {
  eng0_vector_norm.setDoubleValue(0);
  eng1_vector_norm.setDoubleValue(0);
  eng0_vector_norm.setDoubleValue(0);
  eng1_vector_norm.setDoubleValue(0);
  settimer(vector_left, 5);
  settimer(vector_right, 5);
}
#--------------------------------------------------------------------

#--------------------------------------------------------------------
vector_right = func {
  # Slaves the Right engine vectoring to the right elevon-pos-norm.
  # Note that the scaling is applied in YASim.

  var right = getprop("fdm/jsbsim/fcs/tv-animation");
  var right2 = getprop("fdm/jsbsim/fcs/vector-right-main");
  var left2 = getprop("fdm/jsbsim/fcs/vector-left-main");
  setprop("engines/engine[1]/vector-norm", right / 30);
  setprop("fdm/jsbsim/propulsion/engine[1]/pitch-angle-rad", right2 * -1.8); # this is ok
  settimer(vector_right, 0.001);
}
#--------------------------------------------------------------------

# used to the animation of the canopy switch and the canopy move
# toggle keystroke or 2 position switch

var cnpy = aircraft.door.new("canopy", 10);
var switch = getprop("canopy/enabled", 1);
var pos = props.globals.getNode("canopy/position-norm", 1);

var canopy_switch = func(v,a) {

	var p = pos.getValue();
  var condition = getprop("/canopy/enabled");

	if (a == 2 ) {
		if ( p < 1 ) {
			a = 1;
		} elsif ( p >= 1 ) {
			a = -1;
		}
	}
if (v) {
	if (a < 0) {
		cnpy.close();
		setprop("canopy/state", 0);
	} elsif (a > 0) {
		setprop("canopy/state", 1);
		cnpy.open();

  	}
  }
}

# fixes cockpit when use of ac_state.nas #####
var cockpit_state = func {
	var switch = getprop("sim/model/f22/controls/canopy/canopy-switch");
	if ( switch == 1 ) {
		setprop("canopy/position-norm", 0);
	}
}
	    myRadar = radar.Radar.new();
		myRadar.init();




var flares = func{
	var flarerand = rand();
props.globals.getNode("/rotors/main/blade[3]/flap-deg",1).setValue(flarerand);
props.globals.getNode("/rotors/main/blade[3]/position-deg",1).setValue(flarerand);
settimer(func   {
    props.globals.getNode("/rotors/main/blade[3]/flap-deg").setValue(0);
    props.globals.getNode("/rotors/main/blade[3]/position-deg").setValue(0);
                },1);

}


var cha_flare = func{

	 if (getprop("/ai/submodels/submodel/flare-release")) {
  setprop("Sound/flare", 1);
interpolate("Sound/flare", 0, 1.2);
   }
}




var timer_loop = func{
# logic

# Pull up alarm. 
# From respective owners

		 if (getprop("velocities/speed-east-fps") != 0 or getprop("velocities/speed-north-fps") != 0) {
      var start = geo.aircraft_position();
      var speed_down_fps  = getprop("velocities/speed-down-fps");
      var speed_east_fps  = getprop("velocities/speed-east-fps");
      var speed_north_fps = getprop("velocities/speed-north-fps");
      var speed_horz_fps  = math.sqrt((speed_east_fps*speed_east_fps)+(speed_north_fps*speed_north_fps));
      var speed_fps       = math.sqrt((speed_horz_fps*speed_horz_fps)+(speed_down_fps*speed_down_fps));
      var heading = 0;
      if (speed_north_fps >= 0) {
        heading -= math.acos(speed_east_fps/speed_horz_fps)*R2D - 90;
      } else {
        heading -= -math.acos(speed_east_fps/speed_horz_fps)*R2D - 90;
      }
      heading = geo.normdeg(heading);

      var end = geo.Coord.new(start);
      end.apply_course_distance(heading, speed_horz_fps*FT2M);
      end.set_alt(end.alt()-speed_down_fps*FT2M);

      var dir_x = end.x()-start.x();
      var dir_y = end.y()-start.y();
      var dir_z = end.z()-start.z();
      var xyz = {"x":start.x(),  "y":start.y(),  "z":start.z()};
      var dir = {"x":dir_x,      "y":dir_y,      "z":dir_z};

      var geod = get_cart_ground_intersection(xyz, dir);
      if (geod != nil) {
        end.set_latlon(geod.lat, geod.lon, geod.elevation);
        var dist = start.direct_distance_to(end)*M2FT;
        var time = dist / speed_fps;
        setprop("/sim/model/radar/time-until-impact", time);
      } else {
        setprop("/sim/model/radar/time-until-impact", -1);
      }
}


};
Flare_timer = maketimer(0.25, cha_flare);

setlistener("sim/signals/fdm-initialized", func {
    Flare_timer.start();
});
    Flare_timer.start();

    # loop body


timer_loopTimer = maketimer(0.25, timer_loop);

setlistener("sim/signals/fdm-initialized", func {
    timer_loopTimer.start();
});
    timer_loopTimer.start();

    # loop body



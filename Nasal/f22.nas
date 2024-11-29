# Hide the hud when not in the cockpit view
setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);



# used to the animation of the canopy switch and the canopy move
# toggle keystroke or 2 position switch

var cnpy = aircraft.door.new("canopy", 10);
var switch = getprop("canopy/enabled", 1);
var pos = props.globals.getNode("canopy/position-norm", 1);
var dt = 0;
var time = getprop("/sim/time/elapsed-sec");



# Electric system for the engines:

# Detect the status of the main power switch. then check if the engines are dead. 
# if all's good. start the engines

var engloop = func{
var jfsr = getprop("controls/electric/engine/start-r");
var jfsl = getprop("controls/electric/engine/start-l");
var bat = getprop("controls/electric/battswitch");
            if(getprop("controls/electric/battswitch") >= 1) {

              if(getprop("/engines/engine/n1") < 28) {
              setprop("/controls/engines/engine/starter",getprop("controls/electric/engine/start-r"));
              print("eng1 rebound disarmed");
            }

            if(getprop("/engines/engine[1]/n1") < 28) {
              setprop("/controls/engines/engine[1]/starter",getprop("controls/electric/engine/start-l"));
              print("eng2 rebound disarmed");
            } 



            if(getprop("/engines/engine/n1") > 28) {
              # Rebound the switches when its good
              setprop("controls/electric/engine/start-r",getprop("/controls/engines/engine/starter"));
              #print("eng1 rebound armed");
            }

            if(getprop("/engines/engine[1]/n1") > 28) {

              # Rebound the switches when its good
              setprop("controls/electric/engine/start-l",getprop("/controls/engines/engine[1]/starter"));
              #print("eng2 rebound armed");
            } 

            }





}





var fire = func(v,a) {
# This controls the Bay doors automaticly
# Call this when you shoot a missile.
var dt = 0;
var time = getprop("/sim/time/elapsed-sec");
var weapon = getprop("/controls/armament/selected-weapon-digit");


# Open the bay doors
# Determine weapon

	if (weapon == 2) {
# aim-120
            if(time - dt > 1)
            {
                dt = time;
	            	setprop("/controls/baydoors/AIM120", 1);
                print("bay doors open");
                timer_baydoorsclose.start();
            }




	} elsif (weapon == 1) {
# aim-9X
            if(time - dt > 1)
            {
                dt = time;
	            	setprop("/controls/baydoors/AIM9X", 0);          # animations are inverted: todo fix the bay door animations
                print("9x doors open");
                timer_baydoorsclose.start();     
            }




  }
}


var closebays = func{
	            	setprop("/controls/baydoors/AIM120", 0);
	            	setprop("/controls/baydoors/AIM9X", 1);  # animations are inverted: todo fix the bay door animations
                print("closed");
                timer_baydoorsclose.stop();
}




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



var missile_sfx = func {
                setprop("/controls/armament/missile-trigger", 0); 

        }

settimer(missile_sfx, 2); # runs myFunc after 2 seconds

var flares = func{
	var flarerand = rand();
props.globals.getNode("/rotors/main/blade[3]/flap-deg",1).setValue(flarerand);
props.globals.getNode("/rotors/main/blade[3]/position-deg",1).setValue(flarerand);
settimer(func   {
    props.globals.getNode("/rotors/main/blade[3]/flap-deg").setValue(0);
    props.globals.getNode("/rotors/main/blade[3]/position-deg").setValue(0);
                },1);

}



var checkforext = func {
	var pylon3 = getprop("sim/weight[2]/selected");
  	var pylon5 = getprop("sim/weight[4]/selected");


	if ( pylon3 == "Aim-120" or pylon3 == "Aim-9x" or pylon3 == "Aim-7" or pylon3 == "Aim-9m" or pylon5 == "Aim-120" or pylon5 == "Aim-9x" or pylon5 == "Aim-7" or pylon5 == "Aim-9m" ) {
		setprop("controls/armament/extpylons", 1);
	} else {
		setprop("controls/armament/extpylons", 0);

  }


}



var cha_flare = func{
print("0");
  setprop("controls/CMS/flaresound", 0);

}

var flare = func{
      Flare_timer.stop();
print("setting...");
  setprop("controls/CMS/flaresound", 1);
      print("set to one");

}

var flarestop = func{
    Flare_timer.start();
print("stop");
}


var flarecheck = func{
        setprop("payload/armament/flares", 0);
}




var repair = func{
#f22.repair()

 setprop("f22/ejected", 0);
 setprop("/sim/failure-manager/engines/engine/serviceable",1);
 setprop("/sim/failure-manager/engines/engine[1]/serviceable",1);

}



#eject



var eject = func{
#    if (getprop("f22/ejected")==1 or !getprop("controls/seat/ejection-safety-lever")) {
#      print("Cant eject!");
#        return;
#    }
    # ACES II activation
  print("Eject Phase one starting");
    setprop("/sim/messages/atc", "Ejecting!");
    view.setViewByIndex(1);
    setprop("f22/ejected",1);
    setprop("/controls/engines/engine/cut-off",1);
    setprop("/controls/engines/engine[2]/cut-off",1);
    setprop("/sim/failure-manager/engines/engine/serviceable",0);
    setprop("/sim/failure-manager/engines/engine[1]/serviceable",0);

    settimer(eject2, .5);# this is to give the sim time to load the exterior view, so there is no stutter while seat fires and it gets stuck.
    damage.damageLog.push("Pilot ejected");

    print("Phase 1 done!")
}

var eject2 = func{
    setprop("canopy/Jettison", 1);  # Jett the canopy

#Spawning of the "Missile"  Lol
print("made it this far, lets spawn a chair!");
 setprop("/controls/flight/speedbrake",1);
  setprop("/controls/armament/selected-weapon", "eject");
  setprop("/sim/weight[9]/selected", "eject");
  setprop("/controls/armament/station[9]/release", 0);
                m2000_load. SelectNextPylon();
                var pylon = getprop("/controls/armament/missile/current-pylon");
                m2000_load.dropLoad(pylon);
                print("Should eject!");

   # viewMissile.view_firing_missile(es);
    #setprop("sim/view[0]/enabled",0); #disabled since it might get saved so user gets no pilotview in next aircraft he flies in.
#    settimer(func {crash.eject();},3.5);  turn off the jet if its still alive
}





var damagedetect = func{

var a = getprop("/sim/failure-manager/controls/flight/aileron/serviceable");
var b = getprop("/sim/failure-manager/controls/flight/elevator/serviceable");
var c = getprop("/sim/failure-manager/controls/flight/rudder/serviceable");
	if ( a == 0 ) {
            setprop("sim/multiplay/generic/bool[1]",1);
		if ( b == 0 ) {
              setprop("sim/multiplay/generic/bool[1]",1);
			if ( c == 0 ) {
        setprop("sim/multiplay/generic/bool[1]",1);
        }
    }
  }else{
            setprop("sim/multiplay/generic/bool[1]",0);
  }

}


var tgtlock = func{
if (getprop("instrumentation/radar/lock") == 1){
var target1_x = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("h-offset",1).getValue();
var target1_z = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("v-offset",1).getValue();
setprop("instrumentation/radar2/lockmarker", target1_x / 10);
setprop("instrumentation/radar2/lockmarker", target1_x / 10);
setprop("instrumentation/radar/az-field", 161);
# setprop("instrumentation/radar/grid", 0);
print(target1_x / 10);
setprop("instrumentation/radar2/sweep-speed", 10);
  } elsif (getprop("instrumentation/radar/lock") == 0){

  
    if(getprop("instrumentation/radar/mode/main") == 1)
    {
        setprop("instrumentation/radar/az-field", 120);
        setprop("instrumentation/radar2/sweep-display-width", 0.0846);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
      #  wcs_mode = "pulse-srch";
      #  AzField.setValue(120);
      #  swp_diplay_width = 0.0844;
    }
    elsif(getprop("instrumentation/radar/mode/main") == 0)
    {
        setprop("instrumentation/radar/az-field", 60);
        setprop("instrumentation/radar/mode/main", 0);
        #wcs_mode = "tws-auto";
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
        tgts_list = [];
    }
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



# Jitter

var jitter = func{
	            	setprop("/controls/rand", rand());
	            	setprop("/controls/rand2", rand());
}


# Timers




locktgt_timer = maketimer(0.1, tgtlock);

Flare_timer = maketimer(0.9, cha_flare);
timer_flarecheck = maketimer(1.8, flarecheck);  # To make the target need to keep putting out flares for the number to stay 1 and make missiles detect them
settimer(missile_sfx, 2); # runs myFunc after 2 seconds
timer_eng = maketimer(0.25, engloop);
timer_loopTimer = maketimer(0.25, timer_loop);
timer_extpylons = maketimer(0.25, checkforext);
timer_baydoorsclose = maketimer(1, closebays);
timer_damage = maketimer(0.5, damagedetect);
timer_jitter = maketimer(0.1, jitter);

setlistener("sim/signals/fdm-initialized", func {
    timer_jitter.start();  
      timer_flarecheck.start();          # flare checker
    timer_eng.start();          # engines
    timer_loopTimer.start();    # Pullup alarm
    timer_extpylons.start();    # External pylon detection
        timer_damage.start();
});
    timer_loopTimer.start();
    timer_extpylons.start();
    locktgt_timer.start();
    # loop body


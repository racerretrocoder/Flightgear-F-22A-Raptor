
# Phoenix F-22A.nas
# Hide the hud when not in the cockpit view
# setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);
# Not needed anymore because of the added canvas hud

# Init some vars
setprop("f22/chaff",200);
setprop("f22/flare",200);
setprop("/f22/crash/explodesfx",0);
setprop("/f22/crash/splashsfx",0);
setprop("controls/bdl",1); # Baydoor Switches
setprop("controls/bdr",1); # Baydoor Switches
setprop("/f22/dead",0); # Dead
setprop("/f22/crash/doneonce",0);
setprop("/f22/crash/alt",0);
setprop("/f22/crash/type",0);
# used to the animation of the canopy switch and the canopy move
# toggle keystroke or 2 position switch
setprop("f22/head-hdg-deg",0);
setprop("f22/head-ptc-deg",0);
var cnpy = aircraft.door.new("canopy", 10);
var switch = getprop("canopy/enabled", 1);
var pos = props.globals.getNode("canopy/position-norm", 1);
var dt = 0;
var time = getprop("/sim/time/elapsed-sec");


var updatehead = func {
  if (getprop("sim/current-view/internal") == 1) {
    setprop("f22/head-hdg-deg",getprop("sim/current-view/heading-offset-deg"));
    setprop("f22/head-ptc-deg",getprop("sim/current-view/pitch-offset-deg"));
  }
}

var autoflares = func{
  setprop("/ai/submodels/submodel/flare-release",1);
  f22.flares();
  damage.flare_released();
  settimer(func{setprop("/ai/submodels/submodel/flare-release",0);},0.1)
}


var waterstop = func {
  setprop("/sim/multiplay/generic/bool[4]",0); 
  timer_water.stop();
}


#setprop("/sim/multiplay/generic/bool[4]",1);
#setprop("/sim/multiplay/generic/bool[4]",0);

timer_water = maketimer(2,waterstop);
setprop("f22/runonce",0);
var kaboom = func(speed,type) {
  var onground = 1;
  print("hello");
  if (getprop("/position/altitude-ft") < 0) {
    print("water!");
    setprop("/f22/crash/type",5);
    setprop("/velocities/airspeed-kt",0);
    setprop("/f22/crash/splashsfx",1);
    onground = 0;
    var runonce = getprop("f22/runonce");
    if (getprop("f22/runonce") == 0) {
      setprop("/sim/multiplay/generic/bool[4]",1);

      timer_water.start();
      screen.log.write("Sunk into water! Maximum Damage",1,0,0);
      setprop("f22/runonce",1);
    }
  }

print("hello2");
  if (speed > 80 and onground == 1) {
    # SLAM!
    setprop("/f22/crash/explodsfx",1);
    setprop("/sim/multiplay/generic/bool[2]",1); # Turn on fire
    setprop("/sim/multiplay/generic/bool[3]",1); # Turn on smoke
  }
  if (speed < 80 and onground == 1) {
    # SLAM!
    setprop("/sim/multiplay/generic/bool[2]",0); # Turn off fire
    setprop("/sim/multiplay/generic/bool[3]",1); # Turn on smoke
  }
  if (onground == 0) {
    # Water!
    setprop("/sim/multiplay/generic/bool[2]",0); # Turn off fire
    setprop("/sim/multiplay/generic/bool[3]",0); # Turn on smoke
  }
  
}


var crashdetect = func {
    if (getprop("/position/altitude-agl-ft") < 0){
            # Ouch!! That hurt!
      var speed = getprop("/velocities/airspeed-kt");
      var pitch = getprop("/orientation/pitch-deg");
      var alpha = getprop("/orientation/alpha-deg");

      # First before doing anything detect what kinda crash we are dealing with
      # Ill add different crash looks in a bit
      # If in the cockpit switch to ext view 
      if (getprop("/sim/current-view/internal") == 1) {
        view.setViewByIndex(1); # Helicopter view
      }
        # A slow fall to the ground < 130kts, probably flying slightly straight
        if (getprop("/f22/dead") == 0){

        
            if (speed < 100) {
              screen.log.write("You crashed! Light Damage",1,0,0);
              setprop("/f22/dead",1);
              setprop("/f22/crash/type",1);
              setprop("/f22/crash/doneonce",1);
            }
        # Highspeed crash
            if (speed > 100 and speed < 160) {
              screen.log.write("You crashed! Medium Damage",1,0,0);
              setprop("/f22/dead",2);
              setprop("/f22/crash/type",2);
              setprop("/f22/crash/doneonce",1);
            }
            if (speed > 160 and speed < 190) {
              screen.log.write("You crashed! Heavy Damage",1,0,0);
              setprop("/f22/dead",3);
              setprop("/f22/crash/type",2);
              setprop("/f22/crash/doneonce",1);
            }
            if (speed > 190 and speed < 280) {
              screen.log.write("You crashed! Extreme Damage",1,0,0);
              setprop("/f22/dead",4);
              setprop("/f22/crash/type",2);
              setprop("/f22/crash/doneonce",1);
            }   
            if (speed > 280) {
              screen.log.write("You crashed! Maximum Damage",1,0,0);
              setprop("/f22/dead",5);
              setprop("/f22/crash/type",2);
              setprop("/f22/crash/doneonce",1);
            } 
        }
       # Hide the model. Its gone
      setprop("/sim/failure-manager/controls/flight/aileron/serviceable",1); # Kill Controls
      setprop("/sim/failure-manager/controls/flight/elevator/serviceable",0); # Kill Controls
      setprop("/sim/failure-manager/controls/flight/rudder/serviceable",0);   # Kill Controls
      setprop("controls/engines/engine[0]/cutoff",1); # Engine off
      setprop("controls/engines/engine[1]/cutoff",1); # Engine off
      var speed = getprop("/velocities/airspeed-kt");
      var type = getprop("/f22/crash/type");
      kaboom(speed,type); # show fire
      setprop("/position/altitude-ft",getprop("/position/ground-elev-ft") - 3); # Hug the ground. But stay under it


    }
}





#
# APU Startup Sequencing
#


# play sound
# first open flaps
setprop("controls/apu/run",0);
var apuseq1 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/start",1);
  setprop("controls/apu/flap",1);
  seq2timer.start();
}

var apuseq2 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/start",1);
  seq2timer.stop();
  seq3timer.start();
}

var apuseq3 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/smokespeed",10);
  setprop("controls/apu/smoke",1);
  seq3timer.stop();
  seq4timer.start();
}

var apuseq4 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/smoke",0);
  setprop("controls/apu/apuflame",1);
  seq4timer.stop();
  seq5timer.start();
}

var apuseq5 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/smoke",1);
  setprop("controls/apu/apuflame",0);
  setprop("controls/apu/smoke",0);
  seq5timer.stop();
  seq6timer.start();
}

var apuseq6 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/smoke",1);
  seq6timer.stop();
  seq7timer.start();
}
var apuseq7 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/smoke",0);
  seq7timer.stop();
  seq8timer.start();
}
var apuseq8 = func() {
  # APU Animation/sequence !
  setprop("controls/apu/run",1);
  setprop("controls/electric/apustart",0); # Return to run
  setprop("controls/electric/apustartpos",0); # Return to run
  setprop("controls/apu/start",0);
  #apuon();
  seq8timer.stop();
  #seq8timer.start();
}

var apushutoffmain = func() {
  # APU Animation/sequence !
  setprop("controls/apu/startinprogress",0);
  setprop("controls/apu/run",0);

  setprop("controls/apu/spooldown",1);
  offtimer.start();
  #seq8timer.start();
}

var apushutoff = func() {
  # APU Animation/sequence !
  setprop("controls/apu/spooldown",2); # Stop the sound
  setprop("controls/apu/flap",0); # Close the flaps
  offtimer.stop();
  #seq8timer.start();
}

# Timers

seq2timer = maketimer(0.3,apuseq2);
seq3timer = maketimer(0.4,apuseq3);
seq4timer = maketimer(0.5,apuseq4);
seq5timer = maketimer(0.5,apuseq5);
seq6timer = maketimer(2,apuseq6);
seq7timer = maketimer(0.5,apuseq7);
seq8timer = maketimer(18,apuseq8);
offtimer = maketimer(16,apushutoff);
#apudoortimer = maketimer(, apuseq1);

setprop("controls/apu/startinprogress",0);


# Electric system for the engines and the APU:

# Detect the status of the main power switch. then check if the engines are dead. 
# if all's good. start the engines
# Controls the battery switch, APU, and Engine start switches and there effectiveness (If they work or not)

var engloop = func{
setprop("sim/multiplay/visibility-range-nm",2000); # Going to put this here because smh the -set dosent set it to be 1000
var jfsr = getprop("controls/electric/engine/start-r");
var jfsl = getprop("controls/electric/engine/start-l");
var bat = getprop("controls/electric/battswitch");
#print("In ENGINE LOOP!");
            if(getprop("controls/electric/battswitch") >= 1) {
                # check the APU the apu
                if(getprop("/controls/apu/startinprogress") == 0) {

                if(getprop("/controls/electric/apustart") == 1) {
                      # Start the APU
                      print("starting APU!");
                      f22.apuseq1();
                      setprop("controls/apu/startinprogress",1);
                }
              }
                if(getprop("/controls/apu/startinprogress") == 1) {

                if(getprop("/controls/electric/apustart") == -1) {
                      # Stop the APU
                      print("stopping APU!");
                      f22.apushutoffmain();
#setprop("controls/apu/startinprogress",1);
                }
              }
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


# Shaking cockpit made from 707 and the mirage 2005


var shake = func() {# from mirage 2005
var rSpeed  = getprop("/velocities/airspeed-kt") or 0;
	var G       = getprop("/accelerations/pilot-g");
	var alpha   = getprop("/orientation/alpha-deg");
	var mach    = getprop("velocities/mach");
	var wow     = getprop("/gear/gear[1]/wow");
	var gun     = getprop("controls/armament/gun-trigger");
	var myTime  = getprop("/sim/time/elapsed-sec");

	#sf = ((rSpeed / 500000 + G / 25000 + alpha / 20000 ) / 3) ;
	# I want to find a way to improve vibration amplitude with sf, but to tired actually to make it.

	if ((((G > 9 or alpha > 28) and rSpeed > 40) or (mach > 0.99 and mach < 1.01) or (wow and rSpeed > 100) or gun) or getprop("damage/sounds/missile-hit")) {
    timer_hit.start();
		setprop("controls/cabin/shaking", math.sin(48 * myTime) / 222.222);
	}
	else {
		setprop("controls/cabin/shaking", 0);
	}
}# from m2005

shake_timer = maketimer(0.0001, shake);
shake_timer.start();







# damage shake. From the mirage 2005 but with a small modification

# shake like bonkers when the plane is damaged
var shake2 = func() {# from m2005
var rSpeed  = getprop("/velocities/airspeed-kt") or 0;
	var G       = getprop("/accelerations/pilot-g");
	var alpha   = getprop("/orientation/alpha-deg");
	var mach    = getprop("velocities/mach");
	var wow     = getprop("/gear/gear[1]/wow");
	var gun     = getprop("controls/armament/gun-trigger");
	var myTime  = getprop("/sim/time/elapsed-sec");

	#sf = ((rSpeed / 500000 + G / 25000 + alpha / 20000 ) / 3) ;
	# I want to find a way to improve vibration amplitude with sf, but to tired actually to make it.

	if (getprop("damage/sounds/nearby-explode-on")) {
		setprop("controls/cabin/shaking2", math.sin(48 * myTime) / 10.999);
	}
	else {
		setprop("controls/cabin/shaking2", 0);
	}
}# from m2005




shake_timer2 = maketimer(0.00001, shake2);
shake_timer2.start();

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



# Auto-open Aim-9X Doors when they lock on. Then close them shortly after they delock
var aimlock = func() {
var weapon = getprop("/controls/armament/selected-weapon-digit");
var lock = getprop("/instrumentation/radar/lock");
  if (weapon == 1) {

if (lock == 1){
  	   setprop("/controls/baydoors/AIM9X", 0);          # animations are inverted: todo fix the bay door animations
       print("9x doors open");
    } else {
          timer_baydoorsclose.start();     
    }
  } 
}
aimlock = maketimer(0.3, aimlock);
aimlock.start();





var closebays = func{
	            	setprop("/controls/baydoors/AIM120", 0);
	            	setprop("/controls/baydoors/AIM9X", 1);  # animations are inverted: todo fix the bay door animations
                print("bay doors closed");
                timer_baydoorsclose.stop();
}



# Canopy
var canopy_switch = func(v,a) {
	var p = pos.getValue();
  var condition = getprop("/canopy/enabled");
  if (getprop("gear/gear/wow") == 1){
	if (a == 2 ) {
		if ( p < 1 ) {
			a = 1;
		} elsif ( p >= 1 ) {
			a = -1;
		}
	}
cnpy.toggle();
  } else {
    screen.log.write("Can't open canopy in flight")
  }
}

# fixes cockpit when use of ac_state.nas #####
var cockpit_state = func {
	var switch = getprop("sim/model/f22/controls/canopy/canopy-switch");
	if ( switch == 1 ) {
		setprop("canopy/position-norm", 0);
	}
}


# INIT radar2.nas
myRadar = radar.Radar.new();
myRadar.init();



var missile_sfx = func {
  setprop("/controls/armament/missile-trigger", 0); 
}

settimer(missile_sfx, 2); 

var flares = func{
  flare();
	var flarerand = rand();
    setprop("/rotors/main/blade[3]/flap-deg", flarerand); 
    setprop("/rotors/main/blade[3]/position-deg", flarerand);
settimer(func   {
  setprop("/rotors/main/blade[3]/flap-deg", 0);
    setprop("/rotors/main/blade[3]/position-deg", 0);
                },0.1);
}



var checkforext = func {
  # Check for external pylons and Mount them when armament is loaded
  # Also check for fuel in the EXT tanks if there are no EXT tanks mounted. then remove and show a message
  var leftdrop = getprop("controls/armament/ldt");
  var rightdrop = getprop("controls/armament/rdt");
	var pylon3 = getprop("sim/weight[2]/selected");
  var pylon5 = getprop("sim/weight[4]/selected");
  var fuelleft = getprop("consumables/fuel/tank[2]/level-lbs");
  var fuelright = getprop("consumables/fuel/tank[3]/level-lbs");
	if ( pylon3 == "Aim-120" or pylon3 == "Aim-9x" or pylon3 == "Aim-7" or pylon3 == "Aim-9m" or pylon5 == "Aim-120" or pylon5 == "Aim-9x" or pylon5 == "Aim-7" or pylon5 == "Aim-9m" or rightdrop == 1 or leftdrop == 1) {
		setprop("controls/armament/extpylons", 1);
	} else {
		setprop("controls/armament/extpylons", 0);

  }

  # only allow fuel entering EXT Tanks if the left and right tanks are filled
  if (leftdrop != 1 or rightdrop != 1) {
    setprop("consumables/fuel/tank[2]/level-lbs",0);
    setprop("consumables/fuel/tank[3]/level-lbs",0);
    if (fuelright > 0 or fuelleft > 0) {
      screen.log.write("There are no drop tanks attached");
    }
  }
}



var jettdroptanks = func {
  screen.log.write("JETT: Drop tanks");
  setprop("controls/armament/ldt",0);
  setprop("controls/armament/rdt",0);
}



# Extra flare stuff

var cha_flare = func{
#print("0");
  setprop("controls/CMS/flaresound", 0);
}

var flare = func{
      Flare_timer.stop();
print("f22.flare(): setting...");
  setprop("controls/CMS/flaresound", 1);
      print("f22.flare(): set to one");
      Flare_timer.start();
}

var flarestop = func{
    Flare_timer.start();
print("f22.flarestop(): stop");
}

var flarecheck = func{
        setprop("payload/armament/flares", 0);
}




var repair = func{
#f22.repair()
  setprop("/sim/failure-manager/controls/flight/aileron/serviceable",1); 
  setprop("/sim/failure-manager/controls/flight/elevator/serviceable",1);
  setprop("/sim/failure-manager/controls/flight/rudder/serviceable",1);  
  setprop("f22/runonce",0); # Reset Splash
  setprop("/sim/multiplay/generic/bool[2]",0); # Crash Effects
  setprop("/sim/multiplay/generic/bool[3]",0); # Crash Effects
  setprop("/sim/multiplay/generic/bool[4]",0); # Crash Effects
  setprop("f22/ejected", 0); # Restore pilot/canopy
  setprop("f22/dead",0); # Show the model
  setprop("/sim/failure-manager/engines/engine/serviceable",1); # Fix the engines
  setprop("/sim/failure-manager/engines/engine[1]/serviceable",1); # Fix the engines

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
    view.setViewByIndex(1); # Helicopter view
    setprop("f22/ejected",1); # hide canopy
    setprop("/controls/engines/engine/cut-off",1); # Engines Off
    setprop("controls/flight/elevator",-0.7);
    setprop("controls/flight/rudder",-1);
    setprop("/sim/failure-manager/controls/flight/aileron/serviceable",0); 
    setprop("/sim/failure-manager/controls/flight/elevator/serviceable",0);
    setprop("/sim/failure-manager/controls/flight/rudder/serviceable",0);  
    setprop("/controls/engines/engine[2]/cut-off",1); 
    #setprop("/sim/failure-manager/engines/engine/serviceable",0);
    #setprop("/sim/failure-manager/engines/engine[1]/serviceable",0); Not needed

    settimer(eject2, .5);# this is to give the sim time to load the exterior view, so there is no stutter while seat fires and it gets stuck.
    damage.damageLog.push("Pilot ejected");

    print("Phase 1 done!")
}

var eject2 = func{
    setprop("canopy/Jettison", 1);  # Jett the canopy
print("made it this far, lets spawn a chair!");
 setprop("/controls/flight/speedbrake",1);
  setprop("/controls/armament/selected-weapon", "eject");
  setprop("/sim/weight[9]/selected", "eject");
  setprop("/controls/armament/station[9]/release", 0);
                m2000_load. SelectNextPylon();
                var pylon = getprop("/controls/armament/missile/current-pylon");
                m2000_load.dropLoad(pylon);
                print("Should eject!");
  setprop("/sim/weight[9]/selected", "none");
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


# Cool Radar Stuff!
# Stuff like radar cursor position to callsign!
# Dogfight mode! (ACM Radar mode)


# Trying to make a radar cursor simulation. 
# Had an idea if the cursor position matched the position of the marker. 
# Find and lock the target we selected with the cursor. 
# Need more ideas to get this to work
var updatemkr = func() {
  var list = props.globals.getNode("/instrumentation/radar2/targets").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
      var mpid = i;
      var callsign = getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/callsign");
      #print("marker checking " ~ callsign ~ "");
      #var inrange = getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/display");
      if (getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/display") == 1){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/display",getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/display"));

      #
      # Range
      # 

      if (getprop("instrumentation/radar/range") == 10){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm"));
      }
      if (getprop("instrumentation/radar/range") == 20){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 2);
      }
      if (getprop("instrumentation/radar/range") == 40){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 4);
      }
      if (getprop("instrumentation/radar/range") == 60){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 6);
      }
      if (getprop("instrumentation/radar/range") == 160){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 16);
      }
      if (getprop("instrumentation/radar/range") == 300){ # WOWZERS!
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 30);
      }
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/location-x",getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/h-offset") / 10);
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/callsign",getprop("/instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/callsign"));
      } else {
      var range = 0; # mm yes lol
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/display",0);
      #   return 0;
      }
  }
}

mkrtimer = maketimer(0.1,updatemkr);
mkrtimer.start();


# What happens when the radar Locks on, Goes into STT and spikes target (see lockhelper.nas)
# Also controls the radar mode, Scanning settings, Azimuth, Speed, etc
var tgtlock = func{
if (getprop("instrumentation/radar/lock") == 1){
var target1_x = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("h-offset",1).getValue();
var target1_z = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("v-offset",1).getValue();
setprop("instrumentation/radar2/lockmarker", target1_x / 10);
setprop("instrumentation/radar2/lockmarker", target1_x / 10);
#setprop("instrumentation/radar/az-field", 161);
# setprop("instrumentation/radar/grid", 0);
#print(target1_x / 10);
setprop("instrumentation/radar2/sweep-speed", 10);
setprop("instrumentation/radar/lock2", 2);
  } elsif (getprop("instrumentation/radar/lock") == 0){

  
    if(getprop("instrumentation/radar/mode/main") == 3)
    {   # SLR
        setprop("instrumentation/radar/az-field", 280);
        setprop("instrumentation/radar2/sweep-display-width", 0.1646);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
        #acmtimer.stop();
      #  wcs_mode = "pulse-srch";
      #  AzField.setValue(120);
      #  swp_diplay_width = 0.0844;
    }  
    if(getprop("instrumentation/radar/mode/main") == 1)
    {   # RWS
        setprop("instrumentation/radar/az-field", 120);
        setprop("instrumentation/radar2/sweep-display-width", 0.0846);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
        #acmtimer.stop();
      #  wcs_mode = "pulse-srch";
      #  AzField.setValue(120);
      #  swp_diplay_width = 0.0844;
    }
    elsif(getprop("instrumentation/radar/mode/main") == 0)
    {
        setprop("instrumentation/radar/az-field", 60);

        # TWS
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
        tgts_list = [];
        #acmtimer.stop();
    }
    elsif(getprop("instrumentation/radar/mode/main") == 2)
    {
        setprop("instrumentation/radar/az-field", 60);
        # ACM
        #acmtimer.start();
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
        tgts_list = [];
    }

    
  }
}


# HOFFSET -6,

var checkclosestmp = func(cs=nil) {
setprop("misc/closestmp", 100000); # reset
  setprop("misc/callsign","abcdefghijk"); # reset
  var list = props.globals.getNode("/ai/models").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  var theprop = getprop("misc/closestmp");
  for(var i = 0; i < total; i += 1) {
      var mpid = i;
      var callsign = getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign");
      var inrange = getprop("ai/models/multiplayer[" ~ mpid ~ "]/radar/in-range");
      if (inrange == 1){
      var range = getprop("ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm");
      } else {
      var range = 99999; # mm yes lol
      }

      print("checking " ~ callsign ~ "");
      if (getprop("misc/closestmp") == 100000) {
        # Has been reset
        #screen.log.write("Begin mpsearch");
        #screen.log.write(i);
       #screen.log.write(callsign);
        setprop("misc/closestmp", range); # reset
        setprop("misc/callsign",callsign);

      } else {
        # Range has been changed lets check
       #screen.log.write(i);

        if (getprop("misc/closestmp") > range) {
          #screen.log.write("Found new closer target!");
           #screen.log.write(callsign);
          setprop("misc/closestmp", range);          
          setprop("misc/callsign",callsign);
        }
      }

  }
}


# ACM "Dogfight mode"
# Still experimental
# Debug messages left on
var radarlook = func(cs=nil) {
  var list = props.globals.getNode("/instrumentation/radar2/targets").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  print("hello!");
  for(var i = 0; i < total; i += 1) {
      var mpid = i;
      print(mpid);
      if (getprop("instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/h-offset") == nil) {
        print("thats nil!");
      }
      var callsign = getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign");
      if (getprop("instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/callsign") == nil or getprop("instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/callsign") == "") {
        print("radar callsign nil!");
      }
      if (getprop("instrumentation/radar/lock") == 1){
        print("radar is already locked");
        return 1;
      }

      #print("checking " ~ callsign ~ ".");
      var radarON = 1;
      var target1_x = getprop("instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/h-offset");
      var target1_z = getprop("instrumentation/radar2/targets/multiplayer[" ~ mpid ~ "]/v-offset");
      if (target1_x or 0 > 0 and radarON ==1)
      {
        var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
        var oriAngle = math.asin(target1_x / dist_O);
        if(target1_z < 0){
          oriAngle = 3.141592654 - oriAngle;
        }
        var Rollrad = (getprop("orientation/roll-deg") / 180) * 3.141592654;
        target1_x = dist_O * math.sin(oriAngle - Rollrad);
        target1_z = dist_O * math.cos(oriAngle - Rollrad);
        var kx = abs(target1_x/7.25);
        var kz = abs(target1_z/6);
        if((kx > 1) or (kz > 1)){
          if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
        }
#screen.log.write("x");
#screen.log.write(target1_x);
#screen.log.write("z");
#screen.log.write(target1_z); 
        # Z +6 -6
        # X +5 -5
        # i
        if (target1_x > -6 and target1_x < 6 and target1_z > -6 and target1_z < 6) {
          # Target is in the hud
          screen.log.write("Radar ACM: Can lock! Locking...");
          screen.log.write(callsign);
          #checkcloestmp("");
          #        screen.log.write("Radar: Locked "~tgts_list[Target_Index].Callsign.getValue(),1,1,0);''
         
          var radarcs = radar.tgts_list[radar.Target_Index].Callsign.getValue();
          acmcheck(radarcs,mpid,total);
          break;
        }
     }
  }
}


var acmcheck = func(radarcs,mpid,total) {
  screen.log.write("in here now");
  screen.log.write("total:" ~ total);
  screen.log.write("radarcs:" ~ radarcs);
  screen.log.write("mpid:" ~ mpid);
  for(var i = 0; i < total; i += 1) {
    #screen.log.write("Iteration: "~i~".");
    if (radarcs != getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign")) {
      #screen.log.write("Dosent match!");
      radar.next_Target_Index(1);
    } else {
      screen.log.write("Radar: ACM Locked "~radar.tgts_list[radar.Target_Index].Callsign.getValue());
      setprop("instrumentation/radar/lock", 1);
      break;
    }
  }
}

# Cool arrow pointer
setprop("controls/radar/lockedinhud",0);
var arrowpointer = func() {      
  var radarON = getprop("su-27/instrumentation/N010-radar/emitting");
  # First check if radar on and locked. else go away
  if (radarON != 1 or getprop("/instrumentation/radar/lock") != 1){
    return -1;
  }
  var target1_x = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("h-offset",1).getValue();
  var target1_z = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("v-offset",1).getValue();
  var lockedcallsign = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("callsign",1).getValue();
  if (target1_x or 0 > 0 and radarON == 1) {
    var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
    var oriAngle = math.asin(target1_x / dist_O);
    if(target1_z < 0){
      oriAngle = 3.141592654 - oriAngle;
    }
    var Rollrad = (getprop("orientation/roll-deg") / 180) * 3.141592654;
    target1_x = dist_O * math.sin(oriAngle - Rollrad);
    target1_z = dist_O * math.cos(oriAngle - Rollrad);
    var kx = abs(target1_x/7.25);
    var kz = abs(target1_z/6);
    if((kx > 1) or (kz > 1)){
      if(kx > kz){
        target1_x = target1_x / kx;
        target1_z = target1_z / kx;
      }else{
        target1_z = target1_z / kz;
        target1_x = target1_x / kz;
      }
    }
    if (target1_x > -6 and target1_x < 6 and target1_z > -6 and target1_z < 6) {
        # Target in the hud
        #screen.log.write("In HUD");
        setprop("/controls/radar/hud-pointer",0);
        setprop("/controls/radar/hud-rotate",0);
    } else {
        # Target not in hud
        setprop("/controls/radar/hud-pointer",1); # show arrow
        #screen.log.write(lockedcallsign);
        #screen.log.write(target1_x);
        #screen.log.write(target1_z);
        setprop("/controls/radar/error-deg",target1_x);
        setprop("/controls/radar/error-pitch-deg",target1_z);

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


# Radar Cursor
setprop("controls/radar/cursorx",0);
setprop("controls/radar/cursorz",0);
var cursor = func {
  # Check status of x and z (x and y)
  if (getprop("controls/radar/cursor-x") == 1) {
    setprop("controls/radar/cursorx", getprop("controls/radar/cursorx") + 0.003);
  }
  if (getprop("controls/radar/cursor-x") == -1) {
    setprop("controls/radar/cursorx", getprop("controls/radar/cursorx") - 0.003);
  }

  if (getprop("controls/radar/cursor-z") == 1) {
    setprop("controls/radar/cursorz", getprop("controls/radar/cursorz") - 0.003);
  }
  if (getprop("controls/radar/cursor-z") == -1) {
    setprop("controls/radar/cursorz", getprop("controls/radar/cursorz") + 0.003);
  }
}


# Jitter

var jitter = func{
	setprop("/controls/rand", rand());
	setprop("/controls/rand2", rand());
}


# missile hit set back

var mslhit = func{
  setprop("damage/sounds/missile-hit", 0);
  timer_hit.stop();
}



var updateradarcs = func {
# Add a if lock 
if (getprop("/instrumentation/radar/lock2") != 0){
  print("LOCKED!");
  var callsign = radar.tgts_list[radar.Target_Index].Callsign.getValue();
  var mpid = misc.smallsearch(callsign);
  var lockedalt = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/position/altitude-ft");
  setprop("controls/radar/lockedalt",lockedalt);
  setprop("controls/radar/lockedcallsign", radar.tgts_list[radar.Target_Index].Callsign.getValue());
  } else {
  # Not locked on
  print("aw not locked");
  setprop("controls/radar/lockedcallsign", "None");
  }
}


  setprop("controls/radar/lockedcallsign", "None");





var crashreinit = func {
  crash_timer.start();
  crashreinit_timer.stop();
}

var readyset = func{ 
  f22.testsetup();
  f22.testsetupmain();
  datalink.dlinit(); # Initalise the datalink. start the loops to recive data
}
var resetready = func{
  setprop("f22/ready",0); # 4835934785 Reset the MFDs
  rebound_timer.stop();
}

setprop("f22/blink",0);
var blink = func() {
  setprop("f22/blink",!getprop("f22/blink"));
}

var checkbingo = func() {
  if (getprop("consumables/fuel/total-fuel-lbs") < getprop("f22/bingo")){
    setprop("f22/isbingo",1);
  } else {
    setprop("f22/isbingo",0);
  }
}

var updatethrot = func() {
  setprop("f22/throttle",getprop("controls/engines/engine/throttle"));
}


var throt = func() {
  # throttle cut off!
  # put code here
  if (getprop("f22/throttle") < 0){
    setprop("f22/throttle",0);
    screen.log.write("Throttle set to Idle! Starting Engines...");    
    throttletimer.start();
    emu.manualstart();
  }
  elsif (getprop("f22/throttle") != -0.1){
    screen.log.write("Throttle Cut off! Shutting down...");
    throttletimer.stop();
    setprop("f22/throttle",-0.1);
    emu.engstop();
  }
}
setprop("f22/throttle",-0.1);
setprop("f22/currstation",0); # pointer
# Stores to string converter
var stringstore = func() {
# var weight0 = getprop("sim/weight[0]/selected");
# var weight1 = getprop("sim/weight[1]/selected");
# var weight2 = getprop("sim/weight[2]/selected");
# var weight3 = getprop("sim/weight[3]/selected");
# var weight4 = getprop("sim/weight[4]/selected");
# var weight5 = getprop("sim/weight[5]/selected");
# var weight6 = getprop("sim/weight[6]/selected");
# var weight7 = getprop("sim/weight[7]/selected");
# var weight8 = getprop("sim/weight[8]/selected");
# var weight9 = getprop("sim/weight[9]/selected");        lol
# var weight10 = getprop("sim/weight[10]/selected");
# var weight11 = getprop("sim/weight[11]/selected");
# var weight12 = getprop("sim/weight[12]/selected");
# var weight13 = getprop("sim/weight[13]/selected");
# var weight14 = getprop("sim/weight[14]/selected");
# var station0 = getprop("controls/armament/station[0]/release");
# var station1 = getprop("controls/armament/station[1]/release");
# var station2 = getprop("controls/armament/station[2]/release");
# var station3 = getprop("controls/armament/station[3]/release");
# var station4 = getprop("controls/armament/station[4]/release");
# var station5 = getprop("controls/armament/station[5]/release");
# var station6 = getprop("controls/armament/station[6]/release");
# var station7 = getprop("controls/armament/station[7]/release");
# var station8 = getprop("controls/armament/station[8]/release");
# var station9 = getprop("controls/armament/station[9]/release");
# var station10 = getprop("controls/armament/station[10]/release");
# var station11 = getprop("controls/armament/station[11]/release");
# var station12 = getprop("controls/armament/station[12]/release");
# var station13 = getprop("controls/armament/station[13]/release");
# var station14 = getprop("controls/armament/station[14]/release");
  var pointer = getprop("f22/currstation");
  var pointedweight = getprop("sim/weight[" ~ pointer ~ "]/selected");
  var pointedstation = getprop("controls/armament/station[" ~ pointer ~ "]/release");
  var thestring = "W"~ pointer ~":" ~ pointedweight ~ ":S"~ pointer ~":" ~ pointedstation;
  setprop("sim/multiplay/generic/string[5]",thestring);
  setprop("f22/currstation",getprop("f22/currstation") + 1);
  if (getprop("f22/currstation") == 15){
    setprop("f22/currstation",0); # Loop back to it
  }

}



        #
        # BEGIN maketimer(); MAYHEM!
        #
                # seconds , function.  you can use 0 for the seconds
throttletimer = maketimer(0,updatethrot);
crashreinit_timer = maketimer(5,crashreinit);
timer_hit = maketimer(1.5, mslhit);
blinktimer = maketimer(0.3, blink);
bingotimer = maketimer(0.3,checkbingo);
radcheck = maketimer(0.5, updateradarcs);
radcheck.start();
arrow = maketimer(0.1, arrowpointer);
arrow.start();
locktgt_timer = maketimer(0.1, tgtlock);
crash_timer = maketimer(0.1, crashdetect);
rebound_timer = maketimer(3, resetready);
crash_timer.start();
Flare_timer = maketimer(1.8, cha_flare);
timer_flarecheck = maketimer(2, flarecheck);  # To make the target need to keep putting out flares for the number to stay 1 and make missiles detect them
settimer(missile_sfx, 2); # runs myFunc after 2 seconds
timer_eng = maketimer(0.25, engloop);
timer_loopTimer = maketimer(0.25, timer_loop);
timer_extpylons = maketimer(0.25, checkforext);
timer_baydoorsclose = maketimer(1, closebays);
timer_damage = maketimer(0.5, damagedetect);
timer_jitter = maketimer(0.1, jitter);
timer_cursor = maketimer(0.1, cursor);
timer_cursor.start();
acmtimer = maketimer(2,radarlook);
ready_timer = maketimer(30,readyset);
headupdate = maketimer(0,updatehead); # Pilot movement

setlistener("sim/signals/fdm-initialized", func {
# Spawned in/went to location
headupdate.start();
ready_timer.start();
crash_timer.stop(); # stop crash xd
crashreinit_timer.start();
repair();
setprop("controls/gear/gear-down",1);
screen.log.write("Ready");
timer_jitter.start();  
timer_flarecheck.start();          # flare checker
timer_eng.start();          # engines
timer_loopTimer.start();    # Pullup alarm
timer_extpylons.start();    # External pylon detection
timer_damage.start();
blinktimer.start();
bingotimer.start();
});


#setlistener("controls/armament/gun-trigger", func {
#    if (getprop("ai/submodels/submodel/count") != 0) {
#      setprop("")
#    }
#});

timer_loopTimer.start();
timer_extpylons.start();
locktgt_timer.start();
Flare_timer.start();
timer_autoflare = maketimer(0.1, autoflares);


var flareswitch = 0;
var startflare = func{
  if (flareswitch == 0) {
  timer_autoflare.start();
  flareswitch = 1;
  } else {
      timer_autoflare.stop();
      flareswitch = 0;
  }
}


var getCCIP = func {
      # get loading missiles
      var msltyp = getprop("controls/armament/selected-weapon");
      missile.Loading_missile(msltyp);
      # Needed for missile.nas calculation
      if (msltyp == "JDAM") {
          # 20s fall time limit and calculate fall trajectory at every 0.20s on the way to ground.
          return missile.MISSILE.getCCIPdv(20, 0.20);
      } elsif (msltyp == "GBU-39") {
          # 35s fall time limit and calculate fall trajectory at every 0.30s on the way to ground.
          return missile.MISSILE.getCCIPdv(35, 0.30);
      }
}

var gearlighting = func(){
  if (getprop("controls/gear/gear-down") == 0) {
    setprop("controls/lighting/landing-lights",0);
    setprop("controls/lighting/taxi-light",0);
    setprop("sim/model/clicksmall",!getprop("sim/model/clicksmall"));
  }
}
setlistener("/controls/gear/gear-down",gearlighting);
# End f22.nas
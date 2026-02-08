# f22.nas | Everything Raptor needs at the call of a function
# Phoenix
# Hide the hud when not in the cockpit view
setlistener("/sim/current-view/view-number", func(n) { setprop("/sim/hud/visibility[1]", n.getValue() == 0) },1);
# Init some vars
setprop("f22/fcs/extra",0);
setprop("f22/fcs/aoalimit",90);
setprop("f22/fcs/glimit",0);
setprop("f22/fcsmode",0);
setprop("f22/mslview",0);
setprop("f22/aga",0);
setprop("f22/age",0);
setprop("f22/obogs/mixture",0);
setprop("f22/obogs/flow",0);
setprop("f22/obogs/main",0);
setprop("controls/refuel/tanks",1);
setprop("f22/auxcomm/oldd",0);
setprop("f22/bayupdate",0);
setprop("controls/baydoor/AIM120lock",0);
setprop("f22/rbleed",0.0);
setprop("f22/lbleed",0.0);
setprop("f22/quick-gear",1);
setprop("f22/gear1/pos",1);
setprop("f22/gear2/pos",1);
setprop("f22/gear3/pos",1);
setprop("f22/gear-damaged",0);
setprop("f22/gear1/failed",0);
setprop("f22/gear2/failed",0);
setprop("f22/gear3/failed",0);
setprop("fdm/jsbsim/gear/gear-pos-norm",1);
setprop("f22/frost",0);
setprop("f22/water",0);
setprop("environment/aircraft-effects/glass-temp-index",0.80);
setprop("f22/auxcomm/digit1",118);
setprop("f22/auxcomm/digit2",100);
setprop("f22/auxcomm/on",0);
setprop("f22/grind",0);
#
# Temp init 
#

setprop("environment/aircraft-effects/temperature-inside-degC", getprop("environment/temperature-degc"));
setprop("environment/aircraft-effects/dewpoint-inside-degC", getprop("environment/dewpoint-degc"));
if (getprop("environment/temperature-degc") < 0) {
 setprop("/environment/aircraft-effects/frost-exterior",1);
}
setprop("controls/ecs/airconditioning-temperature",0);
setprop("controls/ecs/mode",0);
setprop("controls/ecs/airconditioning-temperature-manual",0);
setprop("controls/ecs/windshield-hot-air-knob",0);
setprop("environment/aircraft-effects/frost-outside",0);
setprop("environment/aircraft-effects/frost-inside",0);
setprop("/environment/aircraft-effects/fog-inside", 0);
setprop("/environment/aircraft-effects/fog-outside", 0);
setprop("/environment/aircraft-effects/temperature-glass-degC", 0);
setprop("/environment/aircraft-effects/dewpoint-inside-degC", 0);
setprop("/environment/aircraft-effects/temperature-inside-degC", 0);
setprop("/environment/aircraft-effects/temperature-outside-ram-degC", 0);
setprop("/environment/aircraft-effects/frost-level", 0);
setprop("/environment/aircraft-effects/fog-level", 0);



#
# Aux Comm
#

var auxcommloop = func {
  var digit1 = getprop("f22/auxcomm/digit1"); #  123
  var digit2 = getprop("f22/auxcomm/digit2"); # .456
  var decimals = digit2 / 1000;
  var auxfreq = digit1 + decimals;
  setprop("instrumentation/comm[2]/frequencies/selected-mhz",auxfreq);
}

auxcomm = maketimer(0,auxcommloop);
auxcomm.start();


# Radio stuff

var radioloop = func {
  var batt = getprop("controls/electric/battswitch");
  var maingen = getprop("fdm/jsbsim/fcs/engine-gen-spin-output");
  if (batt == 2 and maingen == 0) {
    # comm 3 only
    setprop("instrumentation/comm[0]/operable",0);
    setprop("instrumentation/comm[1]/operable",0);
    setprop("instrumentation/comm[2]/operable",1);
    setprop("f22/auxcomm/on",1);
  }
  if (batt == 2 and maingen == 1) {
    # all
    setprop("instrumentation/comm[0]/operable",1);
    setprop("instrumentation/comm[1]/operable",1);
    setprop("instrumentation/comm[2]/operable",1);
    setprop("f22/auxcomm/on",1);
  }
  if (batt == 0 and maingen == 0) {
    setprop("instrumentation/comm[0]/operable",0);
    setprop("instrumentation/comm[1]/operable",0);
    setprop("instrumentation/comm[2]/operable",0);
    setprop("f22/auxcomm/on",0);
  }
}
radios = maketimer(0,radioloop);
radios.start();


# Custom Temperature | Pretty much all of it is based on from the F-16 code (f16.nas)



var tempmainloop = func() {
  # if (getprop("position/altitude-ft") > 10000 and getprop("controls/switches/airsource") != 3) {
  #   setprop("f22/frost",1);
  # } else {
  #   setprop("f22/frost",0);
  # }
  # setprop("environment/aircraft-effects/frost-level",getprop("fdm/jsbsim/fcs/frost"));

  var obogs = getprop("f22/obogs/main"); 
  var flow = getprop("f22/obogs/flow");
  if (obogs == 1) {
    setprop("controls/ecs/mode",1);
  } else {
    setprop("controls/ecs/mode",0);
  }
  if (flow == 1) {
    setprop("controls/ecs/windshield-hot-air-knob",1);
  } else {
    setprop("controls/ecs/windshield-hot-air-knob",0);
  }
  var arsc = getprop("controls/switches/airsource"); 
  var extdegc = getprop("environment/temperature-degc");
  var extdewc = getprop("environment/dewpoint-degc");
  var frost = getprop("environment/aircraft-effects/frost-level");
  var inttmp = getprop("environment/aircraft-effects/temperature-inside-degC");
  var intdewc = getprop("environment/aircraft-effects/dewpoint-inside-degC");
  var actmp = getprop("controls/ecs/airconditioning-temperature");
  var ecsmode = getprop("controls/ecs/mode");
  var acdew = 5.0; # Dry
  var acrun = 0;
  var elec = getprop("fdm/jsbsim/fcs/engine-gen-spin-output");

  if (arsc == 3 and elec == 1) {
    acrun = 1;
  }

  var hotairdegmin = 2.3; # Cockpit instrumentation heat
  var pilotdegmin = 0.2; #
  var glassdegminperdegdiff = 0.18;
  var acdegminperdegdiff = 0.65;
  var knob = getprop("controls/ecs/windshield-hot-air-knob");
  var hotaironwindshield = 0;

  if (elec == 1 and knob == 1) {
    hotaironwindshield = 1;
  }

  if (ecsmode == 1) {
    # automatic ac control 
    # From F-16
    if (frost > 0.8) {
        actmp += 0.70;
    } elsif (frost > 0.4) {
        actmp += 0.30;
    } elsif (frost > 0.2) {
        actmp += 0.15;
    } elsif (frost > 0.0) {
        actmp += 0.05;
    } elsif (inttmp > 21) {
        actmp -= actmp*0.1;
    } elsif (inttmp < 10) {
        actmp += 0.25;
    }
    if (actmp > 80){
      actmp = 80;
    } 
    if (actmp < -4){
      actmp = -4;
    } 
    setprop("controls/ecs/airconditioning-temperature", actmp);
  }
  # calculators
  
  # From F-16: Ram rise
  var ramrise = (getprop("fdm/jsbsim/velocities/vtrue-kts")*getprop("fdm/jsbsim/velocities/vtrue-kts"))/(87*87);#this is called the ram rise formula
  extdegc += ramrise;
  if (getprop("canopy/position-norm") > 0) {
    inttmp = getprop("environment/temperature-degc");
  } else {
    inttmp += hotaironwindshield * (hotairdegmin/(60/0.5));

    if (inttmp < 37) {
      inttmp += pilotdegmin/(60/0.5); # Pilot heat
    }

    # outside ram
    var coolfactor = ((extdegc+getprop("environment/temperature-degc"))*0.5-inttmp)*glassdegminperdegdiff/(60/0.5);# 1 degrees difference will cool/warm with 0.5 DegCelsius/min
    inttmp += coolfactor;
    if (acrun == 1) {
      inttmp += (actmp-inttmp)*acdegminperdegdiff/(60/0.5);# (tempAC-tempInside) = degs/mins it should change
    }
  }
  var tempIndex = getprop("environment/aircraft-effects/glass-temp-index");
  var tempGlass = tempIndex * (inttmp - extdegc) + extdegc;

  # dew int
  if (getprop("canopy/position-norm") > 0) {
    # canopy is open, inside dewpoint aligns to outside dewpoint instead
    intdewc = extdewc;
  } else {
    var tempInsideDewTarget = 0;
    if (acrun == 1) {
      if ((extdegc-actmp) == 0) {
        var slope = 1; # divide by zero prevention
      } else {
        var slope = (extdewc - acdew)/(extdegc-actmp);
      }
    tempInsideDewTarget = slope*(inttmp-actmp)+acdew;

    } else {
      tempInsideDewTarget = extdewc;
    }
    if (tempInsideDewTarget > intdewc) {
      intdewc = math.clamp(intdewc + 0.15, -1000, tempInsideDewTarget);
    } else {
      intdewc = math.clamp(intdewc - 0.15, tempInsideDewTarget, 1000);
    }
  }

  var fogext = math.clamp((extdewc-tempGlass)*0.05, 0, 1);
  var fogint = math.clamp((intdewc-tempGlass)*0.05, 0, 1);
  var frostext = getprop("environment/aircraft-effects/frost-outside");
  var frostint = getprop("environment/aircraft-effects/frost-inside");
  var rain = getprop("environment/rain-norm");
  if (rain == nil) {
      rain = 0;
  }
  var frostSpeedInside = math.clamp(-tempGlass, -60, 60)/600 + (tempGlass<0?fogint/50:0);
  var frostSpeedOutside = math.clamp(-tempGlass, -60, 60)/600 + (tempGlass<0?(fogext/50 + rain/50):0);
  var maxFrost = math.clamp(1 + ((tempGlass + 5) / (0 + 5)) * (0 - 1), 0, 1);# -5 is full frost, 0 is no frost
  var maxFrostInside = math.clamp(maxFrost - math.clamp(inttmp/30,0,1), 0, 1);# frost having harder time to form while being constantly thawed.
  frostext = math.clamp(frostext + frostSpeedOutside, 0, maxFrost);
  frostint = math.clamp(frostint + frostSpeedInside, 0, maxFrostInside);
  var frostNorm = frostext>frostint?frostext:frostint;

  fogext = math.clamp(fogext-frostext / 4, 0, 1);
  fogint = math.clamp(fogint-frostint / 4, 0, 1);
  fogNorm = fogext>fogint?fogext:fogint;

  # finally: apply 
  setprop("/environment/aircraft-effects/fog-inside", fogint);
  setprop("/environment/aircraft-effects/fog-outside", fogext);
  setprop("/environment/aircraft-effects/frost-inside", frostint);
  setprop("/environment/aircraft-effects/frost-outside", frostext);
  setprop("/environment/aircraft-effects/temperature-glass-degC", tempGlass);
  setprop("/environment/aircraft-effects/dewpoint-inside-degC", intdewc);
  setprop("/environment/aircraft-effects/temperature-inside-degC", inttmp);
  setprop("/environment/aircraft-effects/temperature-outside-ram-degC", extdegc);
  # effects
  setprop("/environment/aircraft-effects/frost-level", frostNorm);
  setprop("/environment/aircraft-effects/fog-level", fogNorm);
} 


temperatureloop = maketimer(0.1,tempmainloop);
temperatureloop.start();
print("---------- Temperature loop activated ----------");



# Landing gear controller
var gearloop = func() {
  var gearhandle = getprop("controls/gear/gear-down");
  var speed = getprop("velocities/airspeed-kt");
  var damaged = getprop("f22/gear-damaged");
  var fdmgear = getprop("fdm/jsbsim/fcs/gear-control");
  var damagegear1 = getprop("f22/gear1/failed");
  var damagegear2 = getprop("f22/gear2/failed");
  var damagegear3 = getprop("f22/gear3/failed");
  if (gearhandle == 1) {
    # gear is down
    # check for damage
    if (damaged == 0) {
      if (speed > 290) {
        setprop("f22/gear-damaged",1);
        print("gear is getting damaged!!!");
        screen.log.write("The gear is getting damaged! Slow down!",1,0,0);
        # RNG
        var chance = 0.9;
        var gear1 = rand() < (1-chance);
        var gear2 = rand() < (1-chance);
        var gear3 = rand() < (1-chance);
        if (getprop("f22/gear1/failed") == 0) {
          setprop("f22/gear1/failed",gear1);
        }
        if (getprop("f22/gear2/failed") == 0) {
          setprop("f22/gear2/failed",gear2);
        }
        if (getprop("f22/gear3/failed") == 0) {
          setprop("f22/gear3/failed",gear3);
        }
        if (gear1 == 0 or gear2 == 0 or gear3 == 0) {
          # turn it back on 
          setprop("f22/gear-damaged",0);
        }
      }
    }
  }

  if (damagegear1 == 1) {
    # nose is damaged
    if (fdmgear < 0.25) {
      setprop("f22/gear1/pos",fdmgear);
    }
  } else {
    setprop("f22/gear1/pos",fdmgear);
  }
  if (damagegear2 == 1) {
    # left is damaged
    if (fdmgear < 0.75) {
      setprop("f22/gear2/pos",fdmgear);
    }
  } else {
    setprop("f22/gear2/pos",fdmgear);
  }
  if (damagegear3 == 1) {
    # left is damaged
    if (fdmgear < 0.75) {
      setprop("f22/gear3/pos",fdmgear);
    }
  } else {
    setprop("f22/gear3/pos",fdmgear);
  }
  if (damaged != 1) {
  setprop("fdm/jsbsim/gear/gear-pos-norm",fdmgear);
  } else {
    
  setprop("fdm/jsbsim/gear/gear-pos-norm",0.2);
  }
}

gearmain = maketimer(0,gearloop);

# Floats
setprop("controls/vol/rwr",0.5);
setprop("controls/lighting/consoleknob",0.1); #instruments-norm
setprop("controls/lighting/consoleknob",0); #instruments-norm
setprop("controls/lighting/mfd",0.1);
setprop("controls/lighting/mfd",0);
setprop("controls/lighting/actualform",0.1);
setprop("controls/lighting/actualform",0);
setprop("controls/lighting/instpnl",0.1);
setprop("controls/lighting/instpnl",0);
setprop("controls/lighting/flood-norm",0.1);
setprop("controls/lighting/flood-norm",0);
setprop("controls/lighting/formation-norm",0.1);
setprop("controls/lighting/formation-norm",0);
setprop("controls/lighting/extknob",0);
setprop("controls/lighting/ldg",0);
setprop("controls/hooksw",1);
setprop("controls/lighting/aar",1);
var NM2FT = 6076;
setprop("controls/switches/airsource",0);
setprop("f22/ejection/lon",0);
setprop("f22/ejection/lat",0);
setprop("f22/ejection/alt",1000);

# ground opps
setprop("f22/ground/slr-cover",0);
setprop("f22/ground/apu-cover",0);
setprop("f22/ground/intake-l",0);
setprop("f22/ground/intake-r",0);
setprop("f22/ground/pilot",1);
setprop("f22/ground/chocks",0);
setprop("f22/ground/small-ladder",0);
setprop("f22/ground/cones",0);
setprop("f22/ags",0);
leftscr.start(); # start up the leftscreen

setprop("f22/chaff",200); # counter messure ammounts
setprop("f22/flare",200); # counter messure ammounts

setprop("/f22/crash/explodesfx",0);
setprop("/f22/crash/splashsfx",0);
setprop("controls/bdl",1); # Baydoor Switches
setprop("controls/bdr",1); # Baydoor Switches
setprop("/f22/dead",0); # Crash
setprop("/f22/crash/doneonce",0);
setprop("/f22/crash/alt",0);
setprop("/f22/crash/type",0);
setprop("/controls/armament/rrdt",0); # Far Drop tanks
setprop("/controls/armament/lldt",0); # Far Drop tanks
# used to the animation of the canopy switch and the canopy move
# toggle keystroke or 2 position switch
setprop("f22/head-hdg-deg",0); # Head moving gimmick
setprop("f22/head-ptc-deg",0); # Head moving gimmick
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

var custommsg = func {
  screen.log.write("Aircraft went swimmin' with the fishies!!",1,0,0);
}


var oppfunc = func(heading) {
  if (heading != nil) {
    var opposite = 0;
    if (heading == 0) {
      opposite == 180;
    } elsif (heading > 0) {
      opposite = heading - 180;
    } else {
      opposite = heading + 180
    }
    if (opposite < 0) {
      opposite = opposite + 360;
    }
    print("oppfunc: ",opposite);
    return opposite;
  } else {
    print("oppfunc(heading) - heading cant be nil!");
    return 0;
  }
}

#setprop("/sim/multiplay/generic/bool[4]",1);
#setprop("/sim/multiplay/generic/bool[4]",0);

timer_water = maketimer(2,waterstop);
setprop("f22/runonce",0);
var kaboom = func(speed,type) {
  var onground = 1;
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
      custommsg();
      setprop("f22/water",1);
      setprop("f22/runonce",1);
    }
  }

  if (getprop("f22/water") == 0) {
    if (type != 1) {
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
    } else {
      # lightest crash. No fire, No smoke
      setprop("f22/grind",1);
      if (speed > 250 and onground == 1) {
        # grinding effects
        setprop("f22/grind",1);
      } else {
        setprop("f22/grind",0);
      }
      setprop("/sim/multiplay/generic/bool[2]",0); # Turn off fire
      setprop("/sim/multiplay/generic/bool[3]",0); # Turn off smoke
    }

  } 
  
  else {
    setprop("/sim/multiplay/generic/bool[2]",0); # Turn off fire
    setprop("/sim/multiplay/generic/bool[3]",0); # Turn off smoke
  }
  
}


var crashdetect = func {
    if (getprop("/position/altitude-agl-ft") < 0 or getprop("/f22/dead") != 0){
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

        
            if (speed < 80) {
              screen.log.write("You crashed! Light Damage",1,0,0);
              setprop("/f22/dead",1);
              setprop("/f22/crash/type",1);
              setprop("/f22/crash/doneonce",1);
            }
            # Highspeed crash
            if (speed > 80 and speed < 160) {
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
      if (type != 1) {
        setprop("/position/altitude-ft",getprop("/position/ground-elev-ft") - 3); # Hug the ground. But stay under it
      }



    }
}


# External and Internal Lighting

var navblink = func() {
  var nav = getprop("controls/lighting/nav-lights");
  setprop("controls/lighting/nav-lights",!nav);
  print("*blink*");
}
 


navblinktimer = maketimer(0.5,navblink);
setprop("controls/lighting/extlight",0);

var knobcheck = func() {
  var knob = getprop("controls/lighting/extlight");
  if (knob == 0 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # off
    setprop("controls/lighting/beacon",0);
    setprop("controls/lighting/nav-lights",0);
  } elsif (knob == 1 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # anti collison (beacon)
    setprop("controls/lighting/beacon",1);
    setprop("controls/lighting/nav-lights",0);
    navblinktimer.stop();
  } elsif (knob == 2 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # nav and anti coll
    setprop("controls/lighting/beacon",1);
    setprop("controls/lighting/nav-lights",1);
    navblinktimer.stop();
  } elsif (knob == 3 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # nav blink
    setprop("controls/lighting/beacon",0);
    navblinktimer.start();
  } elsif (knob == 4 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # nav
    navblinktimer.stop();
    setprop("controls/lighting/beacon",0);
    setprop("controls/lighting/nav-lights",1);
  }
  var ldg = getprop("controls/lighting/ldg");
  if (ldg == 0 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    # no gear light
    setprop("controls/lighting/taxi-light",0);
    setprop("controls/lighting/landing-lights",0);
  }
  if (ldg == -1 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    setprop("controls/lighting/taxi-light",1);
    setprop("controls/lighting/landing-lights",1);
  }
  if (ldg == 1 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    setprop("controls/lighting/taxi-light",1);
    setprop("controls/lighting/landing-lights",0);
  }
  if (getprop("f22/throttler") > 0.3 and getprop("controls/gear/brake-parking") == 1) {
    setprop("controls/gear/brake-parking",0);
  }
  if (getprop("controls/hooksw") == 1 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    setprop("fdm/jsbsim/systems/hook/tailhook-cmd-norm",0);
  }
  if (getprop("controls/hooksw") == 0 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 1) {
    setprop("fdm/jsbsim/systems/hook/tailhook-cmd-norm",1);
  }
  if (getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 0) {
    # your cooked at night bro :skull:
    setprop("controls/lighting/taxi-light",0);
    setprop("controls/lighting/landing-lights",0);
    navblinktimer.stop();
    setprop("controls/lighting/beacon",0);
    setprop("controls/lighting/nav-lights",0);
    setprop("controls/lighting/actualform",0.0);
  }
}


var fastknobcheck = func() {
  var power = getprop("fdm/jsbsim/fcs/engine-gen-spin-output");
  var consoleknob = getprop("controls/lighting/consoleknob");
  var form = getprop("controls/lighting/formation-norm");
  var flood = getprop("controls/lighting/flood-norm");
  if (power == 1) {
    setprop("controls/lighting/instruments-norm",consoleknob);
    setprop("controls/lighting/actualform",form);
    setprop("controls/lighting/actualflood",flood);
  } else {
    setprop("controls/lighting/instruments-norm",0);
    setprop("controls/lighting/actualform",0);
    setprop("controls/lighting/actualflood",0);
  }
}

#
# APU Startup Sequencing
#

# play sound
# first open flaps
setprop("controls/apu/run",0);
var apuseq1 = func() {
  # APU Animation/sequence!
  # make sure the cover is not on
  if (getprop("f22/ground/apu-cover") == 1) {
    screen.log.write("WARNING! Cant start APU with APU cover attached!",1,0,0);
  } elsif (getprop("systems/electrical/serviceable") == 0) {
    screen.log.write("APU Failure! No serviceable electrical power source to spool up APU!",1,0,0);
  } else {
    setprop("controls/apu/start",1);
    setprop("controls/apu/flap",1);
    seq2timer.start();
  }
}

var apuseq2 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/start",1);
  seq2timer.stop();
  seq3timer.start();
}

var apuseq3 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/smokespeed",10);
  setprop("controls/apu/smoke",1);
  seq3timer.stop();
  seq4timer.start();
}

var apuseq4 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/smoke",0);
  setprop("controls/apu/apuflame",1);
  seq4timer.stop();
  seq5timer.start();
}

var apuseq5 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/smoke",1);
  setprop("controls/apu/apuflame",0);
  setprop("controls/apu/smoke",0);
  seq5timer.stop();
  seq6timer.start();
}

var apuseq6 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/smoke",1);
  seq6timer.stop();
  seq7timer.start();
}
var apuseq7 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/smoke",0);
  seq7timer.stop();
  seq8timer.start();
}
var apuseq8 = func() {
  # APU Animation/sequence!
  setprop("controls/apu/run",1);
  setprop("controls/electric/apustart",0); # Return to run
  setprop("controls/electric/apustartpos",0); # Return to run
  setprop("controls/apu/start",0);
  #apuon();
  seq8timer.stop();
  #seq8timer.start();
}

var apushutoffmain = func() {
  # APU Animation/sequence!
  setprop("controls/apu/startinprogress",0);
  setprop("controls/apu/run",0);

  setprop("controls/apu/spooldown",1);
  offtimer.start();
  #seq8timer.start();
}

var apushutoff = func() {
  # APU Animation/sequence!
  setprop("controls/apu/spooldown",2); # Stop the sound
  setprop("controls/apu/flap",0); # Close the flaps
  offtimer.stop();
  #seq8timer.start();
}

# APU Timers

seq2timer = maketimer(0.3,apuseq2);
seq3timer = maketimer(0.4,apuseq3);
seq4timer = maketimer(0.5,apuseq4);
seq5timer = maketimer(0.5,apuseq5);
seq6timer = maketimer(2,apuseq6);
seq7timer = maketimer(0.5,apuseq7);
seq8timer = maketimer(10,apuseq8);
offtimer = maketimer(16,apushutoff);
#apudoortimer = maketimer(, apuseq1);

setprop("controls/apu/startinprogress",0);


# Electric system for the engines and the APU:

# Detect the status of the main power switch. then check if the engines are dead. 
# if all's good. start the engines
# Controls the battery switch, APU, and Engine start switches and there effectiveness (If they work or not)

var engloop = func{
var messycodeplacement = 1;
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
            }

            if(getprop("/engines/engine[1]/n1") < 28) {
              setprop("/controls/engines/engine[1]/starter",getprop("controls/electric/engine/start-l"));
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
    if (getprop("f22/shaking") == 1) {
		setprop("controls/cabin/shaking", math.sin(48 * myTime) / 222.222);
    }
	}
	else {
		setprop("controls/cabin/shaking", 0);
	}
}# from m2005



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
    if (getprop("f22/shaking") == 1) {
		  setprop("controls/cabin/shaking2", math.sin(48 * myTime) / 10.999);
    }
	}
	else {
		setprop("controls/cabin/shaking2", 0);
	}
}# from m2005


var bayupdate = func () {
  var aim9 = getprop("fdm/jsbsim/fcs/AIM9X");
  var aim120 = getprop("fdm/jsbsim/fcs/AIM120");
  if (aim9 == 0 or aim120 == 1) {
    setprop("f22/bayupdate",1);
  } else {
    setprop("f22/bayupdate",0);
  }
}




bayloop = maketimer(0,bayupdate);
bayloop.start();


var firemsluntill = func () {
    mslbaytimer.start();
}


var firemslbay = func () {
    if (getprop("f22/bayupdate") == 1) {
                      
      m2000_load.SelectNextPylon();
      var missile = getprop("controls/missile");
      setprop("controls/missile", !missile);
      var pylon = getprop("/controls/armament/missile/current-pylon");
      m2000_load.dropLoad(pylon);
      print("Should fire Missile");
      setprop("/controls/armament/missile-trigger", 1);
      print("f22.nas: in firemslbay() - Missile away!");
      mslbaytimer.stop();
    }
  print("f22.nas: in firemslbay() - Waiting for bays...");
}
mslbaytimer = maketimer(0,firemslbay);


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
  } elsif (weapon == 3) {
# gbu
            if(time - dt > 1)
            {
                dt = time;
	            	setprop("/controls/baydoors/AIM120", 1);
                print("bay doors open");
                timer_baydoorsclose.start();
            }
  } elsif (weapon == 4) {
# jdam
            if(time - dt > 1)
            {
                dt = time;
	            	setprop("/controls/baydoors/AIM120", 1);
                print("bay doors open");
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


setprop("/controls/baydoors/AIM9Xlock", 0);


var closebays = func{
  if (getprop("controls/baydoors/AIM120lock") == 0) {
	            	setprop("/controls/baydoors/AIM120", 0);
  }
                if (getprop("instrumentation/radar/lock") == 0) {
                  if (getprop("controls/baydoors/AIM9Xlock") == 0) {
 setprop("/controls/baydoors/AIM9X", 1);  # animations are inverted: todo fix the bay door animations
                  }
                 
                }
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


# INIT radar2.nas | APG-77
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



var rightaim120 = func() {
  setprop("sim/weight[4]/selected","Aim-120");
  setprop("/controls/armament/station[4]/release","false");
  setprop("sim/weight[17]/selected","Aim-120");
  setprop("/controls/armament/station[17]/release","false");
  screen.log.write("Added 2 External Aim-120's");
}

var rightaim9x = func() {
  setprop("sim/weight[4]/selected","Aim-9x");
  setprop("/controls/armament/station[4]/release","false");
  setprop("sim/weight[17]/selected","Aim-9x");
  setprop("/controls/armament/station[17]/release","false");
  screen.log.write("Added 2 External Aim-9X's");
}

var leftaim120 = func() {
  setprop("sim/weight[2]/selected","Aim-120");
  setprop("/controls/armament/station[2]/release","false");
  setprop("sim/weight[20]/selected","Aim-120");
  setprop("/controls/armament/station[20]/release","false");
  screen.log.write("Added 2 External Aim-120's");
}

var leftaim9x = func() {
  setprop("sim/weight[2]/selected","Aim-9x");
  setprop("/controls/armament/station[2]/release","false");
  setprop("sim/weight[20]/selected","Aim-9x");
  setprop("/controls/armament/station[20]/release","false");
  screen.log.write("Added 2 External Aim-9X's");
}

var removeright = func() {
  setprop("sim/weight[4]/selected","None");
  setprop("/controls/armament/station[4]/release","false");
  setprop("sim/weight[17]/selected","None");
  setprop("/controls/armament/station[17]/release","false");
  screen.log.write("Removed right external weapons");
}

var removeleft = func() {
  setprop("sim/weight[2]/selected","None");
  setprop("/controls/armament/station[2]/release","false");
  setprop("sim/weight[20]/selected","None");
  setprop("/controls/armament/station[20]/release","false");
  screen.log.write("Removed left external weapons");
}





var addrighttank = func() {
  var rightdrop = getprop("controls/armament/rdt");
  var farrightdrop = getprop("controls/armament/rrdt");
  if (rightdrop == 0 and farrightdrop == 0) {
    screen.log.write("Right drop tank added. Click again to add second right tank");
    setprop("controls/armament/rdt",1);
  } elsif (rightdrop == 1 and farrightdrop == 0) {
    screen.log.write("All right droptanks added");
    setprop("controls/armament/rrdt",1);
  } elsif (rightdrop ==1 and farrightdrop == 1) {
    screen.log.write("Cant add anymore right drop tanks! To remove them: Click remove tank");
  }
}

var addlefttank = func() {
  var rightdrop = getprop("controls/armament/ldt");
  var farrightdrop = getprop("controls/armament/lldt");
  if (rightdrop == 0 and farrightdrop == 0) {
    screen.log.write("Left drop tank added. Click again to add second left tank");
    setprop("controls/armament/ldt",1);
  } elsif (rightdrop == 1 and farrightdrop == 0) {
    screen.log.write("All left droptanks added");
    setprop("controls/armament/lldt",1);
  } elsif (rightdrop ==1 and farrightdrop == 1) {
    screen.log.write("Cant add anymore left drop tanks! To remove them: Click remove tank");
  }
}

var removerighttank = func() {
  setprop("consumables/fuel/tank[10]/level-lbs",0);
  setprop("consumables/fuel/tank[12]/level-lbs",0);
  setprop("controls/armament/rdt",0);
  setprop("controls/armament/rrdt",0);
  screen.log.write("All right drop tanks removed");
}

var removelefttank = func() {
  setprop("consumables/fuel/tank[9]/level-lbs",0);
  setprop("consumables/fuel/tank[11]/level-lbs",0);
  setprop("controls/armament/ldt",0);
  setprop("controls/armament/lldt",0);
  screen.log.write("All left drop tanks removed");
}

var checkforext = func {
  # Check for external pylons and Mount them when armament is loaded
  # Also check for fuel in the EXT tanks if there are no EXT tanks mounted. then remove the extra fuel and show a message
  var leftdrop = getprop("controls/armament/ldt");
  var farleftdrop = getprop("controls/armament/lldt");
  var rightdrop = getprop("controls/armament/rdt");
  var farrightdrop = getprop("controls/armament/rrdt");
	var pylon3 = getprop("sim/weight[2]/selected");
  var pylon5 = getprop("sim/weight[4]/selected");
  var fuelleft = getprop("consumables/fuel/tank[9]/level-lbs");
  var fuelright = getprop("consumables/fuel/tank[10]/level-lbs");
  var fuelfarleft = getprop("consumables/fuel/tank[11]/level-lbs");
  var fuelfarright = getprop("consumables/fuel/tank[12]/level-lbs");
	if ( pylon3 == "Aim-120" or pylon3 == "Aim-9x" or pylon3 == "Aim-7" or pylon3 == "Aim-9m" or pylon5 == "Aim-120" or pylon5 == "Aim-9x" or pylon5 == "Aim-7" or pylon5 == "Aim-9m" or rightdrop == 1 or leftdrop == 1 or farrightdrop == 1 or farleftdrop == 1) {
		setprop("controls/armament/extpylons", 1);
	} else {
		setprop("controls/armament/extpylons", 0);
  }

  # only allow fuel entering EXT Tanks if the left and right tanks are filled
  if (leftdrop != 1 or rightdrop != 1) {
    setprop("consumables/fuel/tank[9]/level-lbs",0);
    setprop("consumables/fuel/tank[10]/level-lbs",0);
		setprop("consumables/fuel/tank[9]/selected", 0);
		setprop("consumables/fuel/tank[10]/selected", 0);
    if (fuelright > 0 or fuelleft > 0) {
      screen.log.write("There are no drop tanks attached for these inboard tanks. See Pylons loads to attach them");
    }
  } else {
    setprop("consumables/fuel/tank[9]/selected", 1);
		setprop("consumables/fuel/tank[10]/selected", 1);
  }
  if (farrightdrop != 1 or farleftdrop != 1) {
    setprop("consumables/fuel/tank[11]/level-lbs",0);
    setprop("consumables/fuel/tank[12]/level-lbs",0);
		setprop("consumables/fuel/tank[11]/selected", 0);
		setprop("consumables/fuel/tank[12]/selected", 0);
    if (fuelfarright > 0 or fuelfarleft > 0) {
      screen.log.write("There are no drop tanks attached for these outboard tanks. See Pylons loads to attach them");
    }
  } else {
    setprop("consumables/fuel/tank[11]/selected", 1);
		setprop("consumables/fuel/tank[12]/selected", 1);
  }
}



var jettdroptanks = func {
  screen.log.write("JETT: Drop tanks");
  setprop("controls/armament/ldt",0);
  setprop("controls/armament/rdt",0);
  setprop("controls/armament/lldt",0);
  setprop("controls/armament/rrdt",0);
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
  view.setViewByIndex(0);
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
  setprop("f22/canopy-jett",0);
  guns.reload();

}



#eject

#    
var shooteject = func {
  setprop("/controls/armament/selected-weapon", "eject");
  setprop("/sim/weight[9]/selected", "eject");
  setprop("/controls/armament/station[9]/release", 0);
  m2000_load.SelectNextPylon();
  var pylon = getprop("/controls/armament/missile/current-pylon");
  m2000_load.dropLoad(pylon);
  print("Should eject!");
  setprop("/sim/weight[9]/selected", "none");
}

var eject = func{
#    if (getprop("f22/ejected")==1 or !getprop("controls/seat/ejection-safety-lever")) {
#      print("Cant eject!");
#        return;
#    }
    # ACES II activation
    if (getprop("f22/ejected") != 0) {
      return 1;
    }
    print("Eject Phase one starting");
    screen.log.write("Canopy Jettisoned");
    setprop("f22/ejected",1); # hide canopy
    setprop("f22/canopy-jett",1);
    setprop("f22/ejection/lat",getprop("position/latitude-deg"));
    setprop("f22/ejection/lon",getprop("position/longitude-deg"));
    setprop("f22/ejection/alt",getprop("position/altitude-ft"));

    
    setprop("/controls/engines/engine/cutoff",1); # Engines Off
    setprop("/controls/engines/engine[1]/cutoff",1); 
    settimer(shooteject, 0.1);
    settimer(eject2, 0.3);# this is to give the sim time to load the exterior view, so there is no stutter while seat fires and it gets stuck.
    damage.damageLog.push("Pilot ejected!");
    print("Phase 1 done!")
}

var eject2 = func{
  setprop("f22/ejected",2);
  setprop("/controls/flight/speedbrake",1);
  setprop("/sim/messages/atc", "Ejecting!");
  if (getprop("sim/current-view/view-number-raw") == 0) {
    view.setViewByIndex(105); # Go to Ejection view when only in cockpit
  }
  screen.log.write("Press v (and shift-v) to change Missile Camera views, 1st Person, 3rd Person");
   # viewMissile.view_firing_missile(es);
    #setprop("sim/view[0]/enabled",0); #disabled since it might get saved so user gets no pilotview in next aircraft he flies in.
#    settimer(func {crash.eject();},3.5);  turn off the jet if its still alive
}





var damagedetect = func{
var a = getprop("/sim/failure-manager/controls/flight/aileron/serviceable");
var b = getprop("/sim/failure-manager/controls/flight/elevator/serviceable");
var c = getprop("/sim/failure-manager/controls/flight/rudder/serviceable");
	if ( a == 0 and b == 0 and c == 0) {
    setprop("sim/multiplay/generic/bool[1]",1);
  } else{
    setprop("sim/multiplay/generic/bool[1]",0);
  }
}


# Cool Radar Stuff!
# Stuff like radar cursor position to callsign
# Dogfight mode! (ACM Radar mode)

# Spam the radar untill we locked
var lockuntill = func(callsign) {
  print("Locking untill ",callsign);
  if (callsign == nil or callsign == "") {
    return 0;
  } else {
    var currentradarcallsign = radar.tgts_list[radar.Target_Index].Callsign.getValue();
    if (currentradarcallsign != callsign) {
      radar.next_Target_Index(1,0);
    } else {
      # there the same!
      screen.log.write("Radar: Cursor Selected "~radar.tgts_list[radar.Target_Index].Callsign.getValue(),1,1,0);
      setprop("instrumentation/radar/lock",1);
    }
  }
}


# Trying to make a radar cursor simulation. 
# Had an idea if the cursor position matched the position of the marker. 
# The FDM will be used to scale the cursor position to match marker position
# Find and lock the target we selected with the cursor. 
# Need more ideas to get this to work
setprop("controls/radar/cursorvariaton",0.23);
var cursorclick = func() {
  var lockablecallsigns = "";
  var xpos = getprop("controls/radar/cursorx");
  var zpos = getprop("controls/radar/cursorz");
  var radx = getprop("fdm/jsbsim/fcs/radx");
  var radz = getprop("fdm/jsbsim/fcs/radz");
  # scan loop
  var list = props.globals.getNode("/instrumentation/radar2/marker").getChildren("mark");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
      # were searching for someone...
      var callsign = getprop("instrumentation/radar2/marker/mark[" ~ i ~ "]/callsign");
      var display = getprop("instrumentation/radar2/marker/mark[" ~ i ~ "]/display");
      var xmark = getprop("instrumentation/radar2/marker/mark[" ~ i ~ "]/location-x");
      var zmark = getprop("instrumentation/radar2/marker/mark[" ~ i ~ "]/range");
      if (xmark != nil and zmark != nil and callsign != nil and display != nil) {
      if (display == 1) {
        print("rad cursor checking: ",callsign);
        print("radx: ",radx);
        print("radz: ",radz);
        var xmarkround = math.round(xmark,0.01);
        var zmarkround = math.round(zmark,0.01);
        print("xmarkround: ",xmarkround);
        print("zmarkround: ",zmarkround);
        var variation = getprop("controls/radar/cursorvariaton");
        # check the x
        var radxpls = radx + variation;
        var radxmin = radx - variation;
        var radzpls = radz + variation;
        var radzmin = radz - variation;
        var xcheck = 0;
        var zcheck = 0;
        if (radxpls > xmarkround and radxmin < xmarkround) {
          print("RadX Checks out for: ",callsign);
          var xcheck = 1;
        }
        if (radzpls > zmarkround and radzmin < zmarkround) {
          print("RadZ Checks out for: ",callsign);
          var zcheck = 1;
        }
        if (xcheck == 1 and zcheck == 1) {
          if (lockablecallsigns == "") {
            lockablecallsigns = callsign;
          } else {
            lockablecallsigns = "" ~ lockablecallsigns ~ "|" ~ callsign ~ "";
          }

        }
      
      }
    }
}
setprop("controls/radar/cursormode",1);
print("cursorclick complete");
print("lockablecallsigns: ",lockablecallsigns);
var callsignsize = utf8.size(lockablecallsigns);
if (callsignsize > 7 and lockablecallsigns != "") {
  # Not a callsign
  screen.log.write("Cant have more than 1 target under cursor!");
  screen.log.write(lockablecallsigns);
} else {
  lockuntill(lockablecallsigns);
}

}


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
      if (getprop("instrumentation/radar/range") == 5){
      setprop("instrumentation/radar2/marker/mark[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") * 2);
      }
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
    }  
    if(getprop("instrumentation/radar/mode/main") == 1)
    {   # RWS
        setprop("instrumentation/radar/az-field", 120);
        setprop("instrumentation/radar2/sweep-display-width", 0.0846);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
    }
    elsif(getprop("instrumentation/radar/mode/main") == 0)
    {
        # TWS
        setprop("instrumentation/radar/az-field", 60);
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
    }
    elsif(getprop("instrumentation/radar/mode/main") == 2)
    {
        setprop("instrumentation/radar/az-field", 60);
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
    }
  }
}

# antic
var checkdmg = func() {
  if (getprop("f22/auxcomm/oldd") == 1) {
    if (getprop("payload/armament/msg") != getprop("f22/auxcomm/oldd")) {
      # turnd off inflight
      thestring = "I"~" tur"~"ned"~" dam"~"age"~" off"~" mid"~"flight";
      setprop("sim/multiplay/chat",thestring);
      setprop("payload/armament/msg",1);
    }
  }
  if (getprop("f22/auxcomm/oldd") == 0) {
    if (getprop("payload/armament/msg") != getprop("f22/auxcomm/oldd")) {
      # turnd off inflight
      thestring = "I"~" tur"~"ned"~" dam"~"age"~" on"~" mid"~"flight";
      setprop("sim/multiplay/chat",thestring);
      setprop("payload/armament/msg",1);
      setprop("f22/auxcomm/oldd",1);
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
  print("ACM Dogfight mode Debug!");
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
          #screen.log.write("Radar ACM: Can lock! Locking...");
          #screen.log.write(callsign);
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
  #screen.log.write("acm dbug: in here now");
  #screen.log.write("total:" ~ total);
  #screen.log.write("radarcs:" ~ radarcs);
  #screen.log.write("mpid:" ~ mpid);
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

setprop("controls/cursorscreen",0);
# Radar Cursor
setprop("controls/radar/cursorx",0);
setprop("controls/radar/cursorz",0);
setprop("controls/PRF/cursorx",0);
setprop("controls/PRF/cursorz",0);
var cursor = func {
  # Check status of x and z (x and y)
  if (getprop("controls/cursorscreen") == 0) {
    if (getprop("controls/radar/cursor-x") == 1) {
      setprop("controls/radar/cursorx", getprop("controls/radar/cursorx") + 0.0008);
    }
    if (getprop("controls/radar/cursor-x") == -1) {
      setprop("controls/radar/cursorx", getprop("controls/radar/cursorx") - 0.0008);
    }
    if (getprop("controls/radar/cursor-z") == 1) {
      setprop("controls/radar/cursorz", getprop("controls/radar/cursorz") - 0.0008);
    }
    if (getprop("controls/radar/cursor-z") == -1) {
      setprop("controls/radar/cursorz", getprop("controls/radar/cursorz") + 0.0008);
    }
  } else {
    if (getprop("controls/radar/cursor-x") == 1) {
      setprop("controls/PRF/cursorx", getprop("controls/PRF/cursorx") + 0.0008);
    }
    if (getprop("controls/radar/cursor-x") == -1) {
      setprop("controls/PRF/cursorx", getprop("controls/PRF/cursorx") - 0.0008);
      if (getprop("controls/PRF/cursorx") > 0.2) {
        setprop("controls/PRF/cursorx", 0);
      }
      if (getprop("controls/PRF/cursorx") < -0.2) {
        setprop("controls/PRF/cursorx", 0);
      }
    }
    if (getprop("controls/radar/cursor-z") == 1) {
      setprop("controls/PRF/cursorz", getprop("controls/PRF/cursorz") - 0.0008);
    }
    if (getprop("controls/radar/cursor-z") == -1) {
      setprop("controls/PRF/cursorz", getprop("controls/PRF/cursorz") + 0.0008);
    }
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
  print("f22.nas: Radar LOCKED!");
  var callsign = radar.tgts_list[radar.Target_Index].Callsign.getValue();
  var mpid = misc.smallsearch(callsign);
  var lockedalt = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/position/altitude-ft");
  var lockedrng = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm");
  setprop("controls/radar/lockedalt",lockedalt);
  setprop("controls/radar/lockedrange",lockedrng);
  setprop("controls/radar/lockedcallsign", radar.tgts_list[radar.Target_Index].Callsign.getValue());
  } else {
  # Not locked on
  #print("aw not locked");
  setprop("controls/radar/lockedcallsign", "None");
  }
}


  setprop("controls/radar/lockedcallsign", "None");





var crashreinit = func {
  crash_timer.start();
  crashreinit_timer.stop();
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
  setprop("f22/throttler",-0.1);
  setprop("f22/throttlel",-0.1);
var updatethrotr = func() {
  setprop("f22/throttler",getprop("controls/engines/engine[1]/throttle"));
}
var updatethrotl = func() {
  setprop("f22/throttlel",getprop("controls/engines/engine/throttle"));
}

var throtr = func() {
  # throttler cut off!
  # put code here
  if (getprop("f22/throttler") < 0){
    if (getprop("controls/apu/run") == 0 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 0){ # if apu off and second engine off. dont start
      screen.log.write("The APU or 1 engine must be running in order to start.",1,0,0);
      return 0;
    }
    setprop("f22/throttler",0);
    screen.log.write("Right Throttle set to Idle! Starting Right Engine...");    
    throttlertimer.start();
    emu.manualstartr();
  emu.timer_apucheck2.start(); # APU Shutoff rebound
  }
  elsif (getprop("f22/throttler") != -0.1){
    screen.log.write("Right Throttle Cut Off! Shutting down Right Engine...");
    throttlertimer.stop();
    setprop("f22/throttler",-0.1);
    emu.engstopr();
  emu.timer_apucheck2.stop(); # Ok dont turn off apu xd
  }
}

var throtl = func() {
  # throttlel cut off!
  # put code here
  if (getprop("f22/throttlel") < 0){
    if (getprop("controls/apu/run") == 0 and getprop("fdm/jsbsim/fcs/engine-gen-spin-output") == 0){ # if apu off and second engine off. dont start
      screen.log.write("The APU or 1 engine must be running in order to start.",1,0,0);
      return 0;
    }
    setprop("f22/throttlel",0);
    screen.log.write("Left Throttle set to Idle! Starting Left Engine...");    
    throttleltimer.start();
    emu.manualstartl();
  emu.timer_apucheck2.start(); # APU Shutoff rebound
  }
  elsif (getprop("f22/throttlel") != -0.1){
    screen.log.write("Left Throttle Cut Off! Shutting down Left Engine...");
    throttleltimer.stop();
    setprop("f22/throttlel",-0.1);
    emu.engstopl();
  emu.timer_apucheck2.stop(); # Ok dont turn off apu xd
  }
}

var sightradarupdate = func {
      if (radar.tgts_list == nil) {
        return;
      }
      var rdrcs = radar.tgts_list[radar.Target_Index].Callsign.getValue();
      if (rdrcs != nil) {
#print(rdrcs);
  var mpid = misc.smallsearch(rdrcs);
  var distance = getprop("ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm");
  var distanceft = distance * NM2FT;
  #print(distance);
  #print(distanceft);
  if (distanceft > 2400) {
    var test = 0;
  } else {
    var test = 1;
    if (distanceft > 700) {
      setprop("controls/armament/gunsight/range", distanceft);
    }
  }
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
# var weight9 = getprop("sim/weight[9]/selected");        lets just make it into a loop...
# var weight10 = getprop("sim/weight[10]/selected");
# var weight11 = getprop("sim/weight[11]/selected");
# var weight12 = getprop("sim/weight[12]/selected");
# var weight13 = getprop("sim/weight[13]/selected");
# var weight14 = getprop("sim/weight[14]/selected");
# var station0 = getprop("controls/armament/station[0]/release");
# var station1 = getprop("controls/armament/station[1]/release");
# var station2 = getprop("controls/armament/station[2]/release");
# var station3 = getprop("controls/armament/station[3]/release");  This is chaos... lmfao
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
  var thestring = ""~ pointer ~":" ~ pointedweight ~ ":"~ pointer ~":" ~ pointedstation;
  setprop("sim/multiplay/generic/string[5]",thestring);
  setprop("f22/currstation",getprop("f22/currstation") + 1);
  if (getprop("f22/currstation") == 20){
    setprop("f22/currstation",0); # Loop back to the first station
  }




}


var gunsightupdate = func() {

    if (getprop("instrumentation/radar/lock2") == 0){
      setprop("controls/armament/gunsight/range",2400);
    }
    if (getprop("controls/armament/gunsight/sightmode") == 0) { # OFF
      setprop("controls/armament/gunsight/computer-on", 0);
      setprop("controls/armament/gunsight/power-on", 0);
      setprop("controls/armament/gunsight/mask-off", 1); 
      setprop("controls/armament/gunsight/azimuth2",0);
      setprop("controls/armament/gunsight/elevation2",0);
    }

    if (getprop("controls/armament/gunsight/sightmode") == 2) { # A/A
      setprop("controls/armament/gunsight/computer-on", 1);
      setprop("controls/armament/gunsight/power-on", 1);
      setprop("controls/armament/gunsight/rocketLadder", 0);
      setprop("controls/armament/gunsight/mask-off", 1);
      setprop("controls/armament/gunsight/reticleSelectorPos", 2);
      setprop("controls/armament/gunsight/fixedrectical", 1);
      setprop("controls/armament/gunsight/azimuth2",getprop("controls/armament/gunsight/azimuth"));
      setprop("controls/armament/gunsight/elevation2",getprop("controls/armament/gunsight/elevation"));
    }
    if (getprop("controls/armament/gunsight/sightmode") == 3) { # A/G
      setprop("controls/armament/gunsight/computer-on", 1);
      setprop("controls/armament/gunsight/power-on", 1);
      setprop("controls/armament/gunsight/rocketLadder", 0);
      setprop("controls/armament/gunsight/mask-off", 1);
      setprop("controls/armament/gunsight/reticleSelectorPos", 2);
      setprop("controls/armament/gunsight/azimuth2",getprop("controls/armament/gunsight/azimuth") + getprop("f22/aga"));
      setprop("controls/armament/gunsight/elevation2",getprop("controls/armament/gunsight/elevation") + getprop("f22/age"));
    }
    if (getprop("controls/armament/gunsight/sightmode") == 4) { # AG
      setprop("controls/armament/gunsight/computer-on", 0);
      setprop("controls/armament/gunsight/power-on", 1);
      setprop("controls/armament/gunsight/mask-off", 1);
      setprop("controls/armament/gunsight/reticleSelectorPos", 0);
    }


  # Check gunsights too
  if (getprop("controls/armament/stick-selector") == 1 and getprop("controls/armament/master-arm") == 1) {
    # guns on
    if (getprop("f22/ags") == 1){
      setprop("controls/armament/gunsight/sightmode",3);
    } else {
      setprop("controls/armament/gunsight/sightmode",2);
    }

    sightradarupdate();
  } else {
        setprop("controls/armament/gunsight/sightmode",0);
  }
}


var consoleslight = func() {
  var elec = getprop("fdm/jsbsim/fcs/engine-gen-spin-output");
  if (elec == 0) {
    setprop("controls/lighting/instruments-norm",0); # no power? no light
  }
}

var engint = func() {
  if (getprop("sim/failure-manager/engines/engine/serviceable") == 0 or getprop("sim/failure-manager/engines/engine[1]/serviceable") == 0) {
    if (getprop("sim/failure-manager/engines/engine/serviceable") == 0 and getprop("sim/failure-manager/engines/engine[1]/serviceable") == 0) {
      setprop("f22/engint",3);
    } elsif (getprop("sim/failure-manager/engines/engine/serviceable") == 0 and getprop("sim/failure-manager/engines/engine[1]/serviceable") == 1) {
      # left dead
      setprop("f22/engint",1);
    } elsif (getprop("sim/failure-manager/engines/engine/serviceable") == 1 and getprop("sim/failure-manager/engines/engine[1]/serviceable") == 0) {
      # right dead
      setprop("f22/engint",2);
    }
  } else {
    setprop("f22/engint",0); # engines work
  }
}


#
# BEGIN maketimer(); MAYHEM!
#
# seconds , function.  you can use 0 for the seconds
var hudupdate = func() {
  setprop("sim/hud/color/alpha",getprop("f22/brightness"));
  setprop("sim/hud/color/brightness",getprop("f22/brightness"));
}

var tankselector = func() {
  var switch = getprop("controls/refuel/tanks");
  if (switch == 0) {
    # only ext's
    setprop("consumables/fuel/tank[0]/refuelselect",0);
    setprop("consumables/fuel/tank[1]/refuelselect",0);
    setprop("consumables/fuel/tank[2]/refuelselect",0);
    setprop("consumables/fuel/tank[3]/refuelselect",0);
    setprop("consumables/fuel/tank[4]/refuelselect",0);
    setprop("consumables/fuel/tank[5]/refuelselect",0);
    setprop("consumables/fuel/tank[6]/refuelselect",0);
    setprop("consumables/fuel/tank[7]/refuelselect",0);
    setprop("consumables/fuel/tank[8]/refuelselect",0);
    
    setprop("consumables/fuel/tank[9]/refuelselect",1);
    setprop("consumables/fuel/tank[10]/refuelselect",1);
    setprop("consumables/fuel/tank[11]/refuelselect",1);
    setprop("consumables/fuel/tank[12]/refuelselect",1);
  } else {
    # enable main tanks
    setprop("consumables/fuel/tank[0]/refuelselect",1);
    setprop("consumables/fuel/tank[1]/refuelselect",1);
    setprop("consumables/fuel/tank[2]/refuelselect",1);
    setprop("consumables/fuel/tank[3]/refuelselect",1);
    setprop("consumables/fuel/tank[4]/refuelselect",1);
    setprop("consumables/fuel/tank[5]/refuelselect",1);
    setprop("consumables/fuel/tank[6]/refuelselect",1);
    setprop("consumables/fuel/tank[7]/refuelselect",1);
    setprop("consumables/fuel/tank[8]/refuelselect",1);

    setprop("consumables/fuel/tank[9]/refuelselect",0);
    setprop("consumables/fuel/tank[10]/refuelselect",0);
    setprop("consumables/fuel/tank[11]/refuelselect",0);
    setprop("consumables/fuel/tank[12]/refuelselect",0);
  }
}


updatehudtimer = maketimer(0.1,hudupdate);
updatehudtimer.start();
engsmoke = maketimer(0.1,engint);
engsmoke.start();

extlightknobtimer = maketimer(0.2,knobcheck);
extlightknobtimer.start();
fastextlightknobtimer = maketimer(0,fastknobcheck);
fastextlightknobtimer.start();
tankselectortimer = maketimer (0.5,tankselector);
tankselectortimer.start();

guntimer = maketimer(0.1,gunsightupdate);
guntimer.start();
loadtimer = maketimer(1.5,stringstore);
loadtimer.start();
throttlertimer = maketimer(0,updatethrotr);
throttleltimer = maketimer(0,updatethrotl);
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
crash_timer.start();
Flare_timer = maketimer(1.8, cha_flare);
timer_flarecheck = maketimer(2, flarecheck);  # To make the target need to keep putting out flares for the number to stay 1 and make missiles detect them
settimer(missile_sfx, 2); 
timer_eng = maketimer(0.25, engloop);
timer_loopTimer = maketimer(0.25, timer_loop);
timer_extpylons = maketimer(0.25, checkforext);
timer_baydoorsclose = maketimer(1, closebays);
timer_damage = maketimer(0.5, damagedetect);
timer_jitter = maketimer(0.1, jitter);
timer_cursor = maketimer(0, cursor);
timer_cursor.start();
acmtimer = maketimer(2,radarlook);
headupdate = maketimer(0,updatehead); # Pilot movement
consoletimer = maketimer(0,consoleslight);

# Shake
shake_timer = maketimer(0.0001, shake);
shake_timer2 = maketimer(0.0001, shake2);
var tutmessage = func() {
  #setprop("sim/messages/atc","Welcome aboard the F-22A Raptor, Need help? Check out Help --> Tutorials");
  tuttimer.stop();
}


var geardelaymain = func() {
  gearmain.start();
  geardelay.stop();
  setprop("f22/quick-gear",0);

}

tuttimer = maketimer(5,tutmessage);
dmgtimer = maketimer(0.3,checkdmg);
geardelay = maketimer(10,geardelaymain);
setlistener("sim/signals/fdm-initialized", func {
setprop("f22/water",0);
# Spawned in/went to location
gearmain.stop();
setprop("f22/gear1/failed",0);
setprop("f22/gear2/failed",0);
setprop("f22/gear3/failed",0);
setprop("f22/gear1/pos",1);
setprop("f22/gear2/pos",1);
setprop("f22/gear3/pos",1);
setprop("f22/gear-damaged",0);
setprop("f22/quick-gear",1);
setprop("fdm/jsbsim/gear/gear-pos-norm",1);
setprop("controls/gear/gear-down",1);
geardelay.start();
setprop("controls/engines/engine[0]/throttle",0);
setprop("controls/engines/engine[1]/throttle",0);
setprop("controls/gear/brake-parking",1);
dmgtimer.start();
tuttimer.start();
K14.initSightComputer();
headupdate.start();
shake_timer.start();
shake_timer2.start();
crash_timer.stop(); # stop crash xd
crashreinit_timer.start();
repair();
screen.log.write("Ready");
timer_jitter.start();  
timer_flarecheck.start();          # flare checker
timer_eng.start();          # engines
timer_loopTimer.start();    # Pullup alarm
timer_extpylons.start();    # External pylon detection
timer_damage.start();
blinktimer.start();
bingotimer.start();
consoletimer.start();
setprop("f22/grind",0);
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
    setprop("controls/lighting/ldg",0);
    setprop("sim/model/clicksmall",!getprop("sim/model/clicksmall"));
  }
}
setlistener("/controls/gear/gear-down",gearlighting);

var tutorialinit = func(type) {
  if (type == "startup") {
    print("Startup Tutorial Started");
    emu.engstopr();
    emu.engstopl();
    setprop("controls/electric/battswitch",0);
    setprop("controls/electric/battswitch-pos",-1);
  }
}

var flight_debug = func(){
  screen.property_display.add("/controls/flight/elevator");
  screen.property_display.add("/controls/flight/aileron");
  screen.property_display.add("/controls/flight/rudder");
  screen.property_display.add("/controls/engines/engine/throttle");
  screen.property_display.add("/controls/engines/engine[1]/throttle");
}

setprop("controls/radar/cursormode",1);

print("f22.nas Ready!");
# End f22.nas
#
# "ECM Missile Jammer" (With air quotes)
#
# Written by Phoenix
setprop("controls/jammer/status",0);
setprop("controls/jammer/autodeploy",0);
setprop("controls/jammer/autodeploymode",1);
setprop("controls/jammer/heading",60);
setprop("controls/jammer/callsign","");
setprop("controls/jammer/distance",10); # 5 nm
# How it works. Constantly Release "invisible chaff and flares" as fast as possible. the goal here is protect the plane the best we can. 
# The attacker wont know the jammer is on because it wont show the flares out on multiplayer. There missile will just magically miss. 
# If the number is not nil or 0. then itll run an RNG every time the number changes and the targets missile code checks our number again

var flare = "rotors/main/blade[3]/flap-deg";
var chaff = "rotors/main/blade[3]/position-deg";


var spec = func() {
  var en = getprop("controls/jammer/en");
  var ae = getprop("controls/radar/lockedcallsign");
  var hg = getprop("controls/jammer/heading"); # IN TRUE
  var dt = getprop("controls/jammer/distance"); # IN TRUE
  # SUPER IMPORTANT
  var negoffset = 0.5;
  var neg = rand() < (1-negoffset);
  var offset = rand() * (rand() *4);
  if (neg == 1) {
    offset = offset * -1;
  }
  var dist = dt + offset;
  print("Jammer offset: "~offset~"");
  print("Jammer dist: "~dist~"");

  if (ae != nil and en == 1) {
    var mp = misc.smallsearch(ae);
    var lat1 = getprop("ai/models/multiplayer[" ~ mp ~ "]/position/latitude-deg");
    var lon1 = getprop("ai/models/multiplayer[" ~ mp ~ "]/position/longitude-deg");
    var alt1 = getprop("ai/models/multiplayer[" ~ mp ~ "]/position/altitude-ft");
    # coord thingy
    var coord1 = geo.Coord.new();  
    var gndelev1 = alt1;
    coord1.set_latlon(lat1, lon1, gndelev1);
    var mslhdg = hg + offset; # IN TRUE
    if (mslhdg < 0) {
      mslhdg = mslhdg + 360;
    }
    # move the virt msl
    coord1.apply_course_distance(mslhdg, dist * NM2M);
    var newlat = coord1.lat();
    var newlon = coord1.lon();
    var deleted = 0;
    # the sender
    var unique = -11;
    var typeID = 52;
    var msg = notifications.ArmamentInFlightNotification.new("mfly", unique, deleted?damage.DESTROY:damage.MOVE, damage.DamageRecipient.typeID2emesaryID(typeID));
    var altm = alt1*FT2M;

    msg.Position.set_latlon(newlon,newlat,altm);
    msg.Flags = 1; #act rad msl
    msg.Flags = bits.set(msg.Flags, 0); # (should show smoke? 1 yes 0 no) | will do no for now. since there is actually no missile
    msg.IsDistinct = !deleted; # The missile is "Not" dead
    msg.RemoteCallsign = ae;
    msg.UniqueIndex = ""~typeID~unique; # tid and the current missile number
    msg.Pitch = offset; # simple
    msg.Heading = mslhdg; # simple
    msg.u_fps = 500; # simple
    #msg.isValid();
    notifications.geoBridgedTransmitter.NotifyAll(msg); # send
  }
}


# INIT.
setprop("/rotors/main/blade[3]/flap-deg", 0);  # flare
setprop("/rotors/main/blade[3]/position-deg", 0); # chaff


# method 1
var method1 = func {
var flarerand = rand(); # random decimal from 0 to 1
  # every time these numbers change. the shooter runs chaff flare probability 
  # so if we change them really fast that will be good
setprop("/rotors/main/blade[3]/flap-deg", flarerand);  #flarerand
setprop("/rotors/main/blade[3]/position-deg", flarerand);
#settimer(func{
##etprop("/rotors/main/blade[3]/flap-deg", 0);
##etprop("/rotors/main/blade[3]/position-deg", 0);
#                },0.00001); # this may be the key to our speed
spec();
}
 
# Method1 results:
# Fast


# method 2
var method2 = func {
var flarerand = rand(); # random decimal from 0 to 1
  # every time these numbers change. the shooter runs chaff flare probability 
  # so if we change them really fast that will be good
setprop("/rotors/main/blade[3]/flap-deg", flarerand);
setprop("/rotors/main/blade[3]/position-deg", flarerand);
setprop("/rotors/main/blade[3]/flap-deg", 0);
setprop("/rotors/main/blade[3]/position-deg", 0);
}

# Method2 results:
# Nope. it just stayed at zero.
#

var method3 = func {

var flarerand = rand(); # random decimal from 0 to 1
  # every time these numbers change. the shooter runs chaff flare probability 
  # so if we change them really fast that will be good
setprop("/rotors/main/blade[3]/flap-deg", flarerand);
setprop("/rotors/main/blade[3]/position-deg", flarerand);
reset();
}

# Method3 results:
# same as method 2. failed 
# Stuck on zero. it runs too fast


# default method4
var method4 = func{
	var flarerand = rand(); # random decimal from 0 to 1
  # every time these numbers change. the shooter runs chaff flare probability 
  # so if we change them really fast that will be good
    setprop("/rotors/main/blade[3]/flap-deg", flarerand);  #flarerand
    setprop("/rotors/main/blade[3]/position-deg", flarerand);
settimer(func   {
    setprop("/rotors/main/blade[3]/flap-deg", 0);
    setprop("/rotors/main/blade[3]/position-deg", 0);
    #props.globals.getNode("/rotors/main/blade[3]/flap-deg").setValue(0);
    #props.globals.getNode("/rotors/main/blade[3]/position-deg").setValue(0);
                },0.1); # this may be the key to our speed
 
}

# Seems method1 is the fastest


var reset = func {
setprop("/rotors/main/blade[3]/flap-deg", 0);
setprop("/rotors/main/blade[3]/position-deg", 0);
}

var resetinf = func {
  setprop("/rotors/main/blade[3]/flap-deg", 0);
  setprop("/rotors/main/blade[3]/position-deg", 0);
  method5(); # inf loop! goes back to rand
}

# Method 5 (chaos) USE WITH CAUTION!
var method5 = func { 
  # infinate loop call1 function then call another
  var flarerand = rand(); # random decimal from 0 to 1
    # every time these numbers change. the shooter runs chaff flare probability 
    # so if we change them really fast that will be good
  setprop("/rotors/main/blade[3]/flap-deg", flarerand);
  setprop("/rotors/main/blade[3]/position-deg", flarerand);
  resetinf();
}
setprop("controls/jammer/en",0);
method1timer = maketimer(0.00001,method1);
method1timerwithzero = maketimer(0,method1);
method2timer = maketimer(0.00001,method2);
method3timer = maketimer(0.00001,method3);
method4timer = maketimer(0.00001,method4);
fakemissile = maketimer(0,spec);
var cycledeploymode = func() {
  var mode = getprop("controls/jammer/autodeploymode");
  if (mode == 1) {
    setprop("controls/jammer/autodeploymode",2);
  } elsif (mode == 2) {
    setprop("controls/jammer/autodeploymode",3);
  } elsif (mode == 3) {
    setprop("controls/jammer/autodeploymode",4);
  } elsif (mode == 4) {
    setprop("controls/jammer/autodeploymode",5);
  } elsif (mode == 5) {
    setprop("controls/jammer/autodeploymode",1);
  }
}

var toggleautodeploy = func() {
  var autodeploy = getprop("controls/jammer/autodeploy");
  if (autodeploy == 0) {
    screen.log.write("Jammer autodeploy enabled");
    setprop("controls/jammer/autodeploy",1);
  } else {
    screen.log.write("Jammer autodeploy disabled");
    setprop("controls/jammer/autodeploy",0);
  }
}

var toggle = func() {
  var status = getprop("controls/jammer/status");
  if (status == 0) {
    jammer.start();
    fakemissile.start();
  } else {
    jammer.stop();
    fakemissile.stop();
  }
}


var failureloop = func {
  # check electrical
  var elec = getprop("sim/failure-manager/systems/electrical/serviceable");
  if (elec == 0) {
    # Electrical failed. 
    if (getprop("controls/jammer/status") == 1) {
      # Jammer was on before elecs died. 
      silentstop();
    }
  }
}

var start = func {
  method1timerwithzero.start();
  setprop("sim/messages/atc","Jammer running");
  setprop("controls/jammer/status",1);
  fakemissile.start();
}
var stop = func {
  method1timerwithzero.stop();
  setprop("sim/messages/atc","Jammer stopped");
  setprop("controls/jammer/status",0);
  fakemissile.stop();
}
var silentstop = func {
  method1timerwithzero.stop();
  setprop("controls/jammer/status",0);
}
var silentstart = func {
  method1timerwithzero.start();
  setprop("controls/jammer/status",1);
}

var failureloop = func {
  # check electrical
  var elec = getprop("sim/failure-manager/systems/electrical/serviceable");
  if (elec == 0) {
    # Electrical failed. 
    if (getprop("controls/jammer/status") == 1) {
      # Jammer was on before elecs died. 
      setprop("sim/messages/atc","Jammer failure!");
      setprop("controls/jammer/autodeploy",0);
      silentstop();
    }
  }
}

var checkwarnings = func() {
  silentstop();
  screen.log.write("Jammer deployed for 2 minuet burst. Jammer stopped. Autodeploy reactivated.");
  autodeploytimer.start();
  delaytimer.stop();
}


var deployjammer = func(mode) {
  silentstart();
  autodeploytimer.stop();
  delaytimer.start();
  screen.log.write("Jammer automatically deployed");
}

# Autodeploy

var autodeployloop = func {

  # Auto defenseive jammer | Code runs every second

  var mode = getprop("controls/jammer/autodeploymode");
  var deploy = getprop("controls/jammer/autodeploy");
  # Missle Alert Warnings
  var mawActive = getprop("payload/armament/MAW-active");
  var mawSemiActive = getprop("payload/armament/MAW-semiactive");
  var mawHeading = getprop("payload/armament/MAW-bearing");
  var mawSemiActiveCallsign = getprop("payload/armament/MAW-semiactive-callsign");
  # Missile Launch Warnings
  var mlwLauncher = getprop("payload/armament/MLW-launcher");
  var mlwCount = getprop("payload/armament/MLW-count");
  var mlwHeading = getprop("payload/armament/MLW-bearing");
  # Radar lock
  var spike = getprop("payload/armament/spike");
  
  if (deploy == 1) {
    # Automatic deployment available and enabled
    if (mode == 1) {
      # 1 - Active Missile Alerts Only
      if (mawActive == 1 or mawSemiActive == 1) {
        print("jammer.nas Autodeployed for 2 minuets on mode 1");
        deployjammer(mode);
        return 1;
      }
    } elsif (mode == 2) {
      # missile launch warnings only
      if (mlwLauncher != "" or mlwCount != 0) {
        print("jammer.nas Autodeployed for 2 minuets on mode 2");
        deployjammer(mode);
        return 1;
      }
    } elsif (mode == 3) {
      # spike only
      if (spike == 1) {
        print("jammer.nas Autodeployed for 2 minuets on mode 3");
        deployjammer(mode);
        return 1;
      }
    } elsif (mode == 4) {
      # missile stuff
      if (mlwLauncher != "" or mlwCount != 0 or mawActive == 1 or mawSemiActive == 1) {
        print("jammer.nas Autodeployed for 2 minuets on mode 4");
        deployjammer(mode);
        return 1;
      }
    } elsif (mode == 5) {
      # all of them
      if (mlwLauncher != "" or mlwCount != 0 or mawActive == 1 or mawSemiActive == 1 or spike == 1) {
        print("jammer.nas Autodeployed for 2 minuets on mode 5");
        deployjammer(mode);
        return 1;
      }
    }
  } else {
    return 0;
  }
}



failuretimer = maketimer(5,failureloop);
failuretimer.start();
delaytimer = maketimer(120,checkwarnings);
autodeploytimer = maketimer(1,autodeployloop);
autodeploytimer.start();
print("jammer.nas - Ready for action >:)");
# ====================== End jammer.nas ====================== # 
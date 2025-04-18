# Code from F-14 and F-15.
var clamp = func(v, min, max) { v < min ? min : v > max ? max : v }

var TRUE  = 1;
var FALSE = 0;

var cannon_types = {
    " M70 rocket hit":        0.25, #135mm
    " M55 cannon shell hit":  0.10, # 30mm
    " KCA cannon shell hit":  0.10, # 30mm
    " Gun Splash On ":        0.10, # 30mm
    " M61A1 shell hit":       0.05, # 20mm
    " GAU-8/A hit":           0.10, # 30mm
    " BK27 cannon hit":       0.07, # 27mm
    " GSh-30 hit":            0.10, # 30mm
    " GSh-23 hit":            0.065,# 23mm
    " 7.62 hit":              0.005,# 7.62mm
    " 50 BMG hit":            0.015,# 12.7mm
};
    
    
    
var warhead_lbs = {
    "aim-120":              44.00,
    "AIM120":               44.00,
    "AIM-120":              44.00,
    "RB-99":                44.00,
    "aim-7":                88.00,
    "AIM-7":                88.00,
    "RB-71":                88.00,
    "aim-9":                20.80,
    "AIM9":                 20.80,
    "AIM-9":                20.80,
    "RB-24":                20.80,
    "RB-24J":               20.80,
    "RB-74":                20.80,
    "R74":                  16.00,
    "MATRA-R530":           55.00,
    "Meteor":               55.00,
    "AIM-54":              135.00,
    "Matra R550 Magic 2":   27.00,
    "MatraR550Magic2":      27.00,
    "Matra MICA":           30.00,
    "MatraMica":            30.00,
    "MatraMicaIR":          30.00,
    "RB-15F":              440.92,
    "SCALP":               992.00,
    "KN-06":               315.00,
    "GBU12":               190.00,
    "GBU16":               450.00,
    "Sea Eagle":           505.00,
    "SeaEagle":            505.00,
    "AGM65":               200.00,
    "RB-04E":              661.00,
    "RB-05A":              353.00,
    "RB-75":               126.00,
    "M90":                 500.00,
    "M71":                 200.00,
    "M71R":                200.00,
    "MK-82":               192.00,
    "LAU-68":               10.00,
    "M317":                145.00,
    "GBU-31":              945.00,
    "AIM132":               22.05,
    "ALARM":               450.00,
    "STORMSHADOW":         850.00,
    "R-60":                  6.60,
    "R-27R1":               85.98,
    "R-27T1":               85.98,
    "FAB-500":             564.00,
    "Exocet":              364.00,
};

var fireMsgs = {
  
    # F14
    " FOX3 at":       nil, # radar
    " FOX2 at":       nil, # heat
    " FOX1 at":       nil, # semi-radar

    # Viggen
    " Fox 1 at":      nil, # semi-radar
    " Fox 2 at":      nil, # heat
    " Fox 3 at":      nil, # radar
    " Greyhound at":  nil, # cruise missile
    " Bombs away at": nil, # bombs
    " Bruiser at":    nil, # anti-ship
    " Rifle at":      nil, # TV guided

    # SAM and missile frigate
    " Bird away at":  nil, # G/A

    # F15
    " aim7 at":       nil,
    " aim9 at":       nil,
    " aim120 at":     nil,
};

var incoming_listener = func {
  var history = getprop("/sim/multiplay/chat-history");
  var hist_vector = split("\n", history);
  if (size(hist_vector) > 0) {
    var last = hist_vector[size(hist_vector)-1];
    var last_vector = split(":", last);
    var author = last_vector[0];
    var callsign = getprop("sim/multiplay/callsign");
    callsign = size(callsign) < 8 ? callsign : left(callsign,7);
    if (size(last_vector) > 1 and author != callsign) {
      # not myself
      #print("not me");
      var m2000 = FALSE;
      if (find(" at " ~ callsign ~ ". Release ", last_vector[1]) != -1) {
        # a m2000 is firing at us
        m2000 = TRUE;
      }
      if (contains(fireMsgs, last_vector[1]) or m2000 == TRUE) {
        # air2air being fired
        if (size(last_vector) > 2 or m2000 == TRUE) {
          #print("Missile launch detected at"~last_vector[2]~" from "~author);
          if (m2000 == TRUE or last_vector[2] == " "~callsign) {
            # its being fired at me
            #print("Incoming!");
            var enemy = getCallsign(author);
            if (enemy != nil) {
              #print("enemy identified");
              var bearingNode = enemy.getNode("radar/bearing-deg");
              if (bearingNode != nil) {
                #print("bearing to enemy found");
                var bearing = bearingNode.getValue();
                var heading = getprop("orientation/heading-deg");
                var clock = bearing - heading;
                while(clock < 0) {
                  clock = clock + 360;
                }
                while(clock > 360) {
                  clock = clock - 360;
                }
                #print("incoming from "~clock);
                if (clock >= 345 or clock < 15) {
                  playIncomingSound("12");
                } elsif (clock >= 15 and clock < 45) {
                  playIncomingSound("1");
                } elsif (clock >= 45 and clock < 75) {
                  playIncomingSound("2");
                } elsif (clock >= 75 and clock < 105) {
                  playIncomingSound("3");
                } elsif (clock >= 105 and clock < 135) {
                  playIncomingSound("4");
                } elsif (clock >= 135 and clock < 165) {
                  playIncomingSound("5");
                } elsif (clock >= 165 and clock < 195) {
                  playIncomingSound("6");
                } elsif (clock >= 195 and clock < 225) {
                  playIncomingSound("7");
                } elsif (clock >= 225 and clock < 255) {
                  playIncomingSound("8");
                } elsif (clock >= 255 and clock < 285) {
                  playIncomingSound("9");
                } elsif (clock >= 285 and clock < 315) {
                  playIncomingSound("10");
                } elsif (clock >= 315 and clock < 345) {
                  playIncomingSound("11");
                } else {
                  playIncomingSound("");
                }
                return;
              }
            }
          }
        }
      } elsif (getprop("payload/armament/oldmsg") == 1) { # mirage: getprop("/controls/armament/mp-messaging")
        # latest version of failure manager and taking damage enabled
        #print("damage enabled");
        var last1 = split(" ", last_vector[1]);
        if(size(last1) > 2 and last1[size(last1)-1] == "exploded" ) {
          #print("missile hitting someone");
          if (size(last_vector) > 3 and last_vector[3] == " "~callsign) {
            #print("that someone is me!");
            var type = last1[1];
            if (type == "Matra" or type == "Sea") {
              for (var i = 2; i < size(last1)-1; i += 1) {
                type = type~" "~last1[i];
              }
            }
            var number = split(" ", last_vector[2]);
            var distance = num(number[1]);
            #print(type~"|");
            if(distance != nil) {
              var dist = distance;

              if (type == "M90") {
                var prob = rand()*0.5;
                var failed = fail_systems(prob);
                var percent = 100 * prob;
                printf("Took %.1f%% damage from %s clusterbombs at %0.1f meters. %s systems was hit", percent,type,dist,failed);
                nearby_explosion();
                return;
              }

              distance = clamp(distance-3, 0, 1000000);
              var maxDist = 0;

              if (contains(warhead_lbs, type)) {
                maxDist = maxDamageDistFromWarhead(warhead_lbs[type]);
              } else {
                return;
              }

              var diff = maxDist-distance;
              if (diff < 0) {
                diff = 0;
              }
              
              diff = diff * diff;
              
              var probability = diff / (maxDist*maxDist);

              var failed = fail_systems(probability);
              var percent = 100 * probability;
              printf("Took %.1f%% damage from %s missile at %0.1f meters. %s systems was hit", percent,type,dist,failed);
              nearby_explosion();
            }
          } 
        } elsif (cannon_types[last_vector[1]] != nil) {
          if (size(last_vector) > 2 and last_vector[2] == " "~callsign) {
            if (size(last_vector) < 4) {
              # msg is either missing number of hits, or has no trailing dots from spam filter.
              print('"'~last~'"   is not a legal hit message, tell the shooter to upgrade his OPRF plane :)');
              return;
            }
            var last3 = split(" ", last_vector[3]);
            if(size(last3) > 2 and size(last3[2]) > 2 and last3[2] == "hits" ) {
              var probability = cannon_types[last_vector[1]];
              var hit_count = num(last3[1]);
              if (hit_count != nil) {
                var damaged_sys = 0;
                for (var i = 1; i <= hit_count; i = i + 1) {
                  var failed = fail_systems(probability);
                  damaged_sys = damaged_sys + failed;
                }

                printf("Took %.1f%% x %2d damage from cannon! %s systems was hit.", probability*100, hit_count, damaged_sys);
                nearby_explosion();
              }
            } else {
              var probability = cannon_types[last_vector[1]];
              #print("probability: " ~ probability);
              
              var failed = fail_systems(probability * 3);# Old messages is assumed to be 3 hits
              printf("Took %.1f%% x 3 damage from cannon! %s systems was hit.", probability*100, failed);
              nearby_explosion();
            }
          }
        }
      }
    }
  }
}

var maxDamageDistFromWarhead = func (lbs) {
  # very simple
  var dist = 3*math.sqrt(lbs);

  return dist;
}

var fail_systems = func (probability) {
    var failure_modes = FailureMgr._failmgr.failure_modes;
    var mode_list = keys(failure_modes);
    var failed = 0;
    foreach(var failure_mode_id; mode_list) {
        if (rand() < probability) {
            FailureMgr.set_failure_level(failure_mode_id, 1);
            failed += 1;
        }
    }
    return failed;
};

var playIncomingSound = func (clock) {
  setprop("sound/incoming"~clock, 1);
  settimer(func {stopIncomingSound(clock);},3);
}

var stopIncomingSound = func (clock) {
  setprop("sound/incoming"~clock, 0);
}

var callsign_struct = {};
var getCallsign = func (callsign) {
  var node = callsign_struct[callsign];
  return node;
}

var nearby_explosion = func {
  setprop("damage/sounds/nearby-explode-on", 0);
  settimer(nearby_explosion_a, 0);
}

var nearby_explosion_a = func {
  setprop("damage/sounds/nearby-explode-on", 1);
  settimer(nearby_explosion_b, 0.5);
}

var nearby_explosion_b = func {
  setprop("damage/sounds/nearby-explode-on", 0);
}

var processCallsigns = func () {
  callsign_struct = {};
  var players = props.globals.getNode("ai/models").getChildren();
  foreach (var player; players) {
    if(player.getChild("valid") != nil and player.getChild("valid").getValue() == TRUE and player.getChild("callsign") != nil and player.getChild("callsign").getValue() != "" and player.getChild("callsign").getValue() != nil) {
      var callsign = player.getChild("callsign").getValue();
      callsign_struct[callsign] = player;
    }
  }
}
processCallsignsTimer = maketimer(1.5, processCallsigns);
processCallsignsTimer.simulatedTime = 1;
processCallsignsTimer.start();


#f14b
var sendMis = func () {
  var mkeys = keys(armament.AIM9.active);
  var str = "";
  foreach(var m; mkeys) {
    var mid = m;
    m = armament.AIM.active[m];
    if (m.status == 2) {
      var lat = m.latN.getValue();
      var lon = m.lonN.getValue();
      var alt = m.altN.getValue();
      #print();
      #print(mid);
      #print(lat);
      #print(lon);
      #print(alt);
      str = str~mid~";"~lat~";"~lon~";"~alt~":";
    }
  }
  setprop("sim/multiplay/generic/string[13]", str);
}
sendMisTimer = maketimer(0.05, sendMis);
sendMisTimer.simulatedTime = 1;

var logTime = func{
  #log time and date for outputing ucsv files for converting into KML files for google earth.
  if (getprop("logging/log[0]/enabled") == TRUE and getprop("sim/time/utc/year") != nil) {
    var date = getprop("sim/time/utc/year")~"/"~getprop("sim/time/utc/month")~"/"~getprop("sim/time/utc/day");
    var time = getprop("sim/time/utc/hour")~":"~getprop("sim/time/utc/minute")~":"~getprop("sim/time/utc/second");

    setprop("logging/date-log", date);
    setprop("logging/time-log", time);
  }
}

#sendMisTimer.start(); ; use emesary for this

var ct = func (type) {
  if (type == "c-u") {
    setprop("sim/ct/c-u", 1);
  }
  if (type == "rl" and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE) {
    setprop("sim/ct/rl", 1);
  }
  if (type == "rp" and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE) {
    setprop("sim/ct/rp", 1);
  }
  if (type == "a") {
    setprop("sim/ct/a", 1);
  }
  if (type == "lst") {
    setprop("sim/ct/list", 1);
  }
  if (type == "ifa" and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE) {
    setprop("sim/ct/ifa", 1);
  }
  if (type == "sf" and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE) {
    setprop("sim/ct/sf", 1);
  }
}

var lf = -1;
var ll = 0;

var code_ct = func () {
  var cu = getprop("sim/ct/c-u");
  if (cu == nil or cu != 1) {
    cu = 0;
  }
  var a = getprop("sim/ct/a");
  if (a == nil or a != 1) {
    a = 0;
  }
  var ff = getprop("sim/freeze/fuel");
  if (ff == nil) {
    ff = 0;
  } elsif (ff == 1) {
    setprop("sim/ct/ff", 1);
  }
  ff = getprop("sim/ct/ff");
  if (ff == nil or ff != 1) {
    ff = 0;
  }
  var cl =  getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[0]")+getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[1]")
           +getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[2]")+getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[3]")
           +getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[4]")+getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[5]")
           +getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[6]")+getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[7]")
           +getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[8]")+getprop("fdm/jsbsim/inertia/pointmass-weight-lbs[9]");
  if (cl > (ll*1.05) and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE) {
    setprop("sim/ct/rl", 1);
  }
  ll = cl;
  var rl = getprop("sim/ct/rl");
  if (rl == nil or rl != 1) {
    rl = 0;
  }
  var rp = getprop("sim/ct/rp");
  if (rp == nil or rp != 1) {
    rp = 0;
  }
  var cf =   getprop("/consumables/fuel/tank[0]/level-gal_us")
            +getprop("/consumables/fuel/tank[1]/level-gal_us")
            +getprop("/consumables/fuel/tank[2]/level-gal_us")
            +getprop("/consumables/fuel/tank[3]/level-gal_us")
            +getprop("/consumables/fuel/tank[4]/level-gal_us");
            
  if (cf != nil and lf != -1 and cf > (lf*1.1) and getprop("fdm/jsbsim/gear/unit[0]/WOW") != TRUE and getprop("/systems/refuel/contact") == FALSE) {
    setprop("sim/ct/rf", 1);
  }
  var rf = getprop("sim/ct/rf");
  if (rf == nil or rf != 1) {
    rf = 0;
  }
  lf = cf == nil?0:cf;
  var dm = !getprop("payload/armament/oldmsg");
  if (dm == nil or dm != 1) {
    dm = 0;
  }
  var tm = 0;#getprop("sim/ja37/radar/look-through-terrain");
  if (tm == nil or tm != 1) {
    tm = 0;
  }
  var rd = 0;#!getprop("sim/ja37/radar/doppler-enabled");
  if (rd == nil or rd != 1) {
    rd = 0;
  }  
  var ml = getprop("sim/ct/list");
  if (ml == nil or ml != 1) {
    ml = 0;
  }
  var sf = getprop("sim/ct/sf");
  if (sf == nil or sf != 1) {
    sf = 0;
  }
  var ifa = getprop("sim/ct/ifa");
  if (ifa == nil or ifa != 1) {
    ifa = 0;
  }
  var final = "ct"~cu~ff~rl~rf~rp~a~dm~tm~rd~ml~sf~ifa;
  setprop("sim/multiplay/generic/string[15]", final);
}
code_ctTimer = maketimer(2, code_ct);
code_ctTimer.simulatedTime = 1;

var not = func {
print("no cheat")
}
notTimer = maketimer(60, not);
notTimer.simulatedTime = 1;

var changeGuiLoad = func()
{#return;
    var searchname1 = "mp-list";
    var searchname2 = "instrument-failures";
    var searchname3 = "system-failures";
    var state = 0;
    
    foreach(var menu ; props.globals.getNode("/sim/menubar/default").getChildren("menu")) {
        foreach(var item ; menu.getChildren("item")) {
            foreach(var name ; item.getChildren("name")) {
                if(name.getValue() == searchname1) {
                    #var e = item.getNode("enabled").getValue();
                    #var path = item.getPath();
                    #item.remove();
                    #item = props.globals.getNode(path,1);
                    #item.getNode("enabled",1).setBoolValue(FALSE);
                    #item.getNode("binding").remove();
                    #item.getNode("name",1).setValue(searchname1);
                    item.getNode("binding/command").setValue("nasal");
                    item.getNode("binding/script").setValue("armament.loadMPList()");
                    #item.getNode("enabled",1).setBoolValue(TRUE);
                }
                if(name.getValue() == searchname2) {
                    item.getNode("binding/command").setValue("nasal");
                    item.getNode("binding/dialog-name").remove();
                    item.getNode("binding/script",1).setValue("armament.loadIFail()");
                }
                if(name.getValue() == searchname3) {
                    item.getNode("binding/command").setValue("nasal");
                    item.getNode("binding/dialog-name").remove();
                    item.getNode("binding/script",1).setValue("armament.loadSysFail()");
                }
            }
        }
    }
    fgcommand("reinit", props.Node.new({"subsystem":"gui"}));
}

var loadMPList = func () {
  ct("lst");multiplayer.dialog.show();
}

var loadSysFail = func () {
  ct("sf");fgcommand("dialog-show", props.Node.new({"dialog-name":"system-failures"}));
}

var loadIFail = func () {
  ct("ifa");fgcommand("dialog-show", props.Node.new({"dialog-name":"instrument-failures"}));
}

setlistener("/sim/multiplay/chat-history", incoming_listener, 0, 0);

setprop("/sim/failure-manager/display-on-screen", FALSE);

changeGuiLoad();
code_ctTimer.start();
notTimer.start();

var re_init = func {
  # repair the aircraft

  var failure_modes = FailureMgr._failmgr.failure_modes;
  var mode_list = keys(failure_modes);

  foreach(var failure_mode_id; mode_list) {
    FailureMgr.set_failure_level(failure_mode_id, 0);
  }
  setprop("ai/submodels/submodel[4]/count", 100);
  setprop("ai/submodels/submodel[5]/count", 100);
}

setlistener("/sim/signals/reinit", re_init, 0, 0);
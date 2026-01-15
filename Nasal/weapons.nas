print("LOADING weapons.nas pew pew! fox 3 fox3!.");
################################################################################
#
#                        F-22 WEAPONS SETTINGS
#							Thanks to the m2005-5's developpers
#                          and Special thanks to Developer0607! (Ghost)
################################################################################

var dt = 0;
var isFiring = 0;
var splashdt = 0;
var MPMessaging = props.globals.getNode("/payload/armament/msg", 1);



# Multishot stuff

setprop("controls/armament/multishot/callsign1","");
setprop("controls/armament/multishot/callsign2","");
setprop("controls/armament/multishot/callsign3","");
setprop("controls/armament/multishot/callsign4","");
setprop("controls/armament/multishot/callsign5","");
setprop("controls/armament/multishot/callsign6","");
setprop("controls/armament/multishot/callsign7","");
setprop("controls/armament/multishot/callsign8","");
setprop("controls/armament/multishot/numcallsign",1);
setprop("controls/armament/multishot/message","Multishot Disabled");
setprop("controls/armament/multishot/lockattempts",0);
setprop("controls/armament/multishotstate",0);
setprop("controls/armament/missile/multishot",0);


# Radar functions

var attemptmultilock = func(csind) {
  var lockattempts = getprop("controls/armament/multishot/lockattempts");
  var total = 100; # 100 attempts for each is ok
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
      print("In multilock | I | looking for");
      print(i);
      print(getprop("controls/armament/multishot/callsign" ~ csind ~ ""));
      # Cycle the radar
      radar.next_Target_Index(1,1); # Dont print w/ lock.
      var cs = getprop("instrumentation/radar/cs");
      if (getprop("controls/armament/multishot/callsign" ~ csind ~ "") == cs) {
          print("multilock loop: Radar locked successfully! Firing weapon...");
          # Radar locked on callsign[csind]
          # ready to shoot
          var missile = getprop("controls/missile");
          setprop("controls/missile", !missile);
          m2000_load.SelectNextPylon();
          f22.fire(0,0); # Open the bay doors of the currently selected weapon
          var pylon = getprop("/controls/armament/missile/current-pylon");
          m2000_load.dropLoad(pylon);
          screen.log.write("Multishot Weapon Fired!");
          print("Should fire Missile");
          setprop("/controls/armament/missile-trigger", 1);
          return 1; # Success
        }
    }
    screen.log.write("failed to lock onto:");
    screen.log.write(getprop("controls/armament/multishot/callsign" ~ csind ~ ""));
    return 0;

}


var multishotradar = func() {
    setprop("instrumentation/radar/cs","");
    # refresh the radar and add it to the list
    radar.next_Target_Index(1,0); # dont print w/ no lock.
    var radarcallsign = getprop("instrumentation/radar/cs");
    var numcallsign = getprop("controls/armament/multishot/numcallsign");
    setprop("controls/armament/multishot/callsign" ~ numcallsign ~ "",radarcallsign);
}

var multishot = func() {
    setprop("instrumentation/radar/cs","");
    # Fire the weapons at the Designated Targets
    var multishotstate = getprop("controls/armament/multishotstate");
    if (multishotstate == 0) {
        return 0;
    }
    # Refresh the weapons
    var weaponname = getprop("controls/armament/selected-weapon");
    missile.Loading_missile(weaponname);
    var amnt = getprop("controls/armament/missile/multishot");
    var numcallsign = getprop("controls/armament/multishot/numcallsign");
    if (amnt != 0) {
        print("Ready for a multishot!");
        for(var i = 1; i < numcallsign+1; i += 1) {
            print("IN MULTISHOT LOOP i:"~i~"");
            var lockresult = attemptmultilock(i); 
        }
        
    } else {
        screen.log.write("The currently selected weapon cant be used with Multishot")
    }
}

var multishotreset = func() {
    screen.log.write("Multishot Reset and disabled");
    setprop("controls/armament/multishot/callsign1","");
    setprop("controls/armament/multishot/callsign2","");
    setprop("controls/armament/multishot/callsign3","");
    setprop("controls/armament/multishot/callsign4","");
    setprop("controls/armament/multishot/callsign5","");
    setprop("controls/armament/multishot/callsign6","");
    setprop("controls/armament/multishot/callsign7","");
    setprop("controls/armament/multishot/callsign8","");
    setprop("controls/armament/multishot/numcallsign",1);
    setprop("controls/armament/multishotstate",0);
    setprop("controls/armament/multishot/message","Multishot Disabled");
}
var multishotprev = func() {
    var numcallsign = getprop("controls/armament/multishot/numcallsign");
    if (numcallsign != 1) {
        setprop("controls/armament/multishot/numcallsign",numcallsign - 1);
    } else {
        screen.log.write("At first target!");
    }
}
var multishotnext = func() {
    var numcallsign = getprop("controls/armament/multishot/numcallsign");
    if (numcallsign != 8) {
        setprop("controls/armament/multishot/numcallsign",numcallsign + 1);
    } else {
        screen.log.write("At last target!");
    }
}

var multishottoggle = func() {
    # Refresh the weapons
    var weaponname = getprop("controls/armament/selected-weapon");
    missile.Loading_missile(weaponname);
    var numcallsign = getprop("controls/armament/multishotstate");
    if (numcallsign == 0) {
        setprop("controls/armament/multishotstate",1);
        screen.log.write("Multishot Enabled");
        setprop("controls/armament/multishot/message","Multishot Enabled");
    } else {
        setprop("controls/armament/multishotstate",0);
        screen.log.write("Multishot Disabled");
        setprop("controls/armament/multishot/message","Multishot Disabled");
    }
}

var checkburst = func() {
    if (getprop("ai/submodels/submodel[0]/count") == 0) {
        autostopFiring();
        setprop("ai/submodels/submodel[0]/count",50);
        reset.stop();
    }
}
reset = maketimer(0,checkburst);

# Controls
# Trigger

fire_MG = func() {  # b would be in the ()

    var time = getprop("/sim/time/elapsed-sec");
    if(getprop("/sim/failure-manager/systems/wcs/failure-level"))return;
    if (getprop("controls/armament/trigger") == 0){return;} #hmmm
    if(getprop("/controls/armament/stick-selector") == 1)
    {
        # guns
        if (getprop("controls/armament/master-arm") == 1 and getprop("ai/submodels/submodel[1]/count") != 0) {
        isFiring = 1;
        
        setprop("/controls/armament/gun-trigger", 1);
        #settimer(autostopFiring, 0.47); # Fast burst
        reset.start();
        } else {
            screen.log.write("Master arm is not armed or the gun is out of ammo");
        }
    }
    if(getprop("/controls/armament/stick-selector") == 2)
    {
        # missiles
            if (getprop("controls/armament/master-arm") == 1) {
            # multishot check
            if (getprop("controls/armament/multishotstate") == 1){
                print("Multiple Target Shot!");
                multishot();
            } else {
                # Normal Control
            # var time = getprop("/sim/time/elapsed-sec");
                if(time - dt > 0.5) # Adjust this 0 for limit on how many missiles you can shoot at once speed limit
                {
                    var missile = getprop("controls/missile");
                    setprop("controls/missile", !missile);
                    dt = time;
                    m2000_load. SelectNextPylon();
                    f22.fire(0,0); # Open the bay doors of the currently selected weapon
                    var pylon = getprop("/controls/armament/missile/current-pylon");
                    m2000_load.dropLoad(pylon);
                    print("Should fire Missile");
                    setprop("/controls/armament/missile-trigger", 1);
                }
            }
        } else {
            screen.log.write("Master arm is not armed");
        }
    }
}
# Pickle
fire_MG_pic = func() {  # b would be in the ()
    var time = getprop("/sim/time/elapsed-sec");
    if(getprop("/sim/failure-manager/systems/wcs/failure-level"))return;
    if (getprop("controls/armament/pickle") == 0){return;} #hmmm
        if (getprop("controls/armament/master-arm") == 1) {
            # Multishot check
        if (getprop("controls/armament/multishotstate") == 1){
            print("Multiple Target Shot!");
            multishot();
        } else {
        # var time = getprop("/sim/time/elapsed-sec"); 
        if(time - dt > 0.5) # Adjust this 0 for limit on how many missiles you can shoot at once speed limit
            {
                var missile = getprop("controls/missile");
                setprop("controls/missile", !missile);
                dt = time;
                m2000_load.SelectNextPylon();
                screen.log.write("Pickle!");
                f22.fire(0,0); # Open the bay doors of the currently selected weapon
                var pylon = getprop("/controls/armament/missile/current-pylon");
                m2000_load.dropLoad(pylon);
                print("Should fire Missile");
                setprop("/controls/armament/missile-trigger", 1);
            }
        }
    } else {
        screen.log.write("Master arm is not armed");
    }
}



var autostopFiring = func() {
    setprop("/controls/armament/missile-trigger", 0);
    setprop("/controls/armament/gun-trigger", 0);
    isFiring = 0;
}


var stopFiring = func() {
    if (getprop("controls/armament/trigger") == 0) {

        setprop("/controls/armament/missile-trigger", 0);
    setprop("/controls/armament/gun-trigger", 0);
    isFiring = 0;
    }
}

gun_timer = maketimer(0.01, stopFiring);
gun_timer.start();

reload = func() {
    setprop("/ai/submodels/submodel/count",    50);
    setprop("/ai/submodels/submodel[1]/count", 480);
    setprop("/ai/submodels/submodel[2]/count", 480);
    setprop("/ai/submodels/submodel[3]/count", 480);
    setprop("/ai/submodels/submodel[4]/count", 480);
    setprop("/ai/submodels/submodel[5]/count", 480);
    setprop("/ai/submodels/submodel[6]/count", 480);
    setprop("/ai/submodels/submodel[7]/count", 480);
    setprop("/f22/flare",200);
    setprop("/f22/chaff",200);
    screen.log.write("Reloaded guns and countermessures! Repaired damage aswell.");
}


input = {
  elapsed:          "/sim/time/elapsed-sec",
  impact:           "/ai/models/model-impact",
};

foreach(var name; keys(input)) {
      input[name] = props.globals.getNode(input[name], 1);
}

var last_impact = 0;

var hit_count = 0;

#gun hits

var hits_count = 0;
var hit_timer  = nil;
var hit_callsign = "";

var Mp = props.globals.getNode("ai/models");
var valid_mp_types = {
    multiplayer: 1, tanker: 1, aircraft: 1, ship: 1, groundvehicle: 1,
};

# Find a MP aircraft close to a given point (code from the Mirage 2000)
var findmultiplayer = func(targetCoord, dist) {
    if(targetCoord == nil) return nil;

    var raw_list = Mp.getChildren();
    var SelectedMP = nil;
    foreach(var c ; raw_list)
    {
        var is_valid = c.getNode("valid");
        if(is_valid == nil or !is_valid.getBoolValue()) continue;

        var type = c.getName();

        var position = c.getNode("position");
        var name = c.getValue("callsign");
        if(name == nil or name == "") {
            # fallback, for some AI objects
            var name = c.getValue("name");
        }
        if(position == nil or name == nil or name == "" or !contains(valid_mp_types, type)) continue;

        var lat = position.getValue("latitude-deg");
        var lon = position.getValue("longitude-deg");
        var elev = position.getValue("altitude-ft") * FT2M;

        if(lat == nil or lon == nil or elev == nil) continue;

        MpCoord = geo.Coord.new().set_latlon(lat, lon, elev);
        var tempoDist = MpCoord.direct_distance_to(targetCoord);
        if(dist > tempoDist) {
            dist = tempoDist;
            SelectedMP = name;
        }
    }
    return SelectedMP;
}

var impact_listener = func {
    var ballistic_name = props.globals.getNode("/ai/models/model-impact").getValue();
    var ballistic = props.globals.getNode(ballistic_name, 0);
    if (ballistic != nil and ballistic.getName() != "munition") {
        var typeNode = ballistic.getNode("impact/type");
        if (typeNode != nil and typeNode.getValue() != "terrain") {
            var lat = ballistic.getNode("impact/latitude-deg").getValue();
            var lon = ballistic.getNode("impact/longitude-deg").getValue();
            var elev = ballistic.getNode("impact/elevation-m").getValue();
            var impactPos = geo.Coord.new().set_latlon(lat, lon, elev);
            var target = findmultiplayer(impactPos, 80);

            if (target != nil) {
                var typeOrd = ballistic.getNode("name").getValue();
                if(target == hit_callsign) {
                    # Previous impacts on same target
                    hits_count += 1;
                }
                else {
                    if (hit_timer != nil) {
                        # Previous impacts on different target, flush them first
                        hit_timer.stop();
                        hitmessage(typeOrd);
                    }
                    hits_count = 1;
                    hit_callsign = target;
                    hit_timer = maketimer(1, func {hitmessage(typeOrd,hit_callsign,hits_count);});
                    hit_timer.singleShot = 1;
                    hit_timer.start();
                }
            }
        }
    }
}

var hitmessage = func(typeOrd,callsign,hits) {
    #print("inside hitmessage");
    var phrase = "M61A1 shell" ~ " hit: " ~ callsign ~ ": " ~ hits ~ " hits";
    if (getprop("payload/armament/msg") == 1) {
      #setprop("/sim/multiplay/chat", phrase);   Old damage system
        #armament.defeatSpamFilter(phrase);
    print("Guns hit target");
        var msg = notifications.ArmamentNotification.new("mhit", 4, -1*(damage.shells["M61A1 shell"][0]+1));
        msg.RelativeAltitude = 0;
        msg.Bearing = 0;
        msg.Distance = hits;
        msg.RemoteCallsign = callsign;
        notifications.hitBridgedTransmitter.NotifyAll(msg);
        damage.damageLog.push("You hit "~callsign~" with "~"M61A1 shells"~", "~hits~" times.");
    } else {
        setprop("/sim/messages/atc", phrase);
    }
    hit_callsign = "";
    hit_timer = nil;
    hits_count = 0;
}

# setup impact listener
setlistener("/ai/models/model-impact", impact_listener, 0, 0);
setprop("/controls/armament/target-selected",0);
setprop("/controls/armament/weapon-selected",0);
var pickle = func() {
    if (getprop("controls/armament/pickle") == 1) {
        print("pickle on");
    } else {
        print("pickle off");
    }
}



setlistener("/controls/armament/trigger",fire_MG);
setlistener("/controls/armament/pickle",fire_MG_pic);





var switch_target = func(){
    if(getprop("/controls/armament/target-selected") == 1) {
        radar.next_Target_Index();
        setprop("/controls/armament/target-selected", 0);   
    }
    if(getprop("/controls/armament/target-selected") == -1) {
        radar.previous_Target_Index();
        setprop("/controls/armament/target-selected", 0);   
    }
}

# Target switch
setlistener("/controls/armament/target-selected",switch_target);


var switch_weapon = func(){
    if(getprop("/controls/armament/weapon-selected") == 1) {
        # AA
        if (getprop("/controls/armament/selected-weapon") == "none"){
            setprop("/controls/armament/selected-weapon","Aim-120");
            setprop("/controls/armament/selected-weapon-digit",2);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
            
        }
        if (getprop("/controls/armament/selected-weapon") == "GBU-39"){
            setprop("/controls/armament/selected-weapon","Aim-120");
            setprop("/controls/armament/selected-weapon-digit",2);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
            
        }
        if (getprop("/controls/armament/selected-weapon") == "JDAM"){
            setprop("/controls/armament/selected-weapon","Aim-120");
            setprop("/controls/armament/selected-weapon-digit",2);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }
        if (getprop("/controls/armament/selected-weapon") == "Aim-9x"){
            setprop("/controls/armament/selected-weapon","Aim-120");
            setprop("/controls/armament/selected-weapon-digit",2);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }
        if (getprop("/controls/armament/selected-weapon") == "Aim-120"){
            setprop("/controls/armament/selected-weapon","Aim-260");
            setprop("/controls/armament/selected-weapon-digit",4);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);  
            return 0;
        }
        if (getprop("/controls/armament/selected-weapon") == "Aim-260"){
            setprop("/controls/armament/selected-weapon","Aim-9x");
            setprop("/controls/armament/selected-weapon-digit",1);
            screen.log.write("Joystick: A/A Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }

        setprop("/controls/armament/weapon-selected", 0);   
    }
    if(getprop("/controls/armament/weapon-selected") == -1) {
        # AG
        if (getprop("/controls/armament/selected-weapon") == "none" or getprop("/controls/armament/selected-weapon") == "Aim-120" or getprop("/controls/armament/selected-weapon") == "Aim-260" or getprop("/controls/armament/selected-weapon") == "Aim-9x"){
            setprop("/controls/armament/selected-weapon","GBU-39");
            setprop("/controls/armament/selected-weapon-digit",3);
            screen.log.write("Joystick: A/G Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }
        if (getprop("/controls/armament/selected-weapon") == "GBU-39"){
            setprop("/controls/armament/selected-weapon","JDAM");
            setprop("/controls/armament/selected-weapon-digit",4);
            screen.log.write("Joystick: A/G Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }
        if (getprop("/controls/armament/selected-weapon") == "JDAM"){
            setprop("/controls/armament/selected-weapon","GBU-39");
            setprop("/controls/armament/selected-weapon-digit",1);
            screen.log.write("Joystick: A/G Selected: "~getprop("/controls/armament/selected-weapon")~"");
            setprop("/controls/armament/weapon-selected", 0);   
                            var weaponname = getprop("controls/armament/selected-weapon");
                 missile.Loading_missile(weaponname);
            return 0;
        }
        setprop("/controls/armament/weapon-selected", 0);   
    }
}

#switch_weapon();
#print("ae");

var missile_reject = func(){
    print("Reject pressed");
    if (getprop("/controls/armament/missile-reject") == 1) {
        #screen.log.write("Reject!");
        CMS.updatecms();
        CMS.trigger();
        setprop("/controls/armament/missile-reject",0);
    }
}


setlistener("/controls/armament/missile-reject",missile_reject);


var stickreporter = func(){
    if(getprop("/controls/armament/stick-selector") == 1)screen.log.write("Selected M61A1 Vulcon.",1,0.4,0.4);
    else{screen.log.write("Selected missiles.",1,0.4,0.4);}
}
setlistener("/controls/armament/stick-selector",stickreporter);

switch_weapon_timer = maketimer(0,switch_weapon);
switch_weapon_timer.start();


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

fire_MG = func() {  # b would be in the ()

    var time = getprop("/sim/time/elapsed-sec");
    if(getprop("/sim/failure-manager/systems/wcs/failure-level"))return;
    
    if(getprop("/controls/armament/stick-selector") == 1)
    {
        isFiring = 1;
        setprop("/controls/armament/gun-trigger", 1);
        #settimer(stopFiring, 0.1);
    }
    if(getprop("/controls/armament/stick-selector") == 2)
    {
     #   if(b == 1)
     #   {
            
            # var time = getprop("/sim/time/elapsed-sec");
            if(time - dt > 1) # Adjust this 0 for limit on how many missiles you can shoot at once speed limit
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
      #  }
    }
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

reload_Cannon = func() {
    setprop("/ai/submodels/submodel/count",    510);
    setprop("/ai/submodels/submodel[1]/count", 12000);
    setprop("/ai/submodels/submodel[2]/count", 12000);
    setprop("/ai/submodels/submodel[3]/count", 12000);
    setprop("/ai/submodels/submodel[4]/count", 12000);
    setprop("/ai/submodels/submodel[5]/count", 12000);
    setprop("/ai/submodels/submodel[6]/count", 12000);
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
                    hit_timer = maketimer(1, func {hitmessage(typeOrd);});
                    hit_timer.singleShot = 1;
                    hit_timer.start();
                }
            }
        }
    }
}

var hitmessage = func(typeOrd) {
    #print("inside hitmessage");
    var phrase = "M61A1 shell" ~ " hit: " ~ hit_callsign ~ ": " ~ hits_count ~ " hits";
    if (getprop("payload/armament/msg") == 1) {
      #                                                                                                                 setprop("/sim/multiplay/chat", phrase);   Old damage system
        #armament.defeatSpamFilter(phrase);
    print("Guns hit target");
            var msg = notifications.ArmamentNotification.new("mhit", 4, -1*(damage.shells["M61A1 shell"][0]+1));
        msg.RelativeAltitude = 0;
        msg.Bearing = 0;
        msg.Distance = hits_count;
        msg.RemoteCallsign = hit_callsign;
        notifications.hitBridgedTransmitter.NotifyAll(msg);
        damage.damageLog.push("You hit "~hit_callsign~" with "~"M61A1 shells"~", "~hits_count~" times.");
    } else {
        setprop("/sim/messages/atc", phrase);
    }
    hit_callsign = "";
    hit_timer = nil;
    hits_count = 0;
}

# setup impact listener
setlistener("/ai/models/model-impact", impact_listener, 0, 0);


setlistener("/controls/armament/trigger",fire_MG);

var stickreporter = func(){
    if(getprop("/controls/armament/stick-selector") == 1)screen.log.write("Selected M61A1 Vulcon.",1,0.4,0.4);
    else{screen.log.write("Selected missiles.",1,0.4,0.4);}
}
setlistener("/controls/armament/stick-selector",stickreporter);




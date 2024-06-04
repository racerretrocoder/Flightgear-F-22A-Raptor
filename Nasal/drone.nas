# turns a fg plane into a drone that can be controlled via mp-chat

####THOUGHTS
#Decrease amount of elevators during phase 0/1 of takeoff for more control.
#Decrease roll during takeoff

var agl_threshold = 2500;
var stall_threshold = 225;

var last_comm_time = systime();
setprop("/controls/drone/enable",0);
setprop("/controls/drone/owner","");
setprop("/controls/drone/mode","free-flight");
setprop("/controls/drone/stall_safety","armed");
setprop("/controls/drone/agl_safety","armed");
setprop("/controls/drone/damaged","false");
setprop("/payload/armament/msg",0);
setprop("/controls/drone/pattern",0);
setprop("/controls/drone/pattern-dir","-1");
setprop("/controls/drone/pattern-tightness",2); #1 = slow, 2 = normal, 3 = quick, 4 = supaquick!
setprop("/controls/gear/brake-parking",1);

# takeoff stuff
setprop("/controls/drone/takeoff-landing/takeoff-stage",0);

############################################
####MP CHAT COMMANDS
############################################

var incoming_listener = func {
    var history = getprop("/sim/multiplay/chat-history");
    var hist_vector = split("\n", history);
    var drone_cs = getprop("/sim/multiplay/callsign");
    if (size(hist_vector) > 0) {
        var last = hist_vector[size(hist_vector)-1];
        var last_vector = split(" ", last);
        var author = last_vector[0];
      author = left(author,size(author)-1);
        callsign = getprop("/controls/drone/owner");
        
        if ( last_vector[1] == drone_cs and size(last_vector) > 1 ) {
            if ( last_vector[2] == "control" and last_vector[3] == "request" ) {
                #request control of the drone
                #will hand over control after 15 minutes of no comms from owner.
                var cur_time = systime();
                if ( getprop("/controls/drone/owner") == "" ) {
                    setprop("/controls/drone/owner",author);
                    setprop("/sim/multiplay/chat","Drone owner set to: " ~ author);
                } elsif ( cur_time - last_comm_time > 900 ) {
                    setprop("/controls/drone/owner",author);
                    setprop("/sim/multiplay/chat","Drone owner changed to: " ~ author);
                } else {
                    setprop("/sim/multiplay/chat","Current owner is: " ~ getprop("controls/drone/owner") ~ " - please wait for " ~ int(900 - (cur_time - last_comm_time)) ~ " seconds or request control from owner.");
                }
            } elsif (size(last_vector) > 2 and author == callsign) {
            
                if ( last_vector[2] == "enable" ) {
                    #enable remote control
                    setprop("/controls/drone/enable",1);
                    
                    #freeze fuel
                    setprop("/sim/freeze/fuel","true");
    
                    #setup airport
                    setprop("/sim/tower/auto-position","false");
                    setprop("/controls/drone/base",getprop("/sim/airport/closest-airport-id"));
                    
                    #enable autopilot
                    setprop("/autopilot/locks/heading","dg-heading-hold");
                    setprop("/autopilot/locks/altitude","altitude-hold");
                    setprop("/autopilot/locks/speed","speed-with-throttle");

                    setprop("/autopilot/settings/target-altitude-ft",getprop("/position/altitude-ft"));
                    setprop("/autopilot/settings/target-speed-kt",int(getprop("/velocities/groundspeed-kt")));
                    setprop("/autopilot/settings/heading-bug-deg",getprop("/orientation/heading-magnetic-deg"));
                    
               #if everything worked, update over chat.
                    setprop("/sim/multiplay/chat", "Drone control enabled");
                } elsif ( last_vector[2] == "disable" ) {
                    #disable drone control
                    setprop("/controls/drone/enable/",0);
                    
                    #unfreeze fuel
                    setprop("/sim/freeze/fuel","false");
                    
                    #tower position stuff
                    setprop("/sim/tower/auto-position","true");            
    
                    #turn off autopilot
                    setprop("/autopilot/locks/altitude","");
                    setprop("/autopilot/locks/heading","");
                    setprop("/autopilot/locks/speed","");
                    
                    #let us know what's up.
                    setprop("/sim/multiplay/chat", "Drone control disabled");
                } elsif ( getprop("/controls/drone/enable/") == 1 ){
                    if ( last_vector[2] == "heading" and last_vector[3] != nil ) {
                        setprop("/autopilot/settings/heading-bug-deg",num(last_vector[3]));
                        setprop("/controls/drone/mode","free-flight");
                        setprop("/sim/multiplay/chat", "Drone heading set to: " ~ last_vector[3]);
                    } elsif ( last_vector[2] == "altitude" and last_vector[3] != nil ) {
                        setprop("/autopilot/settings/target-altitude-ft",num(last_vector[3]));
                        setprop("/sim/multiplay/chat", "Drone altitude set to: " ~ last_vector[3]);
                    } elsif ( last_vector[2] == "speed" and last_vector[3] != nil ) {
                        setprop("/autopilot/settings/target-speed-kt",num(last_vector[3]));
                        setprop("/sim/multiplay/chat", "Drone speed set to: " ~ last_vector[3]);
                    } elsif ( last_vector[2] == "takeoff" ) {
                        setprop("/sim/multiplay/chat", "Drone taking off");
                        take_off_init();
                    } elsif ( last_vector[2] == "gear" and last_vector[3] == "deploy" ) {
                        setprop("/controls/gear/gear-down","true");
                        setprop("/sim/multiplay/chat", "Drone gear deployed");
                    } elsif ( last_vector[2] == "gear" and last_vector[3] == "retract" ) {
                        setprop("/controls/gear/gear-down","false");
                        setprop("/sim/multiplay/chat", "Drone gear retracted");
                    } elsif ( last_vector[2] == "brakes" and last_vector[3] == "on" ) {
                        setprop("/controls/gear/brake-parking",1);
                        setprop("/sim/multiplay/chat", "Drone brakes on");
                    } elsif ( last_vector[2] == "brakes" and last_vector[3] == "off" ) {
                        setprop("/controls/gear/brake-parking",0);
                        setprop("/sim/multiplay/chat", "Drone brakes off");
                    } elsif ( last_vector[2] == "repair" ) {
                        repair_damage();
                        
                    ####PATTERNS
                        
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "oval" ) {
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",2);
                        setprop("/sim/multiplay/chat", "Drone flying oval pattern");
                        fly_pattern();
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "triangle" ) {
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",3);
                        setprop("/sim/multiplay/chat", "Drone flying triangle pattern");
                        fly_pattern();
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "square" ) {
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",4);
                        setprop("/sim/multiplay/chat", "Drone flying square pattern");
                        fly_pattern();
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "pentagon" ) {
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",5);
                        setprop("/sim/multiplay/chat", "Drone flying pentagon pattern");
                        fly_pattern();
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "hexagon" ){
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",6);
                        setprop("/sim/multiplay/chat", "Drone flying hexagon pattern");
                        fly_pattern();
                    } elsif ( last_vector[2] == "pattern" and last_vector[3] == "circle" ){
                        setprop("/controls/drone/mode","pattern");
                        setprop("/controls/drone/pattern",512);
                        setprop("/sim/multiplay/chat", "Drone flying circle pattern");
                        fly_pattern();
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "turn" and last_vector[4] == "left" ){
                        setprop("/controls/drone/pattern-dir","-1");
                        setprop("/sim/multiplay/chat", "Drone performing patterns turning left");
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "turn" and last_vector[4] == "right" ){
                        setprop("/controls/drone/pattern-dir","1");
                        setprop("/sim/multiplay/chat", "Drone performing patterns turning right");
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "slow" ){
                        setprop("/controls/drone/pattern-tightness",1);
                        setprop("/sim/multiplay/chat", "Drone performing patterns slowly");
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "normal" ){
                        setprop("/controls/drone/pattern-tightness",1.33);
                        setprop("/sim/multiplay/chat", "Drone performing patterns normally");
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "quick" ){
                        setprop("/controls/drone/pattern-tightness",2);
                        setprop("/sim/multiplay/chat", "Drone performing patterns quickly");
                    } elsif (last_vector[2] == "pattern" and last_vector[3] == "very" and last_vector[4] == "quick" ){
                        setprop("/controls/drone/pattern-tightness",3);
                        setprop("/sim/multiplay/chat", "Drone performing patterns very quickly");
                        
                    #### TACTICAL
                    
                    } elsif (last_vector[2] == "damage" and last_vector[3] == "off" ) {
                        setprop("/payload/armament/msg",0);
                        setprop("/sim/multiplay/chat", "Drone damage disabled");
                    } elsif (last_vector[2] == "damage" and last_vector[3] == "on" ) {
                        setprop("/payload/armament/msg",1);
                        setprop("/sim/multiplay/chat", "Drone damage enabled");
                    } elsif (last_vector[2] == "evade"){
                        setprop("/sim/multiplay/chat", "Drone performing evasive maneouvers.");
                        setprop("/controls/drone/mode","evade");
                        evade();

                    } elsif (last_vector[2] == "bfm 0"){
                        setprop("/sim/multiplay/chat", "Drone performing BFM training level 0.");
                        setprop("/controls/drone/mode","bfm 0");
                        bfm_0();
                        
                    #### DRONE REPORT    
                    
                    } elsif ( last_vector[2] == "report" ) {
                        settimer(report1,1);
                        
                    #### CHANGE OWNER
                        
                    } elsif ( last_vector[2] == "change" and last_vector[3] == "owner" and last_vector[4] != nil ) {
                        setprop("/controls/drone/owner", ~ last_vector[4]);
                        setprop("/sim/multiplay/chat", "Drone owner changed to: " ~ last_vector[4]);
                        
                    #### FLY TO AIRPORT MODES
                    
                    } elsif ( last_vector[2] == "return" ) {
                        setprop("/controls/drone/mode","fly-to-airport");
                        setprop("/sim/tower/airport-id",getprop("/controls/drone/base"));
                        setprop("/sim/multiplay/chat", "Drone returning to: " ~ getprop("/controls/drone/base"));
                        fly_to_airport();
                    } elsif ( last_vector[2] == "fly" and last_vector[3] == "to" and last_vector[4] != nil ) {
                        setprop("/controls/drone/mode","fly-to-airport");
                  setprop("/sim/tower/latitude-deg",0);
                  setprop("/sim/tower/longitude-deg",0);
                        setprop("/sim/tower/airport-id",last_vector[4]);
                  if ( getprop("/sim/tower/latitude-deg") == 0 or getprop("/sim/tower/longitude-deg") == 0 ) {
                     setprop("/sim/multiplay/chat", "Drone cannot fly to " ~ last_vector[4] ~ " - not a valid airport.");
                  } else { 
                           setprop("/sim/multiplay/chat", "Drone flying to: " ~ last_vector[4]);
                           fly_to_airport();
                  }
                    }
                    
                last_comm_time = systime();
                
                }
            }
        }
    }
}

var report1 = func {
    setprop("/sim/multiplay/chat", "Drone speed: " ~ int(getprop("/instrumentation/airspeed-indicator/indicated-speed-kt")));
    settimer(report2,1);
}

var report2 = func {
    setprop("/sim/multiplay/chat", "Drone altitude: " ~ int(getprop("/instrumentation/altimeter/indicated-altitude-ft")));
    settimer(report3,1);
}

var report3 = func {
    setprop("/sim/multiplay/chat", "Drone heading: " ~ int(getprop("/instrumentation/magnetic-compass/indicated-heading-deg")));
    if ( getprop("controls/drone/mode") == "fly-to-airport" ) {
        settimer(report4,1);
    }
}

var report4 = func {
    setprop("/sim/multiplay/chat", "Drone destination: " ~ getprop("/sim/tower/airport-id"));
}

#######################################################
#####DRONE NON-TACTICAL FLIGHT SYSTEMS
#######################################################

var take_off_init = func {
   if ( getprop ("position/altitude-agl-ft") > 10 ) {
      setprop("/sim/multiplay/chat","Drone already in air, ignoring takeoff command.");
      return;
   }
    setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/altimeter/indicated-altitude-ft"));
    setprop("/autopilot/settings/target-speed-kt",350);
    setprop("/controls/drone/mode","takeoff");
    take_off();
}

var take_off = func {
    if ( getprop("/controls/drone/mode") != "takeoff" ) {
        return;
    }
    setprop("/autopilot/locks/heading","takeoff-heading-hold");
    setprop("/controls/drone/autopilot/roll-minimum",-8);
    setprop("/controls/drone/autopilot/roll-maximum",8);
    setprop("/controls/gear/brake-parking",0);
    var agl = getprop("/position/altitude-agl-ft");
    var ias = getprop("/velocities/airspeed-kt");
    var stage = getprop("/controls/drone/takeoff-landing/takeoff-stage");
    if ( ias > 185 and stage == 0 ) {
        #if our speed is greater than 200, start to climb.
        setprop("/controls/drone/takeoff-landing/takeoff-stage",1);
        setprop("/autopilot/locks/altitude","pitch-hold");
        setprop("/autopilot/settings/target-altitude-ft",getprop("/instrumentation/altimeter/indicated-altitude-ft") + 10000);
        setprop("/autopilot/settings/target-pitch-deg",12);
        setprop("/sim/multiplay/chat","Drone at V2, beginning climb.");
        setprop("/autopilot/locks/heading","dg-heading-hold");
    } elsif ( agl > 100 and stage == 1 ) {
        #if agl is over 100 feet, we can set the climb rate to be more agressive
        setprop("/controls/drone/takeoff-landing/takeoff-stage",2);
        setprop("/autopilot/locks/altitude","altitude-hold");
        setprop("/controls/gear/gear-down","false");
        setprop("/sim/multiplay/chat","Drone at 100ft AGL, retracting wheels.")
    } elsif ( agl > 500 and stage == 2 ) {
        #once we hit 500 agl, set even more aggressive climb rate, and exit take_off function
        setprop("/controls/drone/takeoff-landing/takeoff-stage",0);
        setprop("/autopilot/locks/heading","dg-heading-hold");
        setprop("/controls/drone/mode","free-flight");
        setprop("/autopilot/settings/heading-bug-deg",getprop("/orientation/heading-magnetic-deg"));
        setprop("/sim/multiplay/chat","Drone at 500ft AGL, setting aggressive climb rate. Takeoff complete.")
    }
    settimer(take_off,1);
}

var fly_pattern = func {
    if ( getprop("controls/drone/mode") != "pattern" ){
        return;
    }
    
    var new_heading = ((360 / getprop("/controls/drone/pattern")) * getprop("/controls/drone/pattern-dir")) + getprop("/autopilot/settings/heading-bug-deg");
    if ( new_heading > 360 ){
        new_heading = new_heading - 360;
    } elsif ( new_heading < 0 ){
        new_heading = new_heading + 360;
    }
    setprop("/autopilot/settings/heading-bug-deg",new_heading);

    var time_to_next = (480 / getprop("/controls/drone/pattern-tightness")) / getprop("/controls/drone/pattern");
    settimer(fly_pattern,time_to_next);
}

var fly_to_airport = func {
    if ( getprop("/controls/drone/mode") == "fly-to-airport" ) {
        var end_loc = geo.Coord.new().set_latlon(getprop("/sim/tower/latitude-deg"),getprop("/sim/tower/longitude-deg"));
        var distance = end_loc.distance_to(geo.aircraft_position());
        var heading = end_loc.course_to(geo.aircraft_position());
        heading = heading + 180;
        if ( heading > 360 ) {
            heading = heading - 360;
        }
        if ( distance < 12500 ) {
            heading = getprop("/autopilot/settings/heading-bug-deg") + (45 * (getprop("controls/drone/pattern-dir") * -1));
            setprop("/autopilot/settings/heading-bug-deg",heading);
            setprop("/controls/drone/pattern",64);
            setprop("/controls/drone/mode","pattern");
            setprop("/sim/multiplay/chat","Drone reached destination, entering circle pattern.");
            settimer(fly_pattern,30);
        }
        setprop("/autopilot/settings/heading-bug-deg",heading);
        settimer(fly_to_airport,30);
    }
}

#######################################################
#####DRONE TACTICAL FLIGHT SYSTEMS
#######################################################

var check_aglias = func {
    var agl = getprop("/position/altitude-agl-ft");
    var ias = getprop("/velocities/airspeed-kt");
    
    if ( (agl < 5000 or ias < 240 ) and getprop("/controls/drone/damaged") == "true" ) {
        repair_damage();
        var new_alt = getprop("/position/altitude-ft") + 5000;
        setprop("/autopilot/settings/target-altitude-ft", new_alt);
        setprop("/autopilot/settings/target-speed-kt",350);
        setprop("/sim/multiplay/chat","Drone damage repaired, minimum speed/AGL threshold reached, attempting to save self.");
    } elsif ( getprop("/controls/drone/damaged") == "true" ) {
        settimer(check_aglias,.5);
    }
}

var repair_damage = func() {
    var failure_modes = FailureMgr._failmgr.failure_modes;
    var mode_list = keys(failure_modes);

    foreach(var failure_mode_id; mode_list) {
        FailureMgr.set_failure_level(failure_mode_id, 0);
    }
    
    setprop("/sim/multiplay/chat","Damage repaired.");
    setprop("/controls/drone/damaged","false");
}

var evade = func {
    if ( getprop("/controls/drone/mode") != "evade" ) {
        return;
    } 

    var new_speed = getprop("/autopilot/settings/target-speed-kt") + ((rand() * 40) - 20);
    if ( new_speed < 250 ) {
        new_speed = 300 + ( rand() * 10 );
    }

    var new_heading = getprop("/autopilot/settings/heading-bug-deg") + (int(rand() * 360));
    if ( new_heading > 360 ) {
        new_heading = new_heading - 360;
    }

    var new_alt = getprop("/autopilot/settings/target-altitude-ft") + ( (rand() * 5000) - 2500 );
    if ( new_alt < (getprop("/position/altitude-ft") - getprop("/position/altitude-agl-ft")) + 1000 ) {
        new_alt = 2500;
    }

    setprop("/autopilot/settings/target-speed-kt",new_speed);
    setprop("/autopilot/settings/heading-bug-deg",new_heading);
    setprop("/autopilot/settings/target-altitude-ft",new_alt);

    var evade_timer = ( rand() * 30 ) + 15;

    settimer( evade, evade_timer );
}


var bfm_0 = func {
    if ( getprop("/controls/drone/mode") != "bfm 0" ) {
        return;
    } 

    var new_heading = getprop("/autopilot/settings/heading-bug-deg") + (int(rand() * 360));
    if ( new_heading > 360 ) {
        new_heading = new_heading - 360;
    }

    setprop("/autopilot/settings/heading-bug-deg",new_heading);

    var bfm_0_timer = ( rand() * 30 ) + 15;

    settimer( bfm_0, bfm_0_timer );
}

###################################################
#####SAFETY LOOP
###################################################

var safety_loop = func {

    #first check if safeties are necessary - if agl > 300 and we aren't taking off.
    if ( getprop("/controls/drone/enable") == 0 or getprop("/controls/drone/mode") == "takeoff" or getprop("/position/altitude-agl-ft") < 250) {
        return;
    }
    

    if ( getprop("/position/altitude-agl-ft") < agl_threshold and getprop("/controls/drone/agl_safety") == "armed" ) {
        var new_alt = getprop("/position/altitude-ft") + 5000;
        setprop("/autopilot/settings/target-altitude-ft", new_alt );
        setprop("/controls/drone/agl_safety", "engaged");
        setprop("/sim/multiplay/chat","Drone AGL minimum threshold reached, setting altitude to: " ~ int(new_alt));
    } elsif ( getprop("/controls/drone/stall_safety") == "engaged" ) {
        if ( getprop("/position/altitude-agl-ft") > agl_threshold + 500 ) {
            setprop("/controls/drone/agl_safety","armed");
        }
    }
    
    if ( getprop("/velocities/airspeed-kt") < stall_threshold and getprop("/controls/drone/stall_safety") == "armed" ) {
        var new_speed = (stall_threshold - getprop("/velocities/airspeed-kt")) + getprop("velocities/airspeed-kt") + 25;
        setprop("/autopilot/settings/target-speed-kt",new_speed);
        setprop("/controls/drone/stall_safety", "engaged");
        setprop("/sim/multiplay/chat","Drone KIAS minimum threshold reached, setting speed to: " ~ int(new_speed));
    } elsif ( getprop("/controls/drone/agl_safety") == "engaged" ) {
        if ( getprop("/velocities/airspeed-kt") > stall_threshold + 25 ) {
            setprop("/controls/drone/stall_safety","armed");
        }
    }
    
    settimer( safety_loop, safety_loop_timer );
}

###################################################
#####FCS CONTROL
###################################################

var fcs_control = func() {
    #simple fcs thingies based on ias
    
    #settings for easier changing
    
    var my_speed = getprop("/velocities/airspeed-kt");
    
    #roll
    var min_roll = 30;
    var min_roll_speed = 300;
    var max_roll = 70;
    var max_roll_speed = 600;
    
    #climb
    var min_climb_rate = 25;
    var min_climb_rate_speed = 225;
    var max_climb_rate = 65;
    var max_climb_rate_speed = 600;
    
    #set max roll degrees
    #uses 2d interpolation formula
    var roll_deg = min_roll + (my_speed - min_roll_speed) * (max_roll - min_roll) / (max_roll_speed - min_roll_speed);
    roll_deg = math.clamp( roll_deg, min_roll, max_roll );
    #print("calced r_deg: " ~ roll_deg);
    #print("my speed: " ~ my_speed);
    
    setprop("/controls/drone/autopilot/roll-minimum",-roll_deg);
    setprop("/controls/drone/autopilot/roll-maximum",roll_deg);
    
    
    #set climb rate
    var climb_rate = min_climb_rate + (my_speed - min_climb_rate_speed) * (max_climb_rate - min_climb_rate) / (max_climb_rate_speed - min_climb_rate_speed);
    climb_rate = math.clamp( climb_rate, min_climb_rate, max_climb_rate);
    setprop("/controls/drone/autopilot/min-climb-rate",-climb_rate);
    setprop("/controls/drone/autopilot/max-climb-rate",climb_rate);
    #print("calced c_r: " ~ climb_rate);
    
    
    settimer( func() { fcs_control(); }, 1);
}

###################################################
#####INITIALIZATION
###################################################

setlistener("/sim/multiplay/chat-history", incoming_listener, 0, 0);
setlistener("/controls/drone/damaged", check_aglias, 0, 0);
#safety_loop(); #currently buggy
fcs_control();
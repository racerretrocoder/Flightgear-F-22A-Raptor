#print("LOADING Loading_missiles.nas .");
################################################################################
#
#                     F-22  LOADS AND MISSILES PARAMETERS
#Note: these missiles are VERY basic, and curently the only for the radar to work
################################################################################


# Fox's: and how they work here

# Fox 3,  Radar guided fire and forget nature
# Fox 2, Same as fox 3
# Fox 1, Weapon stops guiding if radar losses lock
# Magnum, payload/armament/spike must be for this to guide. This fox can reaqqure



var Loading_missile = func(name)
{
    var typeid            = 0;
    var address           = "test";
    var NoSmoke           = "test2";
    var Explosion         = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
    var maxdetectionrngnm = 0;      #
    var fovdeg            = 0;      #
    var detectionfovdeg   = 0;      #
    var trackmaxdeg       = 0;      #
    var maxg              = 0;      #
    var thrustlbs         = 0;      #
    var thrustdurationsec = 0;     #
    var thrustlbsstage2   = 0;      #
    var thrustdurationsecstage2 =  0;     #
    var weightlaunchlbs   = 0;      #
    var dragcoeff         = 0;      #
    var dragarea          = 0;    #
    var maxExplosionRange = 0;   # The distance when the missile blows up sorta speak
    var maxspeed          = 0;
    var life              = 0;
    var sdspeed           = 0;
    var fox               = "nothing";  # call Fox 1 if you want to drop like a tank. If you dont youll get a nasal error.  Fox 1 missiles are possible too. If there is a target when launched. But if the radar losses it. it wont hit 
    var rail              = 1;     # If the missile is launched on a rail or not if false the missile is "dropped"
    var cruisealt         = 0;
    var guidance	      = 0;
    var chute             = 1;
    var flareres          = 0;          # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares
    var isbomb            = 0; # if this weapon is a bomb
    var pbrange           = 0; # in meters
    var multishot = 0;
    var ignitedelay = 0.5; # If the weapon is NOT dropped from a rail, Delay starting the engine by however many seconds (Default 0.5)



    
    if(name == "Aim-120")
    {
        # AIM-120 :AMRAAM,      
	    typeid = 52;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/AIM120-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/AIM120-smoke.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        flareres = 0.99; # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares. Because flares are checked every 0.1 seconds a high number is needed because this variable is sensitve
        maxdetectionrngnm = 38.8;                    #  
        fovdeg = 360;                                #
        detectionfovdeg = 360;                       # TODO implent data link system so we can control these variables while missile is in flight
        trackmaxdeg = 360;                           # 
        maxg = 30;                                   # wikipedia
        thrustlbs = 2700;                             # 1,500 to 2,500 pounds of thrust maybe
        thrustlbsstage2 = 280;
        thrustdurationsec = 10;
        thrustdurationsecstage2 = 18;                      # 
        weightlaunchlbs = 421; # weightlaunch + fuel
        weightwarheadlbs = 44;
        dragcoeff = 0.14;                              # really slow lowerd it a bit
        dragarea = 0.0236;                            # sq ft
        maxExplosionRange = 200;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 4.8;                              # In mach ( source is a guess )
        life = 110; # 
        sdspeed = 0.65;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = 0;
        cruisealt = 0;
        chute = 0;
        isbomb = 0;
        pbrange = 10000; # added on 
        multishot = 6;
        ignitedelay = 0.5;
    }

    elsif(name == "Aim-260")
    {
        # AIM-260D JATM!
        # JATM is not in damage.nas :( so itll just be an Aim-54
	    typeid = 52;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-260/AIM260.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-260/AIM260.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        flareres = 0.98; # 0.999    Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares. Because flares are checked every 0.1 seconds a high number is needed because this variable is sensitve
        maxdetectionrngnm = 3008.8;                    #  300000000000000
        fovdeg = 360;                                
        detectionfovdeg = 360;                       
        trackmaxdeg = 360;                           
        maxg = 60;                                   
        thrustlbs = 1900;                            
        thrustlbsstage2 = 580;
        thrustdurationsec = 18;
        thrustdurationsecstage2 = 120;                      # 
        weightlaunchlbs = 421; # weightlaunch + fuel
        weightwarheadlbs = 44;
        dragcoeff = 0.001;                              # really slow lowerd it a bit
        dragarea = 0.0236;                            # sq ft
        maxExplosionRange = 200;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 8.7;                              # In mach ( source is a guess )
        life = 100000000000; # 
        sdspeed = 0.65;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = 0;
        cruisealt = 0;
        chute = 0;
        isbomb = 0;
        pbrange = 0;
        multishot = 6;
        ignitedelay = 2; 
    }

    elsif(name == "Aim-9x")
    {
        # AIM-9X:short-range A2A,IR seeker,
	    typeid = 98;
        flareres = 0.9; # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 52;               
        fovdeg = 180;                                 # seeker optical FOV
        detectionfovdeg = 180;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 180;                            # Seeker max total angular rotation
        maxg = 50;                                    # Thurst vectoring rocket motor
        thrustlbs = 400;                              # 
        thrustdurationsec = 1;           
        thrustlbsstage2 = 400;
        thrustdurationsecstage2 = 12;             # slowed acceleration seems needed here
        weightlaunchlbs = 246; # launch + fuel, 186 + 60
        weightwarheadlbs = 20.8;
        dragcoeff = 0.1;                              # guess; original 0.05
        dragarea = 0.01;                             # sq ft
        maxExplosionRange = 200;                       
        maxspeed = 2.5;                               # In Mach
        life = 60;
        fox = "Fox 2";
        rail = 1;
        cruisealt = 0;
        chute = 0;
        sdspeed = 0.01;
        isbomb = 0;
        multishot = 0;
        ignitedelay = 0;
    }
    elsif(name == "Aim-9m")
    {
        # AIM-9X:short-range A2A,IR seeker,
	    typeid = 98;
        flareres = 0.90; # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 52;               
        fovdeg = 140;                                 # seeker optical FOV
        detectionfovdeg = 140;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 140;                            # Seeker max total angular rotation
        maxg = 40;                                    # Thurst vectoring rocket motor
        thrustlbs = 290;                             # 
        thrustdurationsec = 7;           
        thrustlbsstage2 = 400;
        thrustdurationsecstage2 = 6.2;             # slowed acceleration seems needed here
        weightlaunchlbs = 246; # launch + fuel, 186 + 60
        weightwarheadlbs = 20.8;
        dragcoeff = 0.08;                              # guess; original 0.05
        dragarea = 0.013;                             # sq ft
        maxExplosionRange = 15;                       
        maxspeed = 3;                               # In Mach
        life = 90;
        fox = "Fox 2";
        rail = 1;
        cruisealt = 0;
        chute = 0;
        sdspeed = 0.01;
        isbomb = 0;
        multishot = 0;
        ignitedelay = 0;
    }




    elsif(name == "GBU-39")
    {
           # bomb,
        flareres = 1; # countermessueres cannont fool this. If your radar loosses lock on the target. the missile will miss 
	    typeid = 18;
        address = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        NoSmoke = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
        maxdetectionrngnm = 60;                       # Not real Impact yet A little more than the MICA
        fovdeg = 360;                                 # seeker optical FOV
        detectionfovdeg = 360;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 360;                            # Seeker max total angular rotation
        maxg = 4;                                     # 
        thrustlbs = 0;                                # 
        thrustdurationsec = 5;           
        thrustlbsstage2 = 0;
        thrustdurationsecstage2 = 5;    
        weightlaunchlbs = 186;
        weightwarheadlbs = 206;
        dragcoeff = 0.01;                              # guess; original 0.05
        dragarea = 0.00075;                             # sq ft
        maxExplosionRange = 400;                       
        maxspeed = 2.5;                                 # In Mach
        life = 100000000000000;
        fox = "A/G";  
        rail = 0;
        cruisealt = 0;
        sdspeed = 0;
        chute = 0;
        isbomb = 1;  
        multishot = 8; # up to 8 SDB's can be deployed at once
        ignitedelay = 2.1;
    }
 elsif(name == "JDAM")
 {
     flareres = 1;
	 typeid = 18;
     address = "Aircraft/F-22/Models/Stores/Missiles/JDAM/JDAM.xml"; 
     NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/JDAM/JDAM.xml"; # for now
     Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
     maxdetectionrngnm = 15;                       # 
     #GPS system
     fovdeg = 360;                                 # seeker optical FOV
     detectionfovdeg = 360;                        # Search pattern diameter (rosette scan)
     trackmaxdeg = 360;                            # Seeker max total angular rotation
     maxg = 2;                                    # 
     thrustlbs = 0;                             # 
     thrustdurationsec = 5;           
     thrustlbsstage2 = 0;
     thrustdurationsecstage2 = 5;             
     weightlaunchlbs = 2039;
     weightwarheadlbs = 945;
     dragcoeff = 0.125;                              # guess; original 0.05
     dragarea = 0.075;                             # sq ft
     maxExplosionRange = 400;                       
     maxspeed = 1.7;                                 # In Mach
     life = 10000;
     fox = "A/G";   
     rail = 0;
     cruisealt = 0;
     sdspeed = 0;
     chute = 0;
     isbomb = 1;
     multishot = 6;
     ignitedelay = 2.1;
 }


###################################################################
#
#
# warning: Below these missiles are not made to represent there accurate counterpart
# There here to test the missile system for proper functionality
#
##############################################################



    elsif(name == "Aim-7") #Debug missile
    {
                              flareres = 0.8;
  	typeid = 52; #Overridden at the end of missile.nas
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM7/AIM7-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM7/AIM7.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 38.8;                    #  
        fovdeg = 180;                                #
        detectionfovdeg = 180;                       # TODO implent data link system so we can control these variables while missile is in flight
        trackmaxdeg = 180;                           # 
        maxg = 9;                                   # wikipedia
        thrustlbs = 100;                             # 1,500 to 2,500 pounds of thrust maybe
        thrustlbsstage2 = 280;
        thrustdurationsec = 20;
        thrustdurationsecstage2 = 18;                      # 
        weightlaunchlbs = 200; # weightlaunch + fuel
        weightwarheadlbs = 44;
        dragcoeff = 0.17;                              # really slow lowerd it a bit
        dragarea = 0.0236;                            # sq ft
        maxExplosionRange = 100;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 5.8;                              # In mach ( source is a guess )
        life = 110; # 
        sdspeed = 0.4999999;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = "false";
        cruisealt = 5000;
        chute = 0;
        isbomb = 0;
        multishot = 0;
    }
    elsif(name == "eject")   # Used for the ejction seat. Not a missile so we call fox 1 and leave it
    {
           # ejection seat   Aircraft/F-22/Models/pilot/eject.xml
        flareres = 1;
	    typeid = 98;
        address = "Aircraft/F-22/Models/pilot/eject.xml";
        NoSmoke = "Aircraft/F-22/Models/pilot/eject.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 1;                                 # seeker optical FOV
        detectionfovdeg = 1;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 1;                            # Seeker max total angular rotation
        maxg = 12;                                    # eject
        thrustlbs = 5000;                                # 
        thrustdurationsec = 5;           
        thrustlbsstage2 = 0;
        thrustdurationsecstage2 = 5;    
                               # 
        weightlaunchlbs = 320;                        # Human + Chair
        weightwarheadlbs = 60;
        dragcoeff = 0.1;                              # Parachute implementation attempt
        dragarea = 3.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 0.0117;                                 # In Mach
        life = 500000;
        fox = "ejecting"; # call fox 1 then leave it. unguided
        rail = 1;
        cruisealt = 0;
        sdspeed = 0;
        chute = 1;
        isbomb = 0;
        multishot = 0;
        ignitedelay = 0;
    }
    else
    {
        return 0;
    }
    # SetProp
    setprop("controls/armament/missile/chute", chute);
    setprop("controls/armament/missile/address", address);
    setprop("controls/armament/missile/addressNoSmoke", NoSmoke);
    setprop("controls/armament/missile/addressExplosion", Explosion);
    setprop("controls/armament/missile/max-detectionrngnm", maxdetectionrngnm);
    setprop("controls/armament/missile/fov-deg", fovdeg);
    setprop("controls/armament/missile/detection-fov-deg", detectionfovdeg);
    setprop("controls/armament/missile/track-max-deg", trackmaxdeg);
    setprop("controls/armament/missile/thrust-lbs", thrustlbs);
    setprop("controls/armament/missile/thrust-lbs-stage-2", thrustlbsstage2);
    setprop("controls/armament/missile/max-g", maxg);
    setprop("controls/armament/missile/weight-launch-lbs", weightlaunchlbs);
    setprop("controls/armament/missile/thrust-duration-sec", thrustdurationsec);
    setprop("controls/armament/missile/thrust-duration-sec-stage2", thrustdurationsecstage2);
    setprop("controls/armament/missile/weight-warhead-lbs", weightwarheadlbs);
    setprop("controls/armament/missile/drag-coeff", dragcoeff);
    setprop("controls/armament/missile/drag-area", dragarea);
    setprop("controls/armament/missile/maxExplosionRange", maxExplosionRange);
    setprop("controls/armament/missile/maxspeed", maxspeed);
    setprop("controls/armament/missile/life", life);
    setprop("controls/armament/missile/sdspeed", sdspeed);
    setprop("controls/armament/missile/fox", fox);
    setprop("controls/armament/missile/rail", rail);
    setprop("controls/armament/missile/cruise_alt", cruisealt);
    setprop("controls/armament/missile/type-id", typeid);
    setprop("controls/armament/missile/flareres", flareres);
    setprop("controls/armament/missile/isbomb", isbomb);
    setprop("controls/armament/missile/pbrange", pbrange);
    setprop("controls/armament/missile/multishot", multishot);
    setprop("controls/armament/missile/ignitedelay", ignitedelay);
    return 1;
}


    setprop("controls/armament/missile/pbrange", 0);





print("Loading_Missiles.nas Ready!");
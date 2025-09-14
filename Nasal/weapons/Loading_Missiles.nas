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
    var maxExplosionRange =  0;   # The distance when the missile blows up sorta speak
    var maxspeed          = 0;
    var life              = 0;
    var sdspeed           = 0;
    var fox               = "nothing";  # call Fox 1 if you want to drop like a tank. If you dont youll get a nasal error.  Fox 1 missiles are possible too. If there is a target when launched. But if the radar losses it. it wont hit 
    var rail              = "true";     # If the missile is launched on a rail or not if false the missile is "dropped"
    var cruisealt         = 0;
    var guidance	  = 0;
    var chute         = 1;
    var flareres      = 0;          # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares
    var isbomb        = 0; # if this weapon is a bomb
    var pbrange       = 0; # in meters
    



    
    if(name == "Aim-120")
    {
        # AIM-120 :Advanced Medium Range Missile,      
	    typeid = 52;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/AIM120-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/AIM120-smoke.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        flareres = 0.9900; # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares. Because flares are checked every 0.1 seconds a high number is needed because this variable is sensitve
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
        maxExplosionRange = 20;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 2.8;                              # In mach ( source is a guess )
        life = 110; # 
        sdspeed = 0.65;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = "false";
        cruisealt = 0;
        chute = 0;
        isbomb = 0;
        pbrange = 10000; # added on 
    }

    elsif(name == "Aim-260")
    {
        # AIM-260 JATM!
        # JATM is not in damage.nas :( so itll just be an Aim-54
	    typeid = 52;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-260/AIM260-smoke.xml";
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
        maxExplosionRange = 50;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 5.7;                              # In mach ( source is a guess )
        life = 100000000000; # 
        sdspeed = 0.65;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = "false";
        cruisealt = 75000;
        chute = 0;
        isbomb = 0;
        pbrange = 0;
    }

    elsif(name == "Aim-9x")
    {
        # AIM-9X:short-range A2A,IR seeker,
	    typeid = 98;
        flareres = 0.990; # Flare and chaff resistance. from 0 to 1 (decimals included) The closer to 1. the harder it is for the missile to fall for enemy chaff and flares
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 52;               
        fovdeg = 180;                                 # seeker optical FOV
        detectionfovdeg = 180;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 180;                            # Seeker max total angular rotation
        maxg = 60;                                    # Thurst vectoring rocket motor
        thrustlbs = 500;                             # 
        thrustdurationsec = 2;           
        thrustlbsstage2 = 500;
        thrustdurationsecstage2 = 6.2;             # slowed acceleration seems needed here
        weightlaunchlbs = 246; # launch + fuel, 186 + 60
        weightwarheadlbs = 20.8;
        dragcoeff = 0.08;                              # guess; original 0.05
        dragarea = 0.013;                             # sq ft
        maxExplosionRange = 15;                       
        maxspeed = 3;                               # In Mach
        life = 90;
        fox = "Fox 2";
        rail = "true";
        cruisealt = 0;
        chute = 0;
        sdspeed = 0.01;
        isbomb = 0;
    }
    elsif(name == "Aim-9m")
    {
        # AIM-9m :short-range A2A,IR seeker,
        flareres = 0.85; 
	    typeid = 69; # This is not a Aim-9m this is an Aim-9x with way less homing capabilites. So you can evade it with out the need for flares. just pull a manuver so that its 30deg away from the seeker and there you go   
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9M-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9M.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 85;                                 # Test missile for evading with no countermessures
        detectionfovdeg = 85;                        # Test missile for evading with no countermessures
        trackmaxdeg = 85;                            # Test missile for evading with no countermessures
        maxg = 50;                                    #
        thrustlbs = 2880;            
        thrustdurationsec = 1;       
        thrustlbsstage2 = 2880;
        thrustdurationsecstage2 = 4.2;
        weightlaunchlbs = 246; # laun
        weightwarheadlbs = 20.8;
        dragcoeff = 0.05;                             
        dragarea = 0.075;                             
        maxExplosionRange = 50;                      
        maxspeed = 2.6;                               
        life = 10000; # will self destruct when the missile is slower than  sdspeed and is "armed" (3 seconds pasted sense it shot)
        fox = "Fox 2";
        rail = "true";
        cruisealt = 0;
        chute = 0;
        sdspeed = 0.0;
        isbomb = 0;
    }




    elsif(name == "GBU-39")
    {
           # bomb,
        flareres = 1; # countermessueres cannont fool this. If your radar loosses lock on the target. the missile will miss 
	    typeid = 18;
        address = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        NoSmoke = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 360;                                 # seeker optical FOV
        detectionfovdeg = 360;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 360;                            # Seeker max total angular rotation
        maxg = 4;                                    # 
        thrustlbs = 0.00;                             # 
        thrustdurationsec = 100;                        #
        weightlaunchlbs = 186;
        weightwarheadlbs = 20.8;
        dragcoeff = 0;                              # guess; original 0.05
        dragarea = 0.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 80000000000000;
        fox = "A/G";  
        rail = "true";
        cruisealt = 0;
        sdspeed = 0;
        chute = 0;
        isbomb = 1;  # craters get messy one sec
    }
 elsif(name == "JDAM")
 {
        # Mm yes much bomb,
                              flareres = 1;
	    typeid = 18;
     address = "Aircraft/F-22/Models/Stores/Missiles/JDAM/JDAM.xml"; 
     NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/JDAM/JDAM.xml"; # for now
     Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
     maxdetectionrngnm = 30;                       # 

     #GPS system
     fovdeg = 360;                                 # seeker optical FOV
     detectionfovdeg = 360;                        # Search pattern diameter (rosette scan)
     trackmaxdeg = 360;                            # Seeker max total angular rotation
     maxg = 2;                                    # 
     thrustlbs = 0.00;                             # 
     thrustdurationsec = 100;                        #
     weightlaunchlbs = 186;
     weightwarheadlbs = 1000;
     dragcoeff = 0.05;                              # guess; original 0.05
     dragarea = 0;                             # sq ft
     maxExplosionRange = 50;                       
     maxspeed = 5;                                 # In Mach
     life = 80000000000000;
     fox = "A/G";   
     rail = "true";
     cruisealt = 0;
     sdspeed = 0;
     chute = 0;
     isbomb = 1;
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
        weightlaunchlbs = 4021; # weightlaunch + fuel
        weightwarheadlbs = 44;
        dragcoeff = 0.17;                              # really slow lowerd it a bit
        dragarea = 0.0236;                            # sq ft
        maxExplosionRange = 50;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 5.8;                              # In mach ( source is a guess )
        life = 110; # 
        sdspeed = 0.4999999;                         # Test Self Destruct Speed. in mach
        fox = "Fox 3";
        rail = "false";
        cruisealt = 5000;
        chute = 0;
        isbomb = 0;
    }
    elsif(name == "XMAA") #Debug missile
    {
        
        # fast

        flareres = 1; # hehehe
  	    typeid = 52; # Overridden at the end of missile.nas
        address = "Aircraft/F-22/Models/stores/Missiles/XMAA/XMAA-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/stores/Missiles/XMAA/XMAA.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 150.8;                   #  
        fovdeg = 360;                                #
        detectionfovdeg = 360;                       #  Loop that missile!
        trackmaxdeg = 360;                           # 
        maxg = 1.1;                                  # 
        thrustlbs = 100;                             # 1,500 to 2,5
        thrustlbsstage2 = 2800;
        thrustdurationsec = 5;
        thrustdurationsecstage2 = 18;                      # 
        weightlaunchlbs = 591;                       # Its a bit light
        weightwarheadlbs = 44;                       # to compensate all this coolness it cant be too powerful
        dragcoeff = 0.3;                             # Slows down quick because of the intake
        dragarea = 0.056;                            # sq ft
        maxExplosionRange = 50;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 5.50001;                              # In Mach
        life = 10001;
        fox = "Fox 3";                      # A/G if you want an AGM variant
        rail = "false";
        cruisealt = 12000;     
        chute = 0;
        isbomb = 0;
    }

  elsif(name == "TB-01")
    {
        # This is a dangerous experimental Nasal Deployed bomb
        # see TB01.nas for what happens when this bomb hits the ground!
        # Debug Weapon

        flareres = 1;
	    typeid = 18;
        address = "Aircraft/F-22/Models/Stores/Missiles/TB01/TB01.xml"; 
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/TB01/TB01.xml"; # for now
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
        maxdetectionrngnm = 30;                       # 
        
        # This is a free drop bomb.

        fovdeg = 0;                                 # seeker optical FOV
        detectionfovdeg = 0;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 0;                            # Seeker max total angular rotation
        maxg = 2;                                    # 
        thrustlbs = 0.00;                             # 
        thrustdurationsec = 100;                        #
        weightlaunchlbs = 186;
        weightwarheadlbs = 1000;
        dragcoeff = 0.05;                              # guess; original 0.05
        dragarea = 0.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 80000000000000;
        fox = "Fox 3";    
        rail = "false";
        cruisealt = 0;
        sdspeed = 0; # Weapon self distructs if its slower than mach  0
        chute = 0;
        isbomb = 1;
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
        thrustlbs = 500;                             # 
        thrustdurationsec = 1;                        # 
        weightlaunchlbs = 320;                        # Human + Chair
        weightwarheadlbs = 1;
        dragcoeff = 3;                              # Parachute implementation attempt
        dragarea = 3.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 50;
        fox = "Fox 1"; # call fox 1 then leave it. unguided
        rail = "true";
        cruisealt = 0;
        sdspeed = 0;
        chute = 1;
        isbomb = 0;
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
    return 1;
}


    setprop("controls/armament/missile/pbrange", 0);






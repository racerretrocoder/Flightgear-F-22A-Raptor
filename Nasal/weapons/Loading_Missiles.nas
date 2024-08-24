#print("LOADING Loading_missiles.nas .");
################################################################################
#
#                     F-22  LOADS AND MISSILES PARAMETERS
#Note: these missiles are VERY basic, and curently the only for the radar to work
################################################################################

var Loading_missile = func(name)
{
    var typeid            = 0;
    var address           = "test";
    var NoSmoke           = "test2";
    var Explosion         = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
    var maxdetectionrngnm = 0;
    var fovdeg            = 0;
    var detectionfovdeg   = 0;
    var trackmaxdeg       = 0;
    var maxg              = 0;
    var thrustlbs         = 0;
    var thrustdurationsec =  0;
    var weightlaunchlbs   = 0;
    var dragcoeff         = 0;
    var dragarea          = 0;
    var maxExplosionRange =  0;
    var maxspeed          = 0;
    var life              = 0;
    var fox               = "nothing";
    var rail              = "true";
    var cruisealt         = 0;
    var guidance	  = 0;
    var chute         = 1;
    
    
    if(name == "Aim-120")
    {
        # AIM-120 :Advanced Medium Range Missile,      
	typeid = 52;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/R-27R-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-120/R-27R.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 38.8;                    #  
        fovdeg = 360;                                #
        detectionfovdeg = 360;                       # Due to datalink
        trackmaxdeg = 360;                           # 
        maxg = 30;                                   # 
        thrustlbs = 500;                             # 
        thrustdurationsec = 120;                     # 
        weightlaunchlbs = 291;
        weightwarheadlbs = 44;
        dragcoeff = 0.3;                             # guess; original 0.05
        dragarea = 0.056;                            # sq ft
        maxExplosionRange = 50;                      # in meter ! Due to the code, more the speed is important, more we need to have this figure high
        maxspeed = 8.5;                              # In Mach
        life = 1200;
        fox = "Fox 3";
        rail = "false";
        cruisealt = 0;
        chute = 0;
    }
    elsif(name == "Aim-9x")
    {
        # AIM-9X:short-range A2A,IR seeker,
	typeid = 98;
        address = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9-smoke.xml";
        NoSmoke = "Aircraft/F-22/Models/Stores/Missiles/AIM-9/AIM-9.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosion.xml";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 80;                                 # seeker optical FOV
        detectionfovdeg = 80;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 80;                            # Seeker max total angular rotation
        maxg = 50;                                    # Thurst vectoring rocket motor
        thrustlbs = 1000;                             # 
        thrustdurationsec = 10;                        # To make it miss some times
        weightlaunchlbs = 186;
        weightwarheadlbs = 20.8;
        dragcoeff = 0.8;                              # guess; original 0.05
        dragarea = 0.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 80;
        fox = "Fox 2";
        rail = "true";
        cruisealt = 0;
        chute = 0;
    }
    elsif(name == "GBU-39")
    {
           # Mm yes much bomb,
	    typeid = 18;
        address = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        NoSmoke = "Aircraft/F-22/Models/loads/GBU-39-FLIGHT.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 80;                                 # seeker optical FOV
        detectionfovdeg = 80;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 80;                            # Seeker max total angular rotation
        maxg = 50;                                    # 
        thrustlbs = 0.05;                             # 
        thrustdurationsec = 100;                        #
        weightlaunchlbs = 186;
        weightwarheadlbs = 20.8;
        dragcoeff = 0.01;                              # guess; original 0.05
        dragarea = 0.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 80000000000000;
        fox = "Fox 2";
        rail = "true";
        cruisealt = 0;
        chute = 0;
    }
    elsif(name == "eject")
    {
           # ejection seat   Aircraft/F-22/Models/pilot/eject.xml
	    typeid = 98;
        address = "Aircraft/F-22/Models/pilot/eject.xml";
        NoSmoke = "Aircraft/F-22/Models/pilot/eject.xml";
        Explosion = "Aircraft/F-22/Models/Effects/MissileExplosion/explosionGBU.xml";
        maxdetectionrngnm = 12;                       # Not real Impact yet A little more than the MICA
        fovdeg = 80;                                 # seeker optical FOV
        detectionfovdeg = 80;                        # Search pattern diameter (rosette scan)
        trackmaxdeg = 80;                            # Seeker max total angular rotation
        maxg = 12;                                    # eject
        thrustlbs = 1000;                             # 
        thrustdurationsec = 1;                        # 
        weightlaunchlbs = 330;
        weightwarheadlbs = 20.8;
        dragcoeff = 1;                              # Parachute implementation attempt
        dragarea = 0.075;                             # sq ft
        maxExplosionRange = 50;                       
        maxspeed = 5;                                 # In Mach
        life = 50;
        fox = "Fox 2";
        rail = "true";
        cruisealt = 0;
        chute = 1;
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
    setprop("controls/armament/missile/max-g", maxg);
    setprop("controls/armament/missile/weight-launch-lbs", weightlaunchlbs);
    setprop("controls/armament/missile/thrust-duration-sec", thrustdurationsec);
    setprop("controls/armament/missile/weight-warhead-lbs", weightwarheadlbs);
    setprop("controls/armament/missile/drag-coeff", dragcoeff);
    setprop("controls/armament/missile/drag-area", dragarea);
    setprop("controls/armament/missile/maxExplosionRange", maxExplosionRange);
    setprop("controls/armament/missile/maxspeed", maxspeed);
    setprop("controls/armament/missile/life", life);
    setprop("controls/armament/missile/fox", fox);
    setprop("controls/armament/missile/rail", rail);
    setprop("controls/armament/missile/cruise_alt", cruisealt);
    setprop("controls/armament/missile/type-id", typeid);
    return 1;
}

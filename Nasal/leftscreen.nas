# All code below has been authored by Scarface 1 "Phoenix" (racerretrocoder)
print("leftscreen.nas (namespace: leftscr) Hello!");
# Flightgear F-22A Raptor Left Screen Code


# screen layout for "WARN" page
# This is information and shows warning
# extra small information can be shown aswell


# TEST      TEST      TEST
# TEST      TEST      TEST
# TEST      TEST      TEST
#         [spacer]
#           TEST
#           TEST
#           TEST
#           TEST
#         [spacer]
#         [spacer]
# TEST      TEST      TEST

# (now by properties)

# SL1        R1      SR1 
# SL2        R2      SR2 
# SL3        R3      SR3 
#         [spacer]
#            M1 
#            M2 
#            M3 
#            M4
#         [spacer]
#         [spacer]
# LEFT     CENTER    RIGHT          (button row)

# Orginization
setprop("f22/leftsmall/mode",0);
var screenloop = func() {
    var mode = getprop("f22/leftsmall/mode");

    if (mode == 0) { # Main page. Warning indication.
        # Lets make a small list of warnings, correctable and incorrectable.
        # uncorrectables
        var FLCS = 0;
        var engine = 0; # could be correctable. but still serious.
        var gear = 0;

        var canopy = 0;
        var parkbrake = 0;
        var instrumentation = 0;
        var hook = 0;


        var caution = 0; # Master caution will always be the last spot.
        # use f22/blink for this lol

        # update warning info
        if (getprop("sim/failure-manager/controls/flight/aileron/serviceable") == 0 or getprop("sim/failure-manager/controls/flight/elevator/serviceable") == 0 or getprop("sim/failure-manager/controls/flight/rudder/serviceable") == 0 or getprop("sim/failure-manager/controls/flight/flaps/serviceable") == 0 or getprop("sim/failure-manager/controls/flight/speedbrake/serviceable") == 0) {
            # A flightcontrol failure oucured. 
            print("FLCS Failed!");
            var FLCS = 1;
        }
        if (getprop("sim/failure-manager/engines/engine/serviceable") == 0 or getprop("sim/failure-manager/engines/engine[1]/serviceable") == 0) {
            # A flightcontrol failure oucured. 
            print("Engines Failed!");
            var engine = 1;
        }
        # random logic time!!!1!1!

        if (FLCS == 1) {
            # oh no!!
            setprop("f22/leftsmall/r1","FLCS");
        } elsif (engine == 1 and gear == 0) {
            # engine ded
            setprop("f22/leftsmall/r1","ENGINE");
        } elsif (gear == 1 and engine == 0) {
            setprop("f22/leftsmall/r1","GEAR");
        }

        if (FLCS == 1 and engine == 1 and gear == 0) {
            setprop("f22/leftsmall/r1","ENGINE");
            setprop("f22/leftsmall/r2","FLCS");
        } elsif (FLCS == 1 and engine == 0 and gear == 1) {
            setprop("f22/leftsmall/r1","FLCS");
            setprop("f22/leftsmall/r2","GEAR");
        } elsif (FLCS == 1 and engine == 1 and gear == 1) {
            # whelp.. i guess we dead...
            setprop("f22/leftsmall/r1","FLCS");
            setprop("f22/leftsmall/r2","ENGINE");
            setprop("f22/leftsmall/r3","GEAR");
        } elsif (FLCS == 0 and engine == 1 and gear == 1) {
            # whelp.. i guess we dead...
            setprop("f22/leftsmall/r1","ENGINE");
            setprop("f22/leftsmall/r2","GEAR");
        } elsif (FLCS == 0 and engine == 1 and gear == 0) {
            # whelp.. i guess we dead...
            setprop("f22/leftsmall/r1","ENGINE");
        } elsif (FLCS == 0 and engine == 0 and gear == 1) {
            # whelp.. i guess we dead...
            setprop("f22/leftsmall/r1","GEAR");
        }
    }
}

var startcaution = func() {
    setprop("f22/caution",1);
    print("leftscreen.nas startcaution(): caution given out!");
}

var caution = func() {
    # master caution loop
    # check warnigns, if theres a change. show caution lol
    var r1 = getprop("f22/leftsmall/r1");
    var r2 = getprop("f22/leftsmall/r2");
    var r3 = getprop("f22/leftsmall/r3");
    var m1 = getprop("f22/leftsmall/m1");
    var m2 = getprop("f22/leftsmall/m2");
    var m3 = getprop("f22/leftsmall/m3");
    var m4 = getprop("f22/leftsmall/m4");

    var oldr1 = getprop("f22/leftsmall/old/r1");
    var oldr2 = getprop("f22/leftsmall/old/r2");
    var oldr3 = getprop("f22/leftsmall/old/r3");
    var oldm1 = getprop("f22/leftsmall/old/m1");
    var oldm2 = getprop("f22/leftsmall/old/m2");
    var oldm3 = getprop("f22/leftsmall/old/m3");
    var oldm4 = getprop("f22/leftsmall/old/m4");
    # if statements.
    # warnings
    if (r1 != oldr1 and r1 != "ae"){
        setprop("f22/leftsmall/old/r1",r1);
        startcaution();
    }
    if (r2 != oldr2 and r2 != "ae"){
        setprop("f22/leftsmall/old/r2",r2);
        startcaution();
    }
    if (r3 != oldr3 and r3 != "ae"){
        setprop("f22/leftsmall/old/r3",r3);
        startcaution();
    }
    # cautions
    if (m1 != oldm1 and m1 != "ae"){
        setprop("f22/leftsmall/old/m1",m1);
        startcaution();
    }
    if (m2 != oldm2 and m2 != "ae"){
        setprop("f22/leftsmall/old/m2",m2);
        startcaution();
    }
    if (m3 != oldm3 and m3 != "ae"){
        setprop("f22/leftsmall/old/m3",m3);
        startcaution();
    }
    if (m4 != oldm4 and m4 != "ae"){
        setprop("f22/leftsmall/old/m4",m4);
        startcaution();
    }
}


looptimer = maketimer(0.5,screenloop);
cautionloop = maketimer(0.5,caution);

var start = func() {
    # start code
    cautionloop.start();
    looptimer.start();
    print("leftscreen.nas (namespace: lefscr) Screen loops started!");
}

var clear = func() {
    setprop("f22/leftsmall/old/r1","");
    setprop("f22/leftsmall/old/r2","");
    setprop("f22/leftsmall/old/r3","");
    setprop("f22/leftsmall/old/m1","");
    setprop("f22/leftsmall/old/m2","");
    setprop("f22/leftsmall/old/m3","");
    setprop("f22/leftsmall/old/m4","");
    setprop("f22/leftsmall/r1","");
    setprop("f22/leftsmall/r2","");
    setprop("f22/leftsmall/r3","");
    setprop("f22/leftsmall/m1","");
    setprop("f22/leftsmall/m2","");
    setprop("f22/leftsmall/m3","");
    setprop("f22/leftsmall/m4","");
    leftscr.ackwarn();
}

var ackwarn = func() {
    setprop("f22/caution",0);
}

print("leftscreen.nas (namespace: lefscr) I am ready!");
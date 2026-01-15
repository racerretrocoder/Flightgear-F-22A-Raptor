# All code below has been authored by Scarface 1 "Phoenix" (racerretrocoder)
print("leftscreen.nas (namespace: leftscr) Hello!");
# Flightgear F-22A Raptor Left Screen Code
# Left screen initalization.
setprop("f22/leftsmall/sl1","UHF 1");
setprop("f22/leftsmall/sl2","");
setprop("f22/leftsmall/sl3","");
setprop("f22/leftsmall/sr1","UHF 2");
setprop("f22/leftsmall/sr2","");
setprop("f22/leftsmall/sr3","");
setprop("f22/leftsmall/m1","");
setprop("f22/leftsmall/m2","");
setprop("f22/leftsmall/m3","");
setprop("f22/leftsmall/m4","");
setprop("f22/leftsmall/m5","");
setprop("f22/leftsmall/m6","");
setprop("f22/leftsmall/r1","");
setprop("f22/leftsmall/r2","");
setprop("f22/leftsmall/r3","");
setprop("f22/leftsmall/r4","");
setprop("f22/leftsmall/r5","");
setprop("f22/leftsmall/r6","");

setprop("f22/leftsmall/old/m1","");
setprop("f22/leftsmall/old/m2","");
setprop("f22/leftsmall/old/m3","");
setprop("f22/leftsmall/old/m4","");
setprop("f22/leftsmall/old/m5","");
setprop("f22/leftsmall/old/m6","");
setprop("f22/leftsmall/old/r1","");
setprop("f22/leftsmall/old/r2","");
setprop("f22/leftsmall/old/r3","");
setprop("f22/leftsmall/old/r4","");
setprop("f22/leftsmall/old/r5","");
setprop("f22/leftsmall/old/r6","");
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
setprop("f22/leftsmall/buttons/textcenter","CLEAR");
setprop("f22/leftsmall/buttons/textleft","ACK");
setprop("f22/leftsmall/buttons/textright","");
setprop("f22/leftsmall/mode",0); # 0 warn page, 1 standard, 2 target info




var screenloop = func() {
    var mode = getprop("f22/leftsmall/mode");

    if (mode == 0) { # Main page. Warning indication.
        # Lets make a small list of warnings, correctable and incorrectable.
        # uncorrectables
        var FLCS = 0;
        var engine = 0; # could be correctable. but still serious.
        var gear = 0;
        var oilp = 0;   
        var canopy = 0;
        var parkbrake = 0;
        var instrumentation = 0;
        var hook = 0;
        var gen1 = 0;
        var gen2 = 0;


        var caution = 0; # Master caution will always be the last spot.
        # use f22/blink for this lol

        # update warning info
        if (getprop("fdm/jsbsim/fcs/engine-gen") == 0) {
            var gen1 = 1;
        }
        if (getprop("fdm/jsbsim/fcs/engine-gen2") == 0) {
            var gen2 = 1;
        }
        if (getprop("fdm/jsbsim/fcs/oil-warn") == 0) {
            var oilp = 1;
        } 

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
        if (getprop("canopy/position-norm") != 0) {
            var canopy = 1;
        }

        # random logic time!!!1!1!



        if (FLCS == 1) {
            setprop("f22/leftsmall/r1","FLCS");
        }
        if (engine == 1) {
            setprop("f22/leftsmall/r2","ENGINE");
        } elsif (oilp == 1) {
            setprop("f22/leftsmall/r2","OIL PRESS");
        } else {
            setprop("f22/leftsmall/r2","");
        }
        if (gen1 == 1) {
            setprop("f22/leftsmall/r3","L GEN");
        } else {
            setprop("f22/leftsmall/r3","");
        }
        if (gen2 == 1) {
            setprop("f22/leftsmall/r4","R GEN");
        } else {
            setprop("f22/leftsmall/r4","");
        }
        if (canopy == 1) {
            setprop("f22/leftsmall/m1","CANOPY");
        } else {
            setprop("f22/leftsmall/m1","");
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
    var r4 = getprop("f22/leftsmall/r4");
    var m1 = getprop("f22/leftsmall/m1");
    var m2 = getprop("f22/leftsmall/m2");
    var m3 = getprop("f22/leftsmall/m3");
    var m4 = getprop("f22/leftsmall/m4");

    var oldr1 = getprop("f22/leftsmall/old/r1");
    var oldr2 = getprop("f22/leftsmall/old/r2");
    var oldr3 = getprop("f22/leftsmall/old/r3");
    var oldr4 = getprop("f22/leftsmall/old/r4");
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
    if (r4 != oldr4 and r4 != "ae"){
        setprop("f22/leftsmall/old/r4",r4);
        startcaution();
    }
    if (r1 == "" and r2 == "" and r3 == "" and r4 == "" and m1 == "" and m2 == "" and m3 == "" and m4 == "") {
        leftscr.ackwarn();
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
    setprop("f22/leftsmall/old/r4","");
    setprop("f22/leftsmall/old/m1","");
    setprop("f22/leftsmall/old/m2","");
    setprop("f22/leftsmall/old/m3","");
    setprop("f22/leftsmall/old/m4","");
    setprop("f22/leftsmall/r1","");
    setprop("f22/leftsmall/r2","");
    setprop("f22/leftsmall/r3","");
    setprop("f22/leftsmall/r4","");
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
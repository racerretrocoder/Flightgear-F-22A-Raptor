# Phoenix
# Built in tests for the F-22A
# bits.nas
# namespace bits

setprop("controls/flight/bit",1); # Switch
setprop("controls/radar/bit",0);
setprop("controls/flight/bitprogress",0); # progress
var bit = func() {
    var flcs = getprop("controls/flight/bit");
    var bitprog = getprop("controls/flight/bitprogress");
    if (flcs == 0) {
        setprop("controls/flight/bit",1);
        if (bitprog != 0) {
            screen.log.write("FLCS BIT stopped. Results written to DTC",0,1,0);
            setprop("controls/flight/bitprogress",0);
        }
        
    }
    if (flcs == 2) {
        setprop("controls/flight/bit",2);
        setprop("controls/flight/bitprogress",getprop("controls/flight/bitprogress") + 0.5);
        if (bitprog == 1) {
            print("FLCS: BIT starting...");
            screen.log.write("FLCS BIT Started.",1,1,1);
        }     
        if (bitprog == 2) {
            print("FLCS: Checking FADEC...");
            print("FLCS: FADEC Online");
        }
        if (bitprog == 3) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",-1);
        }
        if (bitprog == 4) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",1);
        }
        if (bitprog == 5) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",1);
        }
        if (bitprog == 6) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",-1);
        }
        if (bitprog == 7) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",1);
        }
        if (bitprog == 8) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",-1);
        }
        if (bitprog == 9) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",0);
        }
        if (bitprog == 10) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",1);
            setprop("controls/flight/aileron",1);
            setprop("controls/flight/rudder",1);
        }
        if (bitprog == 11) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",-1);
            setprop("controls/flight/aileron",-1);
            setprop("controls/flight/rudder",-1);
        }
        if (bitprog == 12) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",0);
        }
        if (bitprog == 13) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",0);
            setprop("controls/flight/speedbrake",1);
        }
        if (bitprog == 13) {
            print("FLCS: Checking controls");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",0);
            setprop("controls/flight/speedbrake",0);
        }
        if (bitprog == 14) {
            print("FLCS: BIT Complete!");
            setprop("controls/flight/elevator",0);
            setprop("controls/flight/aileron",0);
            setprop("controls/flight/rudder",0);
            setprop("controls/flight/speedbrake",0);
            setprop("controls/flight/bit",0);
            screen.log.write("FLCS BIT Complete. No errors",0,1,0);
        }
    }
}

ae = maketimer(1,bit);
ae.start();
setprop("datalinkhacker/callsign","");
setprop("datalinkhacker/channel",0);
setprop("datalinkhacker/hackedcode",0);
setprop("datalinkhacker/solved",0);
var stop = func {
    setprop("datalinkhacker/channel",0);
    setprop("datalinkhacker/solved",0);
    hacktimer.stop();
}

var start = func {
    setprop("datalinkhacker/channel",0);
    setprop("datalinkhacker/solved",0);
    screen.log.write("Hacking into target Datalink... Please wait...",0,1,0);
    setprop("instrumentation/datalink/channel",0);
    hacktimer.start();
}

var hackloop = func {
    var solved = getprop("datalinkhacker/solved");
    var code = getprop("datalinkhacker/channel");
    if (code == 9999 and solved == 0) {
        screen.log.write("Failed the hack the datalink of the selected target!",1,0,0);
        setprop("datalinkhacker/channel",0);
        setprop("datalinkhacker/solved",-1);
        dlinkhack.stop();

    }
    
    var reccall = getprop("datalinkhacker/callsign");
    var total = 1000;
    var data = datalink.get_data(reccall); # get our data
    if (data != nil) {
        if (data.on_link() != nil) {
            print("HACKED!");
            screen.log.write("Successfully hacked into the datalink of the target!",0,1,0);
            print(code-1);
            screen.log.write(code-1,1,1,1);
            setprop("datalinkhacker/solved",1);
            setprop("datalinkhacker/hackedcode",code-1);
            dlinkhack.stop();
        }
    } else {
        print("This code didnt work: ",code);
        setprop("datalinkhacker/channel",code + 1);
        setprop("instrumentation/datalink/channel",code);
    }
}

hacktimer = maketimer(0,hackloop);
print("datalink hacker, ready. hack.nas");


var fakethreat = func {
    var sig1 = getprop("enemies/e0");
    var sig2 = getprop("enemies/e1");
    var sig3 = getprop("enemies/e2");
    var sig4 = getprop("enemies/e3");
    var sig5 = getprop("enemies/e4"); 
    var sig6 = getprop("enemies/e5");
    var sig7 = getprop("enemies/e6");
    var sig8 = getprop("enemies/e7");
    var sig9 =  getprop("enemies/e8");
    var sig10 = getprop("enemies/e9");
    var sig11 = getprop("enemies/e10");
    var sig12 = getprop("enemies/e11");
    var sig13 = getprop("enemies/e12");
    var sig14 = getprop("enemies/e13");
    var sig15 = getprop("enemies/e14");
    var sig16 = getprop("enemies/e15");
    datalink.send_data({"contacts":[{"callsign": sig1,"iff":0},{"callsign": sig2, "iff":0},{"callsign": sig3, "iff":0},{"callsign": sig4, "iff":0},{"callsign": sig5, "iff":0},{"callsign": sig6, "iff":0},{"callsign": sig7, "iff":0},{"callsign": sig8, "iff":0},{"callsign": sig9,"iff":0},{"callsign": sig10, "iff":0},{"callsign": sig11, "iff":0},{"callsign": sig12, "iff":0},{"callsign": sig13, "iff":0},{"callsign": sig14, "iff":0},{"callsign": sig15, "iff":0},{"callsign": sig16, "iff":0}]},timeout=nil);
    awacs.update(mpid,tgtcallsig);
    setprop("sim/multiplay/visibility-range-nm",2000);
}
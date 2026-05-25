# Phoenix
# Calculator Thingy

setprop("calculator/manuverability/turn-rate",0);
setprop("calculator/manuverability/turn-rate-max",0);
setprop("calculator/manuverability/pitch-rate-max",0);
setprop("calculator/manuverability/roll-rate-max",0);
setprop("calculator/manuverability/heading-rate-deg",0);
setprop("calculator/manuverability/old-heading",0);
var calc = func() {
    var pitch = getprop("orientation/pitch-rate-degps");
    var roll = getprop("orientation/roll-rate-degps");
    var heading = getprop("orientation/heading-deg"); # new
    var oldheading = getprop("calculator/manuverability/old-heading"); # previous
    # calculate turn rate
    if (heading > oldheading) {
        # heading increased,
        var turnrate = heading - oldheading;
        # since this is every 0.1 seconds, multiplay by 10
        turnrate = turnrate * 10;
        print("Turnrate: ",turnrate);
        setprop("calculator/manuverability/old-heading",heading);
    }
    if (heading < oldheading) {
        # heading decreased,
        var turnrate = oldheading - heading;
        # since this is every 0.1 seconds, multiplay by 10
        turnrate = turnrate * 10;
        print("Turnrate: ",turnrate);
        setprop("calculator/manuverability/old-heading",heading);
    }
    setprop("calculator/manuverability/turn-rate",turnrate);
}

calctimer = maketimer(0.1,calc);

var start = func() {
    calctimer.start();
    screen.property_display.add("/calculator/manuverability/turn-rate");
    screen.property_display.add("/orientation/pitch-rate-degps");
    screen.property_display.add("/orientation/roll-rate-degps");
}

var stop = func() {
    calctimer.stop();
}
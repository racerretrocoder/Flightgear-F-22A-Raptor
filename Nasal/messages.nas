# messages.nas
# namespace: tips
# This is a simple messages/tips system for any aircraft really
# It helps the user fly the plane better and not mess anything up
# Like when a user forgets to bring there landing gear up. a reminder will show
# All code written by Phoenix
print("messages.nas: INIT");

var wheelmaxspeed = 250;
var geardownmaxspeed = 300;
var vne = 990;
var enabled = getprop("messages/enabled") or 1;


var mainloop = func() {
    # first check airspeed
    if (enabled != 1) {
        looptimer.stop();
        return 0;
    }
    print("MAINLOOP");
    if (getprop("velocities/airspeed-kt") > vne) {
        screen.log.write("Airspeed Exceeds Vne! ("~vne~")",1,0,0);
        return 0;
    }
    # check wheel speed
    if (getprop("velocities/airspeed-kt") > wheelmaxspeed and getprop("gear/gear/wow") == 1) {
        screen.log.write("Maximum speed for wheels exceeded! ("~wheelmaxspeed~")",1,0,0);
        return 0;
    } 
    # check gear speed
    if (getprop("velocities/airspeed-kt") > geardownmaxspeed and getprop("controls/gear/gear-down") == 1) {
        screen.log.write("The landing gear could break! Raise the gear! (press g)",1,0,0);
        return 0;
    }
}


print("messages.nas: Ready");

looptimer = maketimer(2,mainloop);
looptimer.start();
# smallscreens.nas
# Raptor's Small screen controller
# Phoenix
setprop("controls/small-screens/rightscreen/mode",1);

var changemoderight = func() {
    var mode = getprop("controls/small-screens/rightscreen/mode");
    if (mode == 1) {
        setprop("controls/small-screens/rightscreen/mode",2);
    } elsif (mode == 2) {
        setprop("controls/small-screens/rightscreen/mode",3);
    } elsif (mode == 3) {
        setprop("controls/small-screens/rightscreen/mode",1);
    }
}
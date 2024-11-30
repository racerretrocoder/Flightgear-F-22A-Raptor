print("Loading Front Controls...");

# Front controls numpad system
# Made by Phoenix



var digit1 = nil;
var digit2 = nil;
var digit3 = nil;
var digit4 = nil;
var digit5 = nil;
var digit6 = nil;

# Buttons
# Left row from bottom to top

var setnum = func(num){

if (digit1 == nil) {
setprop("instrumentation/frontcontrols/digit1", num);
digit1 = num;
} elsif (digit2 == nil) {
setprop("instrumentation/frontcontrols/digit2", num);
digit2 = num;
} elsif (digit3 == nil) {
setprop("instrumentation/frontcontrols/digit3", num);
digit3 = num;
} elsif (digit4 == nil) {
setprop("instrumentation/frontcontrols/digit4", num);
digit4 = num;
} elsif (digit5 == nil) {
setprop("instrumentation/frontcontrols/digit5", num);
digit5 = num;
} elsif (digit6 == nil) {
setprop("instrumentation/frontcontrols/digit6", num);
digit6 = num;
}

}

var clearnum = func{

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);
print("clear");

}

var addtocomm1 = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
} elsif (digit5 == nil) {
digit5 = 0;
} elsif (digit6 == nil) {
digit6 = 0;
}


var num1 = digit1 * 100000;
var num2 = digit2 * 10000;
var num3 = digit3 * 1000;
var num4 = digit4 * 100;
var num5 = digit5 * 10;
var num6 = digit6 * 1;

var numfinal = num1 + num2 + num3 + num4 + num5 + num6;
print(numfinal);

setprop("instrumentation/comm[0]/frequencies/standby-mhz", numfinal / 1000);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}

var addtocomm2 = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
} elsif (digit5 == nil) {
digit5 = 0;
} elsif (digit6 == nil) {
digit6 = 0;
}


var num1 = digit1 * 100000;
var num2 = digit2 * 10000;
var num3 = digit3 * 1000;
var num4 = digit4 * 100;
var num5 = digit5 * 10;
var num6 = digit6 * 1;

var numfinal = num1 + num2 + num3 + num4 + num5 + num6;
print(numfinal);

setprop("instrumentation/comm[1]/frequencies/standby-mhz", numfinal / 1000);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}


# Swap functions


var swapc1 = func{

setprop("instrumentation/frontcontrols/c1a", getprop("instrumentation/comm[0]/frequencies/selected-mhz"));
setprop("instrumentation/frontcontrols/c1b", getprop("instrumentation/comm[0]/frequencies/standby-mhz"));

var stdby = getprop("instrumentation/frontcontrols/c1b");
var active = getprop("instrumentation/frontcontrols/c1a");

setprop("instrumentation/comm[0]/frequencies/selected-mhz", stdby);
setprop("instrumentation/comm[0]/frequencies/standby-mhz", active);

}

var swapc2 = func{

setprop("instrumentation/frontcontrols/c2a", getprop("instrumentation/comm[1]/frequencies/selected-mhz"));
setprop("instrumentation/frontcontrols/c2b", getprop("instrumentation/comm[1]/frequencies/standby-mhz"));

var stdby = getprop("instrumentation/frontcontrols/c2b");
var active = getprop("instrumentation/frontcontrols/c2a");

setprop("instrumentation/comm[1]/frequencies/selected-mhz", stdby);
setprop("instrumentation/comm[1]/frequencies/standby-mhz", active);

}
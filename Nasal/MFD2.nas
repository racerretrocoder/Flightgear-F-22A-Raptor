print("Loading Center MFD...");

# Center MFD System
# Made by Phoenix

# Page checker
# What MFD page are we on





# Buttons
# Left row from bottom to top

var CL1 = func{

var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CL2 = func{

var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}


}
var CL3 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CL4 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
    # Decrease Radar Range
    var rng = getprop("instrumentation/radar/range");

# 10,20,40,60,160

if (rng == 10) {
print("Cant decrease range. its at its lowest");

} elsif (rng == 20){
    # Increase it
    radar.RangeSelected.setValue(10);
    setprop("instrumentation/radar/range", 10);

} elsif (rng == 40){
    # Increase it
    radar.RangeSelected.setValue(20);
    setprop("instrumentation/radar/range", 20);

} elsif (rng == 60){
    # Increase it
    radar.RangeSelected.setValue(40);
    setprop("instrumentation/radar/range", 40);

} elsif (rng == 160){
    radar.RangeSelected.setValue(60);
    setprop("instrumentation/radar/range", 60);
}

} elsif (pg == 1){
    print(pg);   
#
#   Sms 
#





var id = getprop("controls/armament/selected-weapon-digit");



if (id == 1) { # If were currently an AAM
# GBU
setprop("controls/armament/selected-weapon", "GBU-39");
setprop("controls/armament/selected-weapon-digit", 3);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 1); # Open the doors
setprop("/controls/missile", 3);


} elsif (id == 2){ # If were currently a different AAM
# GBU
setprop("controls/armament/selected-weapon", "GBU-39");
setprop("controls/armament/selected-weapon-digit", 3);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 1); # Open the doors
setprop("/controls/missile", 3);
}
# var msl = getprop("controls/armament/selected-weapon");

elsif (id == 4) { # Were currently a JDAM
setprop("controls/armament/selected-weapon", "GBU-39");
setprop("controls/armament/selected-weapon-digit", 3);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 1);
setprop("/controls/missile", 3);


} elsif (id == 3){ # Were currently a GBU-39

setprop("controls/armament/selected-weapon", "JDAM");
setprop("controls/armament/selected-weapon-digit", 4);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 1);
setprop("/controls/missile", 3);

}    


} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}



var CL5 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {


    print(pg);
    # Increase Radar Range
    var rng = getprop("instrumentation/radar/range");

# 10,20,40,60,160

if (rng == 10) {
    # Increase it
    radar.RangeSelected.setValue(20);
    setprop("instrumentation/radar/range", 20);

} elsif (rng == 20){
    # Increase it
    radar.RangeSelected.setValue(40);
    setprop("instrumentation/radar/range", 40);

} elsif (rng == 40){
    # Increase it
    radar.RangeSelected.setValue(60);
    setprop("instrumentation/radar/range", 60);

} elsif (rng == 60){
    # Increase it
    radar.RangeSelected.setValue(160);
    setprop("instrumentation/radar/range", 160);

} elsif (rng == 160){

print("Radar range at max. Cant increase it"); 
}



} elsif (pg == 1){

#
#  Sms
#
    print(pg);





var msl = getprop("controls/armament/selected-weapon");

if (msl == "Aim-120") {
# 9x
setprop("controls/armament/selected-weapon", "Aim-9x");
setprop("controls/armament/selected-weapon-digit", 1);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 0);
setprop("/controls/missile", 3);


} elsif (msl == "Aim-9x"){
# 120

setprop("controls/armament/selected-weapon", "Aim-120");
setprop("controls/armament/selected-weapon-digit", 2);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 0);
setprop("/controls/missile", 3);

} elsif (msl != nil){ # Our selected weapon is not an AAM
# set it to aim120

setprop("controls/armament/selected-weapon", "Aim-120");
setprop("controls/armament/selected-weapon-digit", 2);
screen.log.write("Selected " ~ getprop("controls/armament/selected-weapon"),0.5,0.5,1);
setprop("/controls/baydoors/AIM120", 0);
setprop("/controls/missile", 3);

}   





    
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}


# Right row

var CR1 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CR2 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CR3 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CR4 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
    # Change grid mode.
    var grid = getprop("instrumentation/radar/grid");
    print(grid);
    if(grid == 1)
    {
    setprop("instrumentation/radar/grid", 0); # turn off the grid
    }
    elsif(grid == 0)
    {
    setprop("instrumentation/radar/grid", 1); # Turn on the grid
    }

} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
var CR5 = func{
var pg = getprop("systems/MFD/modemfdc");
# 2 FCR
# 1 SMS
# 3 WEP
# 4 FLT
# 5 RWR

if (pg == 2) {
    print(pg);
    radar.radar_mode_toggle();
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}
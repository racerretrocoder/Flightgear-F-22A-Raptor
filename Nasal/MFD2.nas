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
}elsif (pg == 9){
setprop("controls/CMS/prgmselected",5);

} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    screen.log.write("Switched Bombs back to radar slave mode");
    setprop("controls/radar/weaponcoords", 0);
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",2);
}
elsif (pg == 9){
setprop("controls/CMS/prgmselected",4);

}
elsif (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
   screen.log.write("Set Coords to the Current Weapon(s)!");   
   var slottype = getprop("controls/radar/currentslot");
   var lat = getprop("controls/radar/slot[" ~ slottype ~ "]/lat");
   var lon = getprop("controls/radar/slot[" ~ slottype ~ "]/lon"); 
   var alt = getprop("controls/radar/slot[" ~ slottype ~ "]/alt"); 
   setprop("controls/radar/weaponcoords", 1);
   setprop("controls/radar/gpslock/lat", lat); 
   setprop("controls/radar/gpslock/lon", lon); 
   setprop("controls/radar/gpslock/alt", alt); 
    radar.RangeSelected.setValue(0);
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",1);
}

if (pg == 1) {
    print(pg);
    setprop("systems/MFD/modemfdc",9);
}

elsif (pg == 9){
setprop("controls/CMS/prgmselected",3);
}

elsif (pg == 2) {
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",6);
}
elsif (pg == 9){
setprop("controls/CMS/prgmselected",2);
}
elsif (pg == 8) {
    # PRF Decrease
    print(pg);
    # DeLRease Radar Range
    var rng = getprop("controls/PRF/range");
# 10,20,40,60,160,300
if (rng == 5){
    print("Cant decrease it anymore");
}
elsif (rng == 10) {
    setprop("controls/PRF/range", 5);
} elsif (rng == 20){
    # InLRease it
    setprop("controls/PRF/range", 10);
} elsif (rng == 40){
    # InLRease it
    setprop("controls/PRF/range", 20);
} elsif (rng == 60){
    # InLRease it
    setprop("controls/PRF/range", 40);
} elsif (rng == 160){
    setprop("controls/PRF/range", 60);
} elsif (rng == 300){
    setprop("controls/PRF/range", 160);
}
}
elsif (pg == 2) {
    print(pg);
    # Decrease Radar Range
    var rng = getprop("instrumentation/radar/range");

# 10,20,40,60,160
if (rng == 5){
    print("Cant decrease it anymore");
}
elsif (rng == 10) {
    radar.RangeSelected.setValue(5);
    setprop("instrumentation/radar/range", 5);

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
} elsif (rng == 300){
    radar.RangeSelected.setValue(160);
    setprop("instrumentation/radar/range", 160);
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",7);
}

elsif (pg == 9){
setprop("controls/CMS/prgmselected",1);
}
elsif (pg == 8) {
    # PRF Decrease
    print(pg);
    # DeLRease Radar Range
    var rng = getprop("controls/PRF/range");
# 10,20,40,60,160,300
if (rng == 5){
    setprop("controls/PRF/range", 10);
}
elsif (rng == 10) {
    setprop("controls/PRF/range", 20);
} elsif (rng == 20){
    # InLRease it
    setprop("controls/PRF/range", 40);
} elsif (rng == 40){
    # InLRease it
    setprop("controls/PRF/range", 60);
} elsif (rng == 60){
    # InLRease it
    setprop("controls/PRF/range", 160);
} elsif (rng == 160){
    setprop("controls/PRF/range", 300);
} elsif (rng == 300){
    setprop("controls/PRF/range", 300);
}
}


elsif (pg == 2) {


    print(pg);
    # Increase Radar Range
    var rng = getprop("instrumentation/radar/range");

# 10,20,40,60,160
if (rng == 5) {
    # InRRease it
    radar.RangeSelected.setValue(10);
    setprop("instrumentation/radar/range", 10);

}
elsif (rng == 10) {
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

radar.RangeSelected.setValue(300);
    setprop("instrumentation/radar/range", 300);

} elsif (rng == 300){
print("Radar range at max. Cant inLRease it"); 
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

if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",5);
}
elsif (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
    print(pg);   
    print("Attempting to save coords to a slot");
    if (getprop("instrumentation/frontcontrols/digit1") == 0) {
        print("Not ready!");
        screen.log.write("Enter a number on the keypad to select a slot to save coord data to. then press this button to write to that slot");
        return;
    }
    print("read it");
    var slottype = getprop("instrumentation/frontcontrols/digit1");
    var lat = getprop("controls/radar/datarec/lat");
    var lon = getprop("controls/radar/datarec/lon"); 
    var alt = getprop("controls/radar/datarec/alt"); 
    setprop("controls/radar/slot[" ~ slottype ~ "]/lat", lat); 
    setprop("controls/radar/slot[" ~ slottype ~ "]/lon", lon); 
    setprop("controls/radar/slot[" ~ slottype ~ "]/alt", alt); 
    screen.log.write("Successfully saved data to slot "~ slottype);
setprop("controls/radar/currentslot", getprop("instrumentation/frontcontrols/digit1"));
var slottype = getprop("controls/radar/currentslot");

    var lat = getprop("controls/radar/slot[" ~ slottype ~ "]/lat");
    var lon = getprop("controls/radar/slot[" ~ slottype ~ "]/lon"); 
    var alt = getprop("controls/radar/slot[" ~ slottype ~ "]/alt"); 
    setprop("controls/radar/slots/lat", lat); 
    setprop("controls/radar/slots/lon", lon); 
    setprop("controls/radar/slots/alt", alt); 
    screen.log.write("Switched to slot "~ slottype);
    fc.clearnum();
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",3);
}
elsif (pg == 2) {
    print(pg);
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
    print(pg);
    # send datalink of locked threat
    var lat = getprop("controls/radar/slots/lat");
    var lon = getprop("controls/radar/slots/lon");
    var alt = getprop("controls/radar/slots/alt");
        fc.send(fc.coordsetup(lat,lon,alt));
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
if (pg == 0) {
    print(pg);
    setprop("systems/MFD/modemfdc",4);
}
elsif (pg == 2) {
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
    print("pressed");
    if (getprop("instrumentation/frontcontrols/digit1") == 0) {
        print("Not ready!");
        screen.log.write("Enter a number on the keypad for your slot then press this button to read it and set it to the weapon");
        return;
    }
    print("read it");
setprop("controls/radar/currentslot", getprop("instrumentation/frontcontrols/digit1"));
var slottype = getprop("controls/radar/currentslot");

    var lat = getprop("controls/radar/slot[" ~ slottype ~ "]/lat");
    var lon = getprop("controls/radar/slot[" ~ slottype ~ "]/lon"); 
    var alt = getprop("controls/radar/slot[" ~ slottype ~ "]/alt"); 
    setprop("controls/radar/slots/lat", lat); 
    setprop("controls/radar/slots/lon", lon); 
    setprop("controls/radar/slots/alt", alt); 
    screen.log.write("Successfully read data from slot "~ slottype);
    fc.clearnum();
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
}elsif (pg == 6){
    print(pg);   
    if (getprop("instrumentation/frontcontrols/digit1") == 0) {
        print("Not ready!");
        screen.log.write("Enter the ammount on the keypad then press this button to set bingo fuel");
        return;
    }
    fc.setbingo();
} elsif (pg == 1){
    print(pg);   
} elsif (pg == 3){
    print(pg);   
   var callsign = radar.tgts_list[radar.Target_Index].Callsign.getValue();
    var mpid = misc.smallsearch(callsign);
    var lat = getprop("ai/models/multiplayer[" ~ mpid ~ "]/position/latitude-deg");
    var lon = getprop("ai/models/multiplayer[" ~ mpid ~ "]/position/longitude-deg");
    var alt = getprop("ai/models/multiplayer[" ~ mpid ~ "]/position/altitude-ft");
    setprop("controls/radar/datarec/lat", lat);
    setprop("controls/radar/datarec/lon", lon);
    setprop("controls/radar/datarec/alt", alt);
} elsif (pg == 4){
    print(pg);   
} elsif (pg == 5){
    print(pg);   
}

}

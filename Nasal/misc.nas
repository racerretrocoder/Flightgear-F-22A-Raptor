# Ai "Searcher"
# Created by Phoenix, Skid, and Uapilot
#
# This script is used to search for another pilots properties (Mainly the rotor prop)
# it can be used for counter messure detection. and more.


# Skid

# Search Funtion V2
# The way i want this to work is you input it a callsign misc.search("Skid"); then itll search ai/models/multiplayer for Skid
# If it finds what we want. That will check out successfully, then itll read from the ID of our MP target and see if our target is flaring or not. via the rotors prop 
# Its kinda like Phoenix's Lockhelper.nas But expanded apon

var search = func(cs){

 var mp0 = getprop("/ai/models/multiplayer[0]/callsign");
 var mp1 = getprop("/ai/models/multiplayer[1]/callsign");
 var mp2 = getprop("/ai/models/multiplayer[2]/callsign");
 var mp3 = getprop("/ai/models/multiplayer[3]/callsign");
 var mp4 = getprop("/ai/models/multiplayer[4]/callsign");
 var mp5 = getprop("/ai/models/multiplayer[5]/callsign");
 var mp6 = getprop("/ai/models/multiplayer[6]/callsign");
 var mp7 = getprop("/ai/models/multiplayer[7]/callsign");
 var mp8 = getprop("/ai/models/multiplayer[8]/callsign");
 var mp9 = getprop("/ai/models/multiplayer[9]/callsign");
var mp10 = getprop("/ai/models/multiplayer[10]/callsign");
var mp11 = getprop("/ai/models/multiplayer[11]/callsign");
var mp12 = getprop("/ai/models/multiplayer[12]/callsign");
var mp13 = getprop("/ai/models/multiplayer[13]/callsign");
var mp14 = getprop("/ai/models/multiplayer[14]/callsign");
var mp15 = getprop("/ai/models/multiplayer[15]/callsign");
var mp16 = getprop("/ai/models/multiplayer[16]/callsign");
var mp17 = getprop("/ai/models/multiplayer[17]/callsign");
var mp18 = getprop("/ai/models/multiplayer[18]/callsign");

# Up to 18 + 1 targets at once (Not including ourselfs).
# Now lets look through it
# Mm yes if then statement time

    if(mp0 == cs) # If our request callsign is the callsign on Multiplayer[0]; set 0 as our ID then run a function called tracked with a parameter that consists of 0.
    {

        var tracked = 0;
        track(tracked);

    }

 else if(mp1 == cs)
    {

        var tracked = 1;
        track(tracked);

    }

       else if(mp2 == cs)
    {

        var tracked = 2;
        track(tracked);

    }

       else if(mp3 == cs)
    {

        var tracked = 3;
        track(tracked);

    }

       else if(mp4 == cs)
    {

        var tracked = 4;
        track(tracked);

    }

       else if(mp5 == cs)
    {

        var tracked = 5;
        track(tracked);

    }

       else if(mp6 == cs)
    {

        var tracked = 6;
        track(tracked);

    }

       else if(mp7 == cs)
    {

        var tracked = 7;
        track(tracked);

    }

       else if(mp8 == cs)
    {

        var tracked = 8;
        track(tracked);

    }

       else if(mp9 == cs)
    {

        var tracked = 9;
        track(tracked);

    }

       else if(mp10 == cs)
    {

        var tracked = 10;
        track(tracked);

    }

       else if(mp11 == cs)
    {

        var tracked = 11;
        track(tracked);

    }

       else if(mp12 == cs)
    {

        var tracked = 12;
        track(tracked);

    }

       else if(mp13 == cs)
    {

        var tracked = 13;
        track(tracked);

    }

       else if(mp14 == cs)
    {

        var tracked = 14;
        track(tracked);

    }

       else if(mp15 == cs)
    {

        var tracked = 15;
        track(tracked);

    }

       else if(mp16 == cs)
    {

        var tracked = 16;
        track(tracked);

    }

       else if(mp17 == cs)
    {

        var tracked = 17;
        track(tracked);

    }

       else if(mp18 == cs)
    {

        var tracked = 18;
        track(tracked);

    }

else {
  print("Callsign dose not exist. or there are more than 19 multi players!"); # Callsign dose not match the callsign of the 19 players
   }

}


# Phoenix
# This reads the property assigned to flares on the selected MPid



var track = func(mpid){

    print(mpid); # We have our number
    print(getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign")); #threat is the right one. 
    var flareint = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/rotors/main/blade[3]/flap-deg");
    # Is our bandit flaring?
    if (flareint != nil){
    if (flareint > 0) {
    setprop("payload/armament/flares", 1);
    print("Flares detected.");
    } else {
        setprop("payload/armament/flares", 0);
    }

    } else {
        print("Target dose not support counter messures");
    }



}


# Missile view stuff
# Same thing but where searching for missiles
var mslsearch = func(cs){

 var mp0 = getprop("/ai/models/missile[0]/name");
 var mp1 = getprop("/ai/models/missile[1]/name");
 var mp2 = getprop("/ai/models/missile[2]/name");
 var mp3 = getprop("/ai/models/missile[3]/name");
 var mp4 = getprop("/ai/models/missile[4]/name");
 var mp5 = getprop("/ai/models/missile[5]/name");
 var mp6 = getprop("/ai/models/missile[6]/name");
 var mp7 = getprop("/ai/models/missile[7]/name");
 var mp8 = getprop("/ai/models/missile[8]/name");
 var mp9 = getprop("/ai/models/missile[9]/name");
var mp10 = getprop("/ai/models/missile[10]/name");
var mp11 = getprop("/ai/models/missile[11]/name");
var mp12 = getprop("/ai/models/missile[12]/name");
var mp13 = getprop("/ai/models/missile[13]/name");
var mp14 = getprop("/ai/models/missile[14]/name");
var mp15 = getprop("/ai/models/missile[15]/name");
var mp16 = getprop("/ai/models/missile[16]/name");
var mp17 = getprop("/ai/models/missile[17]/name");
var mp18 = getprop("/ai/models/missile[18]/name");

# Up to 18 + 1 targets at once (Not including ourselfs).
# Now lets look through it
# Mm yes if then statement time

    if(mp0 == cs) # If our request callsign is the callsign on Multiplayer[0]; set 0 as our ID then run a function called tracked with a parameter that consists of 0.
    {

        var tracked = 0;
        track(tracked);

    }

 else if(mp1 == cs)
    {

        var missileid = 1;
        missile(missileid);

    }

       else if(mp2 == cs)
    {

        var missileid = 2;
        missile(missileid);

    }

       else if(mp3 == cs)
    {

        var missileid = 3;
        missile(missileid);

    }

       else if(mp4 == cs)
    {

        var missileid = 4;
        missile(missileid);

    }

       else if(mp5 == cs)
    {

        var missileid = 5;
        missile(missileid);

    }

       else if(mp6 == cs)
    {

        var missileid = 6;
        missile(missileid);

    }

       else if(mp7 == cs)
    {

        var missileid = 7;
        missile(missileid);

    }

       else if(mp8 == cs)
    {

        var missileid = 8;
        missile(missileid);

    }

       else if(mp9 == cs)
    {

        var missileid = 9;
        missile(missileid);

    }

       else if(mp10 == cs)
    {

        var missileid = 10;
        missile(missileid);

    }

       else if(mp11 == cs)
    {

        var missileid = 11;
        missile(missileid);

    }

       else if(mp12 == cs)
    {

        var missileid = 12;
        missile(missileid);

    }

       else if(mp13 == cs)
    {

        var missileid = 13;
        missile(missileid);

    }

       else if(mp14 == cs)
    {

        var missileid = 14;
        missile(missileid);

    }

       else if(mp15 == cs)
    {

        var missileid = 15;
        missile(missileid);

    }

       else if(mp16 == cs)
    {

        var missileid = 16;
        missile(missileid);

    }

       else if(mp17 == cs)
    {

        var missileid = 17;
        missile(missileid);

    }

       else if(mp18 == cs)
    {

        var missileid = 18;
        missile(missileid);

    }

else {
  print("Missile dose not exist. or there are more than 19 Missiles!"); # Callsign dose not match the callsign of the 19 players
   }

}

var missile = func(mpid){

    print(mpid); # We have our number
    print(getprop("ai/models/missile[" ~ mpid ~ "]/name")); #threat is the right one.
    # lets view it

var s1 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/latitude-deg");
var s2 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/longitude-deg");
var s3 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/altitude-ft");
var s4 = getprop("/ai/models/missile[" ~ mpid ~ "]/orientation/true-heading-deg");
var s5 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/latitude-deg");
var s6 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/longitude-deg");
var s7 = getprop("/ai/models/missile[" ~ mpid ~ "]/position/altitude-ft");
var s8 = getprop("/ai/models/missile[" ~ mpid ~ "]/orientation/true-heading-deg");
var s9 = getprop("/ai/models/missile[" ~ mpid ~ "]/orientation/pitch-deg");
var s10 = getprop("/ai/models/missile[" ~ mpid ~ "]/orientation/roll-deg");
setprop("controls/armament/missile/pos2/a1", s1);
setprop("controls/armament/missile/pos2/a2", s2);
setprop("controls/armament/missile/pos2/a3", s3);
setprop("controls/armament/missile/pos2/a4", s4);
setprop("controls/armament/missile/pos2/a5", s5);
setprop("controls/armament/missile/pos2/a6", s6);
setprop("controls/armament/missile/pos2/a7", s7);
setprop("controls/armament/missile/pos2/a8", s8);
setprop("controls/armament/missile/pos2/a9", s9);
setprop("controls/armament/missile/pos2/a10", s10);
    view.setViewByIndex(101);
}

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
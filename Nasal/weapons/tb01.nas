# Flightgears First Nuclear bomb
# HAHAHAHAHAHHA
#
#   Ill call this bomb the TB-01 "Threshold"
# I reccomend that you drop it from 40kft+
# the shock wave has a ceiling of 60Kft
# So all planes are effective what so ever
# Maybe the blackbird can drop it

# Code for searching for MP planes by Phoenix and Skid
# Idea thought up by uapilot


var explode = func{

# The nuke hit the ground lets explode it!
# TODO. Some sort of cool mushroom cloud

# Lets see whos our multiplayer
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

   if(mp0 != nil) # If our request callsign is the callsign on Multiplayer[0]; set 0 as our ID then run a function called tracked with a parameter that consists of 0.
    {

        var tracked = 0;
         hit(tracked);

    }

 if(mp1 != nil)
    {

        var tracked = 1;
         hit(tracked);

    }

       if(mp2 != nil)
    {

        var tracked = 2;
         hit(tracked);

    }

       if(mp3 != nil)
    {

        var tracked = 3;
         hit(tracked);

    }

       if(mp4 != nil)
    {

        var tracked = 4;
         hit(tracked);

    }

       if(mp5 != nil)
    {

        var tracked = 5;
         hit(tracked);

    }

       if(mp6 != nil)
    {

        var tracked = 6;
         hit(tracked);

    }

       if(mp7 != nil)
    {

        var tracked = 7;
         hit(tracked);

    }

       if(mp8 != nil)
    {

        var tracked = 8;
         hit(tracked);

    }

       if(mp9 != nil)
    {

        var tracked = 9;
         hit(tracked);

    }

       if(mp10 != nil)
    {

        var tracked = 10;
         hit(tracked);

    }

       if(mp11 != nil)
    {

        var tracked = 11;
         hit(tracked);

    }

       if(mp12 != nil)
    {

        var tracked = 12;
         hit(tracked);

    }

       if(mp13 != nil)
    {

        var tracked = 13;
         hit(tracked);

    }

       if(mp14 != nil)
    {

        var tracked = 14;
         hit(tracked);

    }

       if(mp15 != nil)
    {

        var tracked = 15;
         hit(tracked);

    }

       if(mp16 != nil)
    {

        var tracked = 16;
         hit(tracked);

    }

       if(mp17 != nil)
    {

        var tracked = 17;
         hit(tracked);

    }

       if(mp18 != nil)
    {

        var tracked = 18;
         hit(tracked);

    }

else {
  print("There are no MP players online");
   }



}



var hit = func(mpid) {

# Send that a Thermo nuclear bomb smacked our bandit in the face
                    if(getprop("/payload/armament/msg"))
                    {
                       # setprop("/sim/multiplay/chat", phrase);
                        #var typeID = 0;
    			var typeID = 41; # JDAM but it hits everyone

                        var msg = notifications.ArmamentNotification.new("mhit", 4, damage.DamageRecipient.typeID2emesaryID(typeID));
                        msg.RelativeAltitude = 0;
                        msg.Bearing = 1;
                        msg.Distance = 1;
                        msg.RemoteCallsign = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/callsign");
                        notifications.hitBridgedTransmitter.NotifyAll(msg); # Kill everyone
                        setprop("/sim/messages/atc", "Nuclear Bomb Exploded. This Location is now a wasteland! All planes flying around are DEAD");              
                    }
                    else
                    {
                        setprop("/sim/messages/atc", "Nuclear Bomb Exploded. Damage is currently set to OFF");
                    }

}

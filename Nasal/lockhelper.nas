#
# Radar Lock identifier
#
# Created by Phoenix
# My 3rd nasal script that works! Yay!
#


# first lets see if the radar is displaying some threats on the screen
# capable of detecting 19 targets at once... or thats how many propertys there are to read
# time for some copy paste lol this is going to take a while
# TODO stop forgetting semi colons lmao


var mutexLock = thread.newlock();

var clearSingleLock = func () {
	thread.lock(mutexLock);
	if (getprop("instrumentation/radar/lock2") == 0) {
		setprop("sim/multiplay/generic/string[6]", "");
		datalink.clear_data();
	} else {
		setprop("sim/multiplay/generic/string[6]", left(md5(radar.tgts_list[radar.Target_Index].Callsign.getValue()), 4));
		datalink.send_data({"contacts":[{"callsign":radar.tgts_list[radar.Target_Index].Callsign.getValue(),"iff":0}]});
	}
	thread.unlock(mutexLock);
}
var checklock = func(){ # The radars database for displaying stuff on a screen.
var mp0 = getprop("/instrumentation/radar2/targets/multiplayer[0]/display");
var mp1 = getprop("/instrumentation/radar2/targets/multiplayer[1]/display");
var mp2 = getprop("/instrumentation/radar2/targets/multiplayer[2]/display");
var mp3 = getprop("/instrumentation/radar2/targets/multiplayer[3]/display");
var mp4 = getprop("/instrumentation/radar2/targets/multiplayer[4]/display");
var mp5 = getprop("/instrumentation/radar2/targets/multiplayer[5]/display");
var mp6 = getprop("/instrumentation/radar2/targets/multiplayer[6]/display");
var mp7 = getprop("/instrumentation/radar2/targets/multiplayer[7]/display");
var mp8 = getprop("/instrumentation/radar2/targets/multiplayer[8]/display");
var mp9 = getprop("/instrumentation/radar2/targets/multiplayer[9]/display");
var mp10 = getprop("/instrumentation/radar2/targets/multiplayer[10]/display");
var mp11 = getprop("/instrumentation/radar2/targets/multiplayer[11]/display");
var mp12 = getprop("/instrumentation/radar2/targets/multiplayer[12]/display");
var mp13 = getprop("/instrumentation/radar2/targets/multiplayer[13]/display");
var mp14 = getprop("/instrumentation/radar2/targets/multiplayer[14]/display");
var mp15 = getprop("/instrumentation/radar2/targets/multiplayer[15]/display");
var mp16 = getprop("/instrumentation/radar2/targets/multiplayer[16]/display");
var mp17 = getprop("/instrumentation/radar2/targets/multiplayer[17]/display");
var mp18 = getprop("/instrumentation/radar2/targets/multiplayer[18]/display");

		clearSingleLock();

    if(mp0) # instrumentation/radar2/targets/multiplayer[0]/display is true
    {
        print("I see someone! on mp0");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

 else if(mp1)
    {
        print("I see someone! On mp1");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp2)
    {
        print("I see someone! On mp2");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp3)
    {
        print("I see someone! On mp3");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp4)
    {
        print("I see someone!"); # lol too much work to make it say mp4~18 
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp5)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp6)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp7)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp8)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp9)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp10)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp11)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp12)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp13)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp14)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp15)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp16)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp17)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

       else if(mp18)
    {
        print("I see someone!");
        setprop("instrumentation/radar/threat-spotted", 1); #let us know that theres a pilot on the screen 
    }

else {
 # print("Radar is running, no threats.");
   setprop("/instrumentation/radar/threat-spotted", 0); # Change our status so that nothing is on the screen
   setprop("/instrumentation/radar/lock", 0); # Important. Loose the lock by setting this property to zero.
       setprop("/instrumentation/radar/lock2", 0);                                          #Lock is set to one when you change targets and radar sees someone

		clearSingleLock();
		thread.lock(mutexLock);
		#semi_active_track = nil;
		thread.unlock(mutexLock);
   }
}

# Lets make a loop


     finder = maketimer(0.5, func checklock() );
     finder.start();


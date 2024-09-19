#
# Is Flying detection. 
#
# Created by Phoenix
# My 4th nasal script that works! Yay lol
#




var checkflight = func(){ 
var limit = getprop("/fdm/jsbsim/fcs/inflight");



    if(limit)
    {
        setprop("canopy/enabled", 0); #let us know that theres a pilot on the screen 
    }

 else {
        setprop("canopy/enabled", 1); #let us know that theres a pilot on the screen 
      }

}


#Loop it!
     controllimit = maketimer(0.5, func checkflight() );
     controllimit.start();
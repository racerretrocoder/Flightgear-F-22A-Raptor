# engfire.nas
# F-22 Engine Fire Simulation | Authored by Phoenix
# This code will handle the RNG
# Revival Based on EGT and engine speed (and if you can still fly your plane...)
print("LOADING engfire.nas .");
setprop("f22/engine[0]/extingfluid",50);
setprop("f22/engine[1]/extingfluid",50);


var getrng = func(enginenum) {
    var n1 = getprop("engines/engine[" ~ enginenum ~ "]/n1");
    var n2 = getprop("engines/engine[" ~ enginenum ~ "]/n2");
    var egt = getprop("engines/engine[" ~ enginenum ~ "]/egt-degf");
    var chance = 0.5; # fifty fifty shot lol
    if (n1 > 100) {
        # Engine overspeeding
        chance = chance + 0.4998;
        print("the engine is overspeeding n1 over 100. chance is ",chance);
    }
    if (n1 > 60) {
        # Engine overspeeding
        chance = chance + 0.1;
        print("the engine is still spinning pretty fast n1 over 60. chance is ",chance);
    }
    if (egt > 800) {
        chance = chance + 0.3;
        print("the engine is way too hot. chance is ", chance);
    }
    print("chance: ",chance);
    var num2 = rand() < (1-chance);
    return num2;
}


var extingright = func() {
    var enginenum = 1;
    var extingfluid = getprop("f22/engine[" ~ enginenum ~ "]/extingfluid");
    if (extingfluid > 0) {
        # present
        thenum = getrng(enginenum);
        if (thenum == 1) {
            # Successful extinguish
            print("Successful extinguish for engine ",enginenum);
            setprop("sim/failure-manager/engines/engine[" ~ enginenum ~ "]/serviceable",1);
            screen.log.write("Successfully extinguished the engine",0,1,0);
            setprop("f22/engine[" ~ enginenum ~ "]/extingfluid",extingfluid - 1);
        } else {
            print("didnt extinguish engine ",enginenum);
            setprop("f22/engine[" ~ enginenum ~ "]/extingfluid",extingfluid - 1);
        }
    } else {
        print("No exting fluid, Cant exting engine ",enginenum);
        screen.log.write("No fluid remaining for that engine! Cant extinguish.",1,0,0);
    }
}

var extingleft = func() {
    var enginenum = 0;
    var extingfluid = getprop("f22/engine[" ~ enginenum ~ "]/extingfluid");
    if (extingfluid > 0) {
        # present
        thenum = getrng(enginenum);
        if (thenum == 1) {
            # Successful extinguish
            print("Successful extinguish for engine ",enginenum);
            setprop("sim/failure-manager/engines/engine[" ~ enginenum ~ "]/serviceable",1);
            screen.log.write("Successfully extinguished the engine",0,1,0);
            setprop("f22/engine[" ~ enginenum ~ "]/extingfluid",extingfluid - 1);
        } else {
            print("didnt extinguish engine ",enginenum);
            setprop("f22/engine[" ~ enginenum ~ "]/extingfluid",extingfluid - 1);
        }
    } else {
        print("No exting fluid, Cant exting engine ",enginenum);
    }
}

righteng = maketimer (0.5,extingright); # 0.5 is the rate of the rng checks. the faster the right. the more likely
lefteng = maketimer (0.5,extingleft); 

var engineloop = func() {
    var engint = getprop("f22/engint"); # 0 both engines on fire, 1 right engine on fire, 2 left engine on fire. 3 no engines on fire
    if (engint == 3) {
        setprop("f22/fireleft",0);
        setprop("f22/fireright",0);
    } elsif (engint == 1) {
        setprop("f22/fireleft",0);
        setprop("f22/fireright",1);
    } elsif (engint == 2) {
        setprop("f22/fireleft",1);
        setprop("f22/fireright",0);
    } elsif (engint == 0) {
        setprop("f22/fireleft",1);
        setprop("f22/fireright",1);
    }
}


print("engfire.nas: Ready!");
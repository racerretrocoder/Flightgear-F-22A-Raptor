print("loading somewhat simple weapon counter...");
# one two three four five six
# counting.nas | Somewhat Simple Weapon Counter (SSWC)
# Phoenix, uapilot

# intended uses: Count weapons on pylons
# to get a returned list: do countlist();
# to get a property update: do countprop();
# will setup a maketimer for countprop();

# sim/weight[]/selected depicts the available weapon on that pylon
# controls/armament/station[]/release depicts if the said available weapon is present
var weaponlist = ["Aim-9x","Aim-120","Aim-260","GBU-39","JDAM"]; # idk why i put this here
var countlist = func() {
    print("okie time to count xd");
    var wep1 = 0; # one
    var wep2 = 0; # two
    var wep3 = 0; # three
    var wep4 = 0; # four
    var wep5 = 0; # five

    var wep1a = 0; # ammount one
    var wep2a = 0; # ammount two
    var wep3a = 0; # ammount three
    var wep4a = 0; # ammount four
    var wep5a = 0; # ammount five

    var pylons = props.globals.getNode("/sim").getChildren("weight");
    var total = size(pylons);
    print("step 1: counting pylons!");
    for(var i = 0; i < total; i += 1) {
        if (getprop("sim/weight[" ~ i ~ "]/selected") == "Aim-9x") {
            wep1 = wep1 + 1; # inc
            if (getprop("controls/armament/station[" ~ i ~ "]/release") == 0) {
                # weapon attached
                wep1a = wep1a + 1;
            }
        }
        if (getprop("sim/weight[" ~ i ~ "]/selected") == "Aim-120") {
            wep2 = wep2 + 1; # inc
            if (getprop("controls/armament/station[" ~ i ~ "]/release") == 0) {
                # weapon attached
                wep2a = wep2a + 1;
            }
        }
        if (getprop("sim/weight[" ~ i ~ "]/selected") == "Aim-260") {
            wep3 = wep3 + 1; # inc
            if (getprop("controls/armament/station[" ~ i ~ "]/release") == 0) {
                # weapon attached
                wep3a = wep3a + 1;
            }
        }
        if (getprop("sim/weight[" ~ i ~ "]/selected") == "GBU-39") {
            wep4 = wep4 + 1; # inc
            if (getprop("controls/armament/station[" ~ i ~ "]/release") == 0) {
                # weapon attached
                wep4a = wep4a + 1;
            }
        }
        if (getprop("sim/weight[" ~ i ~ "]/selected") == "JDAM") {
            wep5 = wep5 + 1; # inc
            if (getprop("controls/armament/station[" ~ i ~ "]/release") == 0) {
                # weapon attached
                wep5a = wep5a + 1;
            }
        }
    }
    print("finished counting pylons! here are result");
    print("Capable of ",wep1," Aim-9x's");
    print("Capable of ",wep2," Aim-120's");
    print("Capable of ",wep3," Aim-260's");
    print("Capable of ",wep4," GBU-39's");
    print("Capable of ",wep5," JDAM's (GBU-31)");
    print("-------------------------------------------");
    print("there are ",wep1a," Aim-9x's");
    print("there are ",wep2a," Aim-120's");
    print("there are ",wep3a," Aim-260's");
    print("there are ",wep4a," GBU-39's");
    print("there are ",wep5a," JDAM's (GBU-31)");
    var ae = [wep1a,wep2a,wep3a,wep4a,wep5a];
    print(ae);
    return ae;
}   

print("somewhat simple weapon counter: Ready.");
######################## end counting.nas ########################
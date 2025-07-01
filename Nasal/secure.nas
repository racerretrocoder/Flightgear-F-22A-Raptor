
#
# Secure Communication with MP Players
#

# Written by Phoenix & Uapilot

# General concept: Use a KY-58 Secure Voice Look-alike panel for secure communication to and from F-22A Pilots
# This makes the MPChat redunant. Its not really realistic, but its helpful and requested by others.
# Feature Requests: 
# 1: Easy F-16 Backwards Compatilibty. Just add the nasal file to the -set to make it work  -- Let us get it working with raptor first then will see

# Initalize the properties

setprop("controls/ky58/mode",0); # P, C, LD, RV
setprop("controls/ky58/type",0); # 1, 2, 3, 4, 5, 6, Z, ALL   # 0 1 2 3 4 5 6 7
setprop("controls/ky58/main",0); # OFF, ON, TD

setprop("controls/ky58/buffer",""); # Chat dialog buffer
# What plane are we?
var israptor = 1;
# in F-22A We will use string[8] for COMM and int[3] for the code
setprop("sim/multiplay/generic/string[8]","KY58: Connected!");
var chat = events.LogBuffer.new(echo: 0);




# From misc.nas
var smallsearch = func(cs=nil) {
  var list = props.globals.getNode("/ai/models").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
      if (cs != nil) {
      # were searching for someone...
      if (getprop("ai/models/multiplayer[" ~ i ~ "]/callsign") == cs) {
          # we have our number
          print(mpid);
          mpid = i;
          return mpid; # Bam!
     }
      var callsign = list[i].getNode("callsign").getValue();
     }
   }
}


# Check power
var getpower = func {
    var main = getprop("controls/ky58/main");
    if (main == 1 or main == 2){return 1;}
    if (main == 0){return 0;}
    screen.log.write("getpower(): error");
    return 1; # if somthing failed just make it on
}


var getcode = func {
    if (getpower() == 0){return -1;} # Check if enabled
    var type = getprop("controls/ky58/type");
    var mode = getprop("controls/ky58/mode");
    # lets form a 4 digit code based on the settings
    # A and B should be based on the mode
    # C and D should be based on the type

    #
    # Mode

    var digitA = 0;
    var digitB = 0;
    if (mode == 0){
        digitA = 0;
        digitB = 0; 
    }
    if (mode == 1){
        digitA = 1;
        digitB = 0; 
    }
    if (mode == 2){
        digitA = 1;
        digitB = 1; 
    }
    if (mode == 3){
        digitA = 0;
        digitB = 1; 
    }

    #
    # Type

    var digitC = 0;
    var digitD = 0;
    if (type == 0){ # 1
        digitC = 0;
        digitD = 0; 
    }
    if (type == 1){ # 2
        digitC = 1;
        digitD = 5; 
    }
    if (type == 2){ # 3
        digitC = 2;
        digitD = 9; 
    }
    if (type == 3){ # 4
        digitC = 3;
        digitD = 5; 
    }
    if (type == 4){ # 5
        digitC = 4;
        digitD = 1; 
    }
    if (type == 5){ # 6
        digitC = 8;
        digitD = 6; 
    }
    if (type == 6){ # Z 
        digitC = 7;
        digitD = 4; 
    }
    if (type == 7){ # ALL
        digitC = 9;
        digitD = 9; 
    }

    # form the code
    var first = digitA * 1000;      # Make a 4 digit code
    var second = digitB * 100;      # Make a 4 digit code
    var third = digitC * 10;        # Make a 4 digit code
    var fourth = digitD * 1;        # Make a 4 digit code
    var factor = 1; # TD
    if (getprop("controls/ky58/main") == 2){
        factor = 2;
    }
    var precode = first + second + third + fourth;
    var code = precode * factor; # TD 
    print(code);
    setprop("/sim/multiplay/generic/int[3]",code);
    return code;
}


var checkcode = func(ourcode) {
  var list = props.globals.getNode("/ai/models").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
    if (getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/int[3]") == ourcode) {
          # We can exchange info with this pilot
         # print(mpid);
          mpid = i;
          ##track(mpid,0); # run the flare detection/RND on this Multiplayer property
          #return mpid; # Bam!
            var callsign = getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign");
            setprop("/controls/KY58/contacts/" ~ callsign ~ "/code",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/int[3]")); # Make a specifc property per each pilot
            setprop("/controls/KY58/contacts/" ~ callsign ~ "/message",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/string[8]")); # Check for new mail!
            if (getprop("/controls/KY58/contacts/" ~ callsign ~ "/message") != getprop("/controls/KY58/contacts/" ~ callsign ~ "/oldmessage")) {
                # Message changed!
                var newmessage = getprop("/controls/KY58/contacts/" ~ callsign ~ "/message");
                screen.log.write("KY-58: "~ callsign ~ ": " ~ newmessage ~ "");
                chat.push("" ~ callsign ~ ": " ~ newmessage ~ "");
                # Update old message 
                setprop("/controls/KY58/contacts/" ~ callsign ~ "/oldmessage",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/string[8]"));
            }
            # Its different, We will update
        }
    }
}





# Communication loop
var communicate = func {
    var code = getcode();
    checkcode(code);
}

securevoicetimer = maketimer(1,communicate);
securevoicetimer.start();
print("secure.nas: Operational");



var updatebuffer = func {
	var str = "";
	var buffer = chat.get_buffer();
		foreach(entry; buffer) {
			str = str~""~entry.time~"  "~entry.message~"\n";
		}
	setprop("sim/gui/dialogs/ky58/buffer", str);
}

updatetimer = maketimer(1,updatebuffer);
updatetimer.start();
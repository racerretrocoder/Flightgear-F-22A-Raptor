print("KY-58: secure.nas starting up, Namespace: KY58");
#
# Secure Communication with MP Players
# Version 2.0
# Encryption Revision: 1.0
#

# Written by Phoenix & Uapilot

# General concept: Use a KY-58 Secure Voice Look-alike panel for secure communication to and from F-22A Pilots
# This makes the MPChat redunant. Its not really realistic, but its helpful and requested by others.
# Feature Requests: 
# 1: Easy F-16 Backwards Compatilibty.

# Initalize the properties
setprop("controls/ky58/cipherkey",0); # Default Encryption Key
setprop("controls/ky58/mode",0); # P, C, LD, RV
setprop("controls/ky58/type",0); # 1, 2, 3, 4, 5, 6, Z, ALL <-> 0, 1, 2, 3, 4, 5, 6, 7,
setprop("controls/ky58/main",0); # OFF, ON, TD (TD Allows for twice as many combonations)
setprop("controls/ky58/encrypted",0); # Encryption toggle switch (Auto enables on LD and RV)
setprop("controls/ky58/buffer",""); # Chat dialog buffer
# What plane are we?
var israptor = 1;
var isviper = 0;

# in F-22A We will use string[8] for COMM and int[3] for the code
setprop("sim/multiplay/generic/string[8]","KY58: Connected!");
var chat = events.LogBuffer.new(echo: 0);




var lettergrouping = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","1","2","3","4","5","6","7","8","9","0"," ","-","!",".","?",",",":"];
var upperlettergrouping = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","0",":","-","!",".","?",","," "];
# Total: 43
# Indexes: 0-42
# There MUST be an even ammount of indexes, We cant select half an index!

var decrypt = func(message) {
    var cipher = getprop("controls/ky58/cipherkey"); # how many indexes should the cursor move
    while (cipher > 42) {
        cipher = cipher - 42;
    }
    if (cipher == 42) {
        screen.log.write("KY58 Warning! This cipher code is not as secure! (It resolves to 42)",1,0,0);
    }
    var encryptedmessage = "";
    var total = size(message);
    var totalgroup = size(lettergrouping);
    ###print("Ammount of indexes in char group: ",totalgroup-1);
    var newstring = "";
    for(var i = 0; i < total; i += 1) {
        var ingroup = 0; # If its a valid charecter
        var groupin = 0; # The index in the letter group
        var thechar = utf8.chstr(message[i]);
        ###print("Decrypting: ",thechar);
        for(var h = 0; h < totalgroup; h += 1) {
            if (ingroup == 0) {
                if (thechar == lettergrouping[h]) {
                    ###print("That charecter is in the group! its at: ",h);
                    groupin = h;
                    ingroup = 1;
                }
            }
        }
        ###print("Scanned through the group!");
        if (ingroup == 1) {
            # encrypt
            #if (groupin < 21) {
                # added
            var encryptedindex = groupin - cipher;
            #} elsif (groupin > 21 or groupin == 21) {
                # subtracted
            #    encryptedindex = groupin - cipher;
            #}
            # overflow check
            if (encryptedindex > 42) {
                ###print("Index overflow");
                encryptedindex = encryptedindex - 42;
            } elsif (encryptedindex < 0) { # for all negitive indexes
                encryptedindex = encryptedindex + 42;
                ###print("Index underflow");
            }
            var encryptedchar = lettergrouping[encryptedindex];
            ###print("Decrypted Index: ",encryptedindex);
            ###print("Decrypted Charecter: ",encryptedchar);
            if (encryptedchar == " ") {
                ###print("Its a space!");
            }
            encryptedmessage = "" ~ encryptedmessage ~ "" ~ encryptedchar ~ ""; # append the encrypted charecter to the message
        } else {
            ###print("That charecter wasnt in the valid group of letters!");
            var encryptedchar = "-";
            encryptedmessage = "" ~ encryptedmessage ~ "" ~ encryptedchar ~ ""; # append the encrypted charecter to the message
        }
        ###print("Heres our Decrypted Message so far: ",encryptedmessage);
    }
#    encryptedmessage = left(encryptedmessage); # reverse em
    ###print("Decryption complete!");
    ###print("first message: ",message);
    ###print("decry message: ",encryptedmessage);
    return encryptedmessage;
}

var encrypt = func(message) {
    var cipher = getprop("controls/ky58/cipherkey"); # how many indexes should the cursor move
    message = string.lc(message);
    while (cipher > 42) {
        cipher = cipher - 42;
    }
    if (cipher == 42) {
        screen.log.write("KY-58 Warning! This cipher code is not as secure! (It resolves to 42)",1,0,0);
    }
    var encryptedmessage = "";
    var total = size(message);
    var totalgroup = size(lettergrouping);
    ###print("Ammount of indexes in char group: ",totalgroup-1);
    var newstring = "";
    for(var i = 0; i < total; i += 1) {
        var ingroup = 0; # If its a valid charecter
        var groupin = 0; # The index in the letter group
        var thechar = utf8.chstr(message[i]);
        ###print("Encrypting: ",thechar);
        for(var j = 0; j < totalgroup; j += 1) {
            if (ingroup == 0) {
                if (thechar == lettergrouping[j]) {
                    ###print("That charecter is in the group! its at: ",j);
                    groupin = j;
                    ingroup = 1;
                }
            }
        }
        ###print("Scanned through the group!");
        if (ingroup == 1) {
            var encryptedindex = groupin + cipher;
            #} elsif (groupin > 21 or groupin == 21) {
                # subtracted
            #    encryptedindex = groupin - cipher;
            #}
            # overflow check
            if (encryptedindex > 42) {
                ###print("Index overflow");
                encryptedindex = encryptedindex - 42;
            } elsif (encryptedindex < 0) { # for all negitive indexes
                encryptedindex = encryptedindex + 42;
                ###print("Index underflow");
            }
            var encryptedchar = lettergrouping[encryptedindex];
            ###print("Encrypted Index: ",encryptedindex);
            ###print("Encrypted Charecter: ",encryptedchar);
            if (encryptedchar == " ") {
                ###print("Its a space!");
            }
            encryptedmessage = "" ~ encryptedmessage ~ "" ~ encryptedchar ~ ""; # append the encrypted charecter to the message
        } else {
            ###print("That charecter wasnt in the valid group of letters!");
            var encryptedchar = "-";
            encryptedmessage = "" ~ encryptedmessage ~ "" ~ encryptedchar ~ ""; # append the encrypted charecter to the message
        }
        ###print("Heres our Encrypted Message so far: ",encryptedmessage);
    }
#    encryptedmessage = left(encryptedmessage); # reverse em
    ###print("Encryption complete!");
    ###print("first message: ",message);
    ###print("encrpt message: ",encryptedmessage);
    return encryptedmessage;
}


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
          ####print(mpid);
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
    screen.log.write("KY-58: Error. Couldnt Initilize");
    return 1; # if somthing failed just make it on
}


var getcode = func {
    # Code calculation
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
    if (mode == 0){ # P
        digitA = 0;
        digitB = 0; 
        setprop("controls/ky58/encrypted",0);
    }
    if (mode == 1){ # C
        digitA = 1;
        digitB = 0; 
        setprop("controls/ky58/encrypted",0);
    }
    if (mode == 2){ # LD (Encrypted)
        digitA = 1;
        digitB = 1; 
        if (getprop("controls/ky58/encrypted") == 0) {
            screen.log.write("KY-58 Encryption Enabled. (On LD and RV only)");
        }
        setprop("controls/ky58/encrypted",1);
    }
    if (mode == 3){ # RV (Encrypted)
        digitA = 0;
        digitB = 1; 
        if (getprop("controls/ky58/encrypted") == 0) {
            screen.log.write("KY-58 Encryption Enabled. (On LD and RV only)");
        }
        setprop("controls/ky58/encrypted",1);
    }
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
    var first = digitA * 1000;    # Make a 4 digit code
    var second = digitB * 100;    # Make a 4 digit code
    var third = digitC * 10;      # Make a 4 digit code
    var fourth = digitD * 1;      # Make a 4 digit code
    var factor = 1; # TD
    if (getprop("controls/ky58/main") == 2){
        factor = 2;
    }
    var precode = first + second + third + fourth;
    var code = precode * factor; # TD 
    ####print(code);
    setprop("/sim/multiplay/generic/int[3]",code);
    return code;
}

var checkcode = func(ourcode) {
  var list = props.globals.getNode("/ai/models").getChildren("multiplayer");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
    if (getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/int[3]") == ourcode) {
            mpid = i;
            var callsign = getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign");
            setprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/code",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/int[3]")); # Make a specifc property per each pilot
            setprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/message",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/string[8]")); # Check for new mail!
            if (getprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/message") != getprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/oldmessage")) {
                # Message changed!
                var newmessage = getprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/message");
                if (getprop("controls/ky58/encrypted") == 1) {
                    # Encryption is enabled. 
                    newmessage = decrypt(newmessage);
                    screen.log.write("[Encrypted] KY-58: "~ callsign ~ ": " ~ newmessage ~ "");
                } else {
                    screen.log.write("KY-58: "~ callsign ~ ": " ~ newmessage ~ "");
                }
                chat.push("" ~ callsign ~ ": " ~ newmessage ~ "");
                # Update old message 
                setprop("/controls/KY58/contacts/contact[" ~ mpid ~ "]/oldmessage",getprop("ai/models/multiplayer[" ~ i ~ "]/sim/multiplay/generic/string[8]"));
            }
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

var encryptiontest = func {
    print("KY58 Testing encryption...");
    screen.log.write("KY-58: Testing encryption integrity...");
    setprop("controls/ky58/cipherkey",30);
    var message = "abcdefghijklmnopqrstuvwxyz1234567890";
    encryption = encrypt(message);
    var decryption = decrypt(encryption);
    if (decryption == message) {
        screen.log.write("KY-58: Encryption test succeded. Operational",0,1,0);
    } else {
        screen.log.write("KY-58: Encryption not functioning as intended, Modes LD, RV Disabled",1,0,0);
    }
    setprop("controls/ky58/cipherkey",0);
}
encryptiontest();

print("secure.nas: KY-58 Secure Voice Terminal Operational! (Made by Phoenix) | Encryption Version 1.0");
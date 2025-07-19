# Front controls numpad system
# Along with datalink coordnites, and the PRF System

# ... I have no clue on why i named this file RAD.nas 

# xd

print("Loading Front Controls...");
setprop("controls/PRF/range",5);
setprop("controls/radar/currentslot", 1);
setprop("controls/radar/slots/lat", 1);
setprop("controls/radar/slots/lon", 1);
setprop("controls/radar/slots/alt", 1);



# Front controls numpad system
# Made by Phoenix

# namespace:  fc

var digit1 = nil;
var digit2 = nil;
var digit3 = nil;
var digit4 = nil;
var digit5 = nil;
var digit6 = nil;

# Buttons
# Left row from bottom to top

var setnum = func(num){

if (digit1 == nil) {
setprop("instrumentation/frontcontrols/digit1", num);
digit1 = num;
} elsif (digit2 == nil) {
setprop("instrumentation/frontcontrols/digit2", num);
digit2 = num;
} elsif (digit3 == nil) {
setprop("instrumentation/frontcontrols/digit3", num);
digit3 = num;
} elsif (digit4 == nil) {
setprop("instrumentation/frontcontrols/digit4", num);
digit4 = num;
} elsif (digit5 == nil) {
setprop("instrumentation/frontcontrols/digit5", num);
digit5 = num;
} elsif (digit6 == nil) {
setprop("instrumentation/frontcontrols/digit6", num);
digit6 = num;
}

}

var clearnum = func{

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);
print("clear");

}


var addtoslots = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
} elsif (digit5 == nil) {
digit5 = 0;
} elsif (digit6 == nil) {
digit6 = 0;
}


var num1 = digit1;


var numfinal = num1;
print(numfinal);

setprop("controls/radar/currentslot", numfinal);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}



var addtocomm1 = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
} elsif (digit5 == nil) {
digit5 = 0;
} elsif (digit6 == nil) {
digit6 = 0;
}



# SUPER SMART!
var num1 = digit1 * 100000;
var num2 = digit2 * 10000;
var num3 = digit3 * 1000;
var num4 = digit4 * 100;
var num5 = digit5 * 10;
var num6 = digit6 * 1;

var numfinal = num1 + num2 + num3 + num4 + num5 + num6;
print(numfinal);

setprop("instrumentation/comm[0]/frequencies/standby-mhz", numfinal / 1000);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}

var addtocomm2 = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
} elsif (digit5 == nil) {
digit5 = 0;
} elsif (digit6 == nil) {
digit6 = 0;
}


var num1 = digit1 * 100000;
var num2 = digit2 * 10000;
var num3 = digit3 * 1000;
var num4 = digit4 * 100;
var num5 = digit5 * 10;
var num6 = digit6 * 1;

var numfinal = num1 + num2 + num3 + num4 + num5 + num6;
print(numfinal);

setprop("instrumentation/comm[1]/frequencies/standby-mhz", numfinal / 1000);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}

# Add to datalink

var addtodlink = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
} elsif (digit3 == nil) {
digit3 = 0;
} elsif (digit4 == nil) {
digit4 = 0;
}

var num1 = digit1 * 1000;
var num2 = digit2 * 100;
var num3 = digit3 * 10;
var num4 = digit4 * 1;

var numfinal = num1 + num2 + num3 + num4;
print(numfinal);

setprop("instrumentation/datalink/channel", numfinal);
setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);


# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}





var setbingo = func{


#digit1 = 1;
#digit2 = 2;
#digit3 = 3;
#digit4 = 6;
#digit5 = 5;
#digit6 = 4;

# nil Detection
if (digit1 == nil) {
digit1 = 0;
} elsif (digit2 == nil) {
digit2 = 0;
setprop("f22/bingo",digit1);
} elsif (digit3 == nil) {
digit3 = 0;
var num1 = digit1 * 10;
var num2 = digit2;
var ans = num1+num2;
setprop("f22/bingo",ans);
} elsif (digit4 == nil) {
digit4 = 0;
var num1 = digit1 * 100;
var num2 = digit2 * 10;
var num3 = digit3 * 1;
var ans = num1+num2+num3;
setprop("f22/bingo",ans);
} elsif (digit5 == nil) {
digit5 = 0;
var num1 = digit1 * 1000;
var num2 = digit2 * 100;
var num3 = digit3 * 10;
var num4 = digit4 * 1;
var ans = num1+num2+num3+num4;
setprop("f22/bingo",ans);
} elsif (digit6 == nil) {
digit6 = 0;
var num1 = digit1 * 10000;
var num2 = digit2 * 1000;
var num3 = digit3 * 100;
var num4 = digit4 * 10;
var num5 = digit5 * 1;
var ans = num1+num2+num3+num4+num5;
setprop("f22/bingo",ans);
}
else {
  # all numbers not nil

# SUPER SMART!
var num1 = digit1 * 100000;
var num2 = digit2 * 10000;
var num3 = digit3 * 1000;
var num4 = digit4 * 100;
var num5 = digit5 * 10;
var num6 = digit6 * 1;

var numfinal = num1 + num2 + num3 + num4 + num5 + num6;
print(numfinal);

setprop("f22/bingo", numfinal); # who would ever need a bingo that high? lol
}


setprop("instrumentation/frontcontrols/digit1", 0);
setprop("instrumentation/frontcontrols/digit2", 0);
setprop("instrumentation/frontcontrols/digit3", 0);
setprop("instrumentation/frontcontrols/digit4", 0);
setprop("instrumentation/frontcontrols/digit5", 0);
setprop("instrumentation/frontcontrols/digit6", 0);

# Reset the system

digit1 = nil;
digit2 = nil;
digit3 = nil;
digit4 = nil;
digit5 = nil;
digit6 = nil;

}



# Swap functions


var swapc1 = func{

setprop("instrumentation/frontcontrols/c1a", getprop("instrumentation/comm[0]/frequencies/selected-mhz"));
setprop("instrumentation/frontcontrols/c1b", getprop("instrumentation/comm[0]/frequencies/standby-mhz"));

var stdby = getprop("instrumentation/frontcontrols/c1b");
var active = getprop("instrumentation/frontcontrols/c1a");

setprop("instrumentation/comm[0]/frequencies/selected-mhz", stdby);
setprop("instrumentation/comm[0]/frequencies/standby-mhz", active);

}

var swapc2 = func{

setprop("instrumentation/frontcontrols/c2a", getprop("instrumentation/comm[1]/frequencies/selected-mhz"));
setprop("instrumentation/frontcontrols/c2b", getprop("instrumentation/comm[1]/frequencies/standby-mhz"));

var stdby = getprop("instrumentation/frontcontrols/c2b");
var active = getprop("instrumentation/frontcontrols/c2a");

setprop("instrumentation/comm[1]/frequencies/selected-mhz", stdby);
setprop("instrumentation/comm[1]/frequencies/standby-mhz", active);

}

# system modes


var aamode = func{

setprop("systems/MFD/modemfdc", 2);
setprop("systems/MFD/modemfdl", 1);
setprop("systems/MFD/modemfdr", 5);

}

var agmode = func{

setprop("systems/MFD/modemfdc", 5);
setprop("systems/MFD/modemfdl", 1);
setprop("systems/MFD/modemfdr", 4);

}


var nav = func{
setprop("systems/MFD/modemfdc", 7);
setprop("systems/MFD/modemfdl", 4);
setprop("systems/MFD/modemfdr", 6);

}

# Cool datalink stuff

var datapoint = {
	lon: 0,
	lat: 0,
	alt: 0,
	new: func {
		var n = {parents: [datapoint]};
		return n;
	},
};


var sending = nil;
var data = nil;


          setprop("instrumentation/datalink/data",1); 

var clearsend = func {
    print("stoped");
    sending = nil;
        timer_send.stop();
        clear_timer.stop();
}


var clearsendlong = func {
    print("stoped");
    sending = nil;
    data = nil;
    timer_send.stop();
    setprop("instrumentation/datalink/data",0); 
    clear_timer_long.stop();
}


var linksendpoint = func {

	datalink.send_data({"point": sending});

}


timer_send = maketimer(0.1, linksendpoint);
clear_timer = maketimer(7, clearsend);
clear_timer_long = maketimer(10, clearsendlong);
# Datalink functions
# some inspired by f-16



var coordclick = func() {
    var lat = getprop("sim/input/click/latitude-deg");
    var lon = getprop("sim/input/click/longitude-deg");
    var h = geo.elevation(getprop("sim/input/click/latitude-deg"),getprop("sim/input/click/longitude-deg"));
    send(coordsetup(lat,lon,h));
}

var coordsetup = func(lat,lon,alt) {
    var coord = geo.Coord.new();
    var gndelev = alt*FT2M;
    print("coord: lat:" ~ lat);
    print("coord: lon:" ~ lon);
    print("coord: alt:" ~ alt);
    if (gndelev <= 0) {
        gndelev = geo.elevation(lat, lon);
       if (gndelev != nil){
            print("gndelev: " ~ gndelev);
        }
       if (gndelev == nil){
            # oh no
            gndelev = 0;
        }
    }
    print(gndelev);
    coord.set_latlon(lat, lon, gndelev);
    return coord;
}

# Sender

var send = func(coord){ # Unless given, coord is nil
	if (coord != nil and sending == nil) {
        sending = coord;
        print("Sending");
        timer_send.start();
        clear_timer.start();
        print("Sent");
    }
}   



var data = nil;
var sending = nil;
var dlink_loop = func {
  if (getprop("instrumentation/datalink/data") != 0) return;
  total = misc.searchsize();
  for(var i = 0; i < total; i += 1) {
  var reccall = getprop("ai/models/multiplayer[" ~ i ~ "]/callsign");
# if these guys on dl...
    if (1 == 1) {
      data = datalink.get_data(reccall); # get our data
      if (data != nil  and data.on_link()) {
        var p = data.point();
        if (p != nil) {
          sending = nil;
          var lat = p.lat();
          var lon = p.lon();
          var alt = p.alt()*M2FT;
          setprop("controls/radar/datarec/lat", lat);   
          setprop("controls/radar/datarec/lon", lon);
          setprop("controls/radar/datarec/alt", alt);
          print("Datalink is being sent over to us from " ~ reccall);
          screen.log.write("Datalink Coordnites were sent over from " ~ reccall ~ "!",1,1,0);
          setprop("instrumentation/datalink/lastcallsign", reccall);
          setprop("instrumentation/datalink/data",1);          
          clear_timer_long.start();
          return;
        }
      }
    }
  }
}
# For PRF
var dlink_loopcontacts = func {
  #print("testing contacts...");
  if (getprop("instrumentation/datalink/data") != 0) return;
  total = misc.searchsize();
  for(var i = 0; i < total; i += 1) {
    var mpid = i;
    var chkcallsign = getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign");
    #print("Checking if someone is locking "~chkcallsign);
    var data = datalink.get_data(chkcallsign);
    if (data != nil){
      #print("Not nil!");
      if (data.tracked() != nil){
        var result = data.tracked();
      }
    } else {
      #print("Not locked");
      result = 0;
    }
    if (result == nil){result = 0;}
    setprop("controls/PRF/contact["~ mpid ~"]/istracked",result);
    var ourhdg = getprop("/orientation/heading-deg");
    var therehdg = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/bearing-deg");
    var ans = ourhdg - therehdg;
    if (ans < 0) {
      # negitive
      #screen.log.write("it be negitive");
      #ns = ans + 180;
    }
    setprop("controls/PRF/contact["~ mpid ~"]/heading",ans);
      #
      # Range
      # WIP Make own HSD Range
      if (getprop("controls/PRF/range") == 5){
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm"));
      }
      if (getprop("controls/PRF/range") == 10){
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 2);
      }
      if (getprop("controls/PRF/range") == 20){
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 4);
      }
      if (getprop("controls/PRF/range") == 40){
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 6);
      }
      if (getprop("controls/PRF/range") == 60){
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 16);
      }
      if (getprop("controls/PRF/range") == 160){ # WOWZERS!
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 30);
      }
      if (getprop("controls/PRF/range") == 360){ # WOWZERS!
      setprop("controls/PRF/contact[" ~ mpid ~ "]/range",getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm") / 30);
      }
      # Callsign
      setprop("controls/PRF/contact[" ~ mpid ~ "]/callsign",getprop("ai/models/multiplayer[" ~ mpid ~ "]/callsign"));
      setprop("controls/PRF/contact[" ~ mpid ~ "]/alt",getprop("ai/models/multiplayer[" ~ mpid ~ "]/position/altitude-ft") / 1000); # 1 for 1,000 10 for 10,000 and so on
  }
}
setprop("instrumentation/datalink/lastcallsign", "No Data");

var dlnk_timer = maketimer(3.5, dlink_loop);
var dlnk_timercontact = maketimer(0.1, dlink_loopcontacts);
dlnk_timer.start();
dlnk_timercontact.start();
setprop("instrumentation/datalink/data",0); # Enable Recording   
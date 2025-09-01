print("crcs.nas: INIT");
# Phoenix
# Small Radar Cross Section Thingy


# custom rcs database
var database = func() {
    setprop("/instrumentation/radar2/rcs/model[0]/model","F-22-Raptor");
    setprop("/instrumentation/radar2/rcs/model[0]/rcs",0.0001);
    setprop("/instrumentation/radar2/rcs/model[1]/model","Large_Hanger");
    setprop("/instrumentation/radar2/rcs/model[1]/rcs",500);
}


# modified function of smallsearch() from misc.nas
var searchdb = func(cs=nil) {
  var list = props.globals.getNode("/instrumentation/radar2/rcs").getChildren("model");
  var total = size(list);
  var mpid = 0;
  for(var i = 0; i < total; i += 1) {
      if (cs != nil) {
      # were searching for someone...
        if (getprop("instrumentation/radar2/rcs/model[" ~ i ~ "]/model") == cs) {
          # we have our number
          print(mpid);
          mpid = i;
          return getprop("instrumentation/radar2/rcs/model[" ~ i ~ "]/rcs");
        }
      }
   }
}



var getrcs = func(testing) {
    # Parameter is an object, Given from the radar
    var callsign = testing.get_Callsign(); # Get the callsign of the radar contact
    # Now ill use misc.nas get the mpid
    var mpid = misc.smallsearch(callsign);
    # Get the model
    var modelprop = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/sim/model/path");
    # this is the full path of the model. have to modify the string
    # placed a nil detection 
    if (modelprop == nil) {
        #print("modelprop is nil!");
        modelprop = nil;
        return 0; # Dont let the radar track an invalid model
    } else {
        # model property is not nothing. turn the full path into a single string. turns "Aircraft/f16/models/F-16.xml" into just "F-16" (hopefully)
        var thestring = io.basename(modelprop);
        thestring = string.truncateAt(thestring, ".xml");
        thestring = misc.finddel(thestring,"-model");
        thestring = misc.finddel(thestring,"-anim");
        #print(thestring);
        # Now that thestring is the raw aircraft model of the plane. run it in the RCS database, compute range, and maybe angle
        var rcs = searchdb(thestring);
        if (rcs == nil) {
            # No rcs
            return 1;
        } else {
            # RCS Given
            #print("RCS of: "~thestring~" : "~rcs~"");
            var rangenm = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm");
            # Calculate if we can see the target
            return 1;
        }
    }
#    return 0;
}

database();
print("crcs.nas: Ready!");
# -----------------------   End crcs.nas   ----------------------- #
# positional.nas
# This is my custom steerpoint and coordnite processing backend
# Ment to tie in with RAD.nas (front controls and datalink processing)
print("Loading positional.nas...");
setprop("f22/stpt/total",0);

var createnew = func(lat,lon,alt) {
    # nil check thingy
    var stptid = 0;
    if (getprop("f22/stpt/point[0]/inuse") != nil) {
        print("Points are available");
        #var list = props.globals.getNode("/f22/stpt").getChildren("point");
        #var total = size(list);

        var total = getprop("f22/stpt/total");
        # Switched it to property based totaling

        print(total); # Total is in fact our next value | if point[0] then total is 1. if theres point[0], and point[1] then its 2 total. so just add a point[total]\



        # for(var i = 0; i < total; i += 1) {
        #     print(i);
        # }
        setprop("f22/stpt/point[" ~ total ~ "]/inuse",1);
        setprop("f22/stpt/point[" ~ total ~ "]/lat",lat);
        setprop("f22/stpt/point[" ~ total ~ "]/lon",lon);
        setprop("f22/stpt/point[" ~ total ~ "]/alt",alt);
        stptid = total;
    } else {
        print("Creating a point...");
        setprop("f22/stpt/point[0]/inuse",1);
        setprop("f22/stpt/point[0]/lat",lat);
        setprop("f22/stpt/point[0]/lon",lon);
        setprop("f22/stpt/point[0]/alt",alt);
        stptid = 0;
    }
    screen.log.write("Created a new Steerpoint (STPT) With an ID of " ~ stptid ~ "",0,1,0);
    var total = getprop("f22/stpt/total");
    setprop("f22/stpt/total",total + 1);
}

# This function is to translate Latitutde and Longitude to displayable data!
var update = func() {
    if (getprop("f22/stpt/point[0]/inuse") != nil) {
        var list = props.globals.getNode("/f22/stpt").getChildren("point");
        var total = getprop("f22/stpt/total");
        for(var i = 0; i < total; i += 1) {
            #print(i);
            var lat = getprop("f22/stpt/point[" ~ i ~ "]/lat");
            var lon = getprop("f22/stpt/point[" ~ i ~ "]/lon");
            var alt = getprop("f22/stpt/point[" ~ i ~ "]/alt");
            if (alt == nil) {
                alt = 0;
            }
            alt = alt*FT2M;
            var ourcoord = geo.aircraft_position();
            var stpt = geo.Coord.new();
            stpt.set_latlon(lat, lon, alt);
            var range = ourcoord.direct_distance_to(stpt) * M2NM;
            setprop("f22/stpt/point[" ~ i ~ "]/range",range);
            var hdgtrue = ourcoord.course_to(stpt);

            # PRF Ranges

            if (getprop("controls/PRF/range") == 5){
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range);
            }
            if (getprop("controls/PRF/range") == 10){
            range = range / 2;
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range);
            }
            if (getprop("controls/PRF/range") == 20){
            range = range / 4;
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range);
            }
            if (getprop("controls/PRF/range") == 40){
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range / 6);
            }
            if (getprop("controls/PRF/range") == 60){
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range / 16);
            }
            if (getprop("controls/PRF/range") == 160){
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range / 30);
            }
            if (getprop("controls/PRF/range") == 360){
            setprop("f22/stpt/point[" ~ i ~ "]/rangeprf",range / 30);
            }
            setprop("f22/stpt/point[" ~ i ~ "]/hdg",hdgtrue);
            var ourhdg = getprop("/orientation/heading-deg"); # In true
            var therehdg = hdgtrue;
            var ans = ourhdg - therehdg;
           #if (ans < 0) {
           #  # negitive
           #  #screen.log.write("it be negitive");
           #  #ns = ans + 180;
           #}

            setprop("f22/stpt/point[" ~ i ~ "]/hdgprf",ans);

            if (i == getprop("f22/stpt/selected")) {
                setprop("f22/stpt/cursor/lat",lat);
                setprop("f22/stpt/cursor/lon",lon);
                setprop("f22/stpt/cursor/alt",alt);

                setprop("controls/radar/slots/lat",lat);
                setprop("controls/radar/slots/lon",lon);
                setprop("controls/radar/slots/alt",alt);

                setprop("f22/stpt/cursor/hdgprf",ans);
                setprop("f22/stpt/cursor/hdgtrue",hdgtrue);
                setprop("autopilot/settings/true-heading-deg",hdgtrue); # Autopilot :D
                setprop("f22/stpt/cursor/range",range);
                #setprop("f22/stpt/cursor/rangeprf",ans);
                if (getprop("controls/PRF/range") == 5){
                setprop("f22/stpt/cursor/rangeprf",range);
                }
                if (getprop("controls/PRF/range") == 10){
                range = range / 2;
                setprop("f22/stpt/cursor/rangeprf",range);
                }
                if (getprop("controls/PRF/range") == 20){
                range = range / 4;
                setprop("f22/stpt/cursor/rangeprf",range);
                }
                if (getprop("controls/PRF/range") == 40){
                setprop("f22/stpt/cursor/rangeprf",range / 6);
                }
                if (getprop("controls/PRF/range") == 60){
                setprop("f22/stpt/cursor/rangeprf",range / 16);
                }
                if (getprop("controls/PRF/range") == 160){
                setprop("f22/stpt/cursor/rangeprf",range / 30);
                }
                if (getprop("controls/PRF/range") == 360){
                setprop("f22/stpt/cursor/rangeprf",range / 30);
                }
            }
        }
    }
}

looptimer = maketimer(0.5,update);
looptimer.start();
print("positional.nas: Ready");
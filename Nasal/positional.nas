# Phoenix
# positional.nas
# Basically a steerpoint backend
print("Loading positional.nas...");


var createnew = func(lat,lon,alt) {
    # nil check thingy
    if (getprop("f22/stpt/point[0]/inuse") != nil) {
        print("Points are available");
        var list = props.globals.getNode("/f22/stpt").getChildren("point");
        var total = size(list);
        print(total); # next value
        # for(var i = 0; i < total; i += 1) {
        #     print(i);
        # }
        setprop("f22/stpt/point[" ~ total ~ "]/inuse",1);
        setprop("f22/stpt/point[" ~ total ~ "]/lat",lat);
        setprop("f22/stpt/point[" ~ total ~ "]/lon",lon);
        setprop("f22/stpt/point[" ~ total ~ "]/alt",alt);
    } else {
        print("Creating a point...");
        setprop("f22/stpt/point[0]/inuse",1);
        setprop("f22/stpt/point[0]/lat",lat);
        setprop("f22/stpt/point[0]/lon",lon);
        setprop("f22/stpt/point[0]/alt",alt);
    }
}

# This function is to translate Latitutde and Longitude to displayable data!
var update = func() {
    if (getprop("f22/stpt/point[0]/inuse") != nil) {
        var list = props.globals.getNode("/f22/stpt").getChildren("point");
        var total = size(list);
        for(var i = 0; i < total; i += 1) {
            #print(i);
            var lat = getprop("f22/stpt/point[" ~ i ~ "]/lat");
            var lon = getprop("f22/stpt/point[" ~ i ~ "]/lon");
            var alt = getprop("f22/stpt/point[" ~ i ~ "]/alt");
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
        }
    }
}

looptimer = maketimer(0.5,update);
looptimer.start();
print("positional.nas: Ready");
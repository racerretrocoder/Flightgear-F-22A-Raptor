# cms.nas
# Written by Phoenix
# F-22A Raptor countermessures controller

var programname = "No data";
var data1 = 0;
var data2 = 0;
var data3 = 0;
var data4 = 0;
var data5 = 0;
var data6 = 0;
var data7 = 0;
var data8 = 0;
var data9 = 0;
var data10 = 0;

var updatecms = func() {
    var prgmselect = getprop("/controls/CMS/prgmselected");
    if (prgmselect == 1) {var letter = "a";}
    if (prgmselect == 2) {var letter = "b";}
    if (prgmselect == 3) {var letter = "c";}
    if (prgmselect == 4) {var letter = "d";}
    if (prgmselect == 5) {var letter = "e";}
    programname = getprop("/controls/CMS/prgm"~prgmselect~"name");
    print(programname);
    data1 = getprop("controls/CMS/" ~ letter ~ "1");
    data2 = getprop("controls/CMS/" ~ letter ~ "2");
    data3 = getprop("controls/CMS/" ~ letter ~ "3");
    data4 = getprop("controls/CMS/" ~ letter ~ "4");
    data5 = getprop("controls/CMS/" ~ letter ~ "5");
    data6 = getprop("controls/CMS/" ~ letter ~ "6");
    data7 = getprop("controls/CMS/" ~ letter ~ "7");
    data8 = getprop("controls/CMS/" ~ letter ~ "8");
    data9 = getprop("controls/CMS/" ~ letter ~ "9");
    data10 = getprop("controls/CMS/" ~ letter ~ "10");
}


var release = func() {
    print("chaff/flare");
}



32.36068476
-64.79315182

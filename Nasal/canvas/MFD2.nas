print("Loading Center Canvas MFD...");

# 
# Canvas MFD System for The F-22A Raptor (Center)
#

# Copyright (c) Phoenix, Backdoor Interactive, 2026
# This code is "Ae" compatible.

mfdval = "/systems/MFD/modemfdc";


var ae = canvas.new({
  "name": "Center-MFD",   # The name is optional but allow for easier identification
  "size": [1024, 1024],   # Size of the underlying texture (should be a power of 2, required) [Resolution]
  "view": [768, 1024],   # Virtual resolution (Defines the coordinate system of the canvas [Dimensions]
                        # which will be stretched the size of the texture, required)
  "mipmapping": 1       # Enable mipmapping (optional)
});
var placements = {"mfd" : ae};

placements.mfd.addPlacement({"node": "centermfd"});
var mfd = placements.mfd;

var showmfd = func(screen='mfd') {
    if(getprop("sim/instrument-options/canvas-popup-enable"))
    {
        # The optional second arguments enables creating a window decoration
        var dlg = canvas.Window.new([400, 400], "dialog");
        dlg.setCanvas( placements[screen] );
    }
}
mfd.setColorBackground(0.00784, 0.00784, 0.0823);
var lables = mfd.createGroup();
  # FCR
var FCR = mfd.createGroup();
  # SMS
var SMS = mfd.createGroup();
  # RWR
var RWR = mfd.createGroup();
RWR.setScale(0.9,(math.pi -2) / 0.9);
RWR.setTranslation(37.5,160);
var FLT = mfd.createGroup();
var fcs = FLT.createChild("text", "fcs")
       .setTranslation(315, 240)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("FCS: NAV");
var aoa = FLT.createChild("text", "aoa")
       .setTranslation(125, 240)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("AOA: -180");
var gload = FLT.createChild("text", "aoa")
       .setTranslation(125, 280)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("G: 9.27");
  # ENG
var ENG = mfd.createGroup();
var fpv = ENG.createChild("group", "FPV");
# (xRadius,yRadius,0,xEnd,yEnd)
fpv.createChild("path") # RPM ENG1
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(275, 185)
       .arcLargeCW(45, 60, 0,  -45, 60);
fpv.createChild("path") # RPM ENG2
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(475, 185)
       .arcLargeCW(45, 60, 0,  -45, 60);

fpv.createChild("path") # EGT ENG1
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(275, 385)
       .arcLargeCW(45, 60, 0,  -45, 60);

fpv.createChild("path") # EGT ENG2
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(475, 385)
       .arcLargeCW(45, 60, 0,  -45, 60);

fpv.createChild("path") # OIL ENG1
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(275*2, 585*2)
       .arcLargeCW(45, 60, 0,  -45, 60)
       .setScale(0.5);

fpv.createChild("path") # OIL ENG2
       .setStrokeLineWidth(4)
       .set("stroke", "rgba(0,255,0,1)")
       .moveTo(475*2, 585*2)
       .arcLargeCW(45, 60, 0,  -45, 60)
       .setScale(0.5);
# engine text 
var eng1 = ENG.createChild("text", "engine")
       .setTranslation(345, 240)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("RPM");
var eng2 = ENG.createChild("text", "engine")
       .setTranslation(345, 440)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("EGT F");
var eng3 = ENG.createChild("text", "engine")
       .setTranslation(345, 620)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,1)             
       .setText("OIL PSI");
# Pointer thingies
#var rpm1 = ENG.createChild("path");
#rpm1.moveTo(275, 185)
#       .lineTo(275, 245) # right cursor barrier
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3)
#       .setCenter(275,245);
# doesnt work. I need to reskew the entire screen
var rpm1 = ENG.createChild("text", "engine")
       .setTranslation(225, 205)#(275, 185)     
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(22, 1.2)        
       .setColor(0,1,1)             
       .setText("100.0");
var rpm2 = ENG.createChild("text", "engine")
       .setTranslation(425, 205)#(475, 185) 
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(22, 1.2)        
       .setColor(0,1,1)             
       .setText("100.0");
var egt1 = ENG.createChild("text", "engine")
       .setTranslation(225, 405)#((275, 385)) 
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(22, 1.2)        
       .setColor(0,1,1)             
       .setText("9999");
var egt2 = ENG.createChild("text", "engine")
       .setTranslation(425, 405)#(475, 385) 
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(22, 1.2)        
       .setColor(0,1,1)             
       .setText("9999");
# SMS stuff
var wepname = SMS.createChild("text", "wepname")
       .setTranslation(375, 675)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(36, 1.2)        
       .setColor(0,1,1)             
       .setText("Select a weapon");

var chaff = SMS.createChild("text", "chaff")
       .setTranslation(160, 275)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");
var flare = SMS.createChild("text", "flare")
       .setTranslation(510, 275)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");
var prgm = SMS.createChild("text", "prgm")
       .setTranslation(210, 755)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");
var prgmname = SMS.createChild("text", "prgmname")
       .setTranslation(210, 845)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs1 = SMS.createChild("text", "cs")
       .setTranslation(180, 375)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs2 = SMS.createChild("text", "cs")
       .setTranslation(180, 405)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs3 = SMS.createChild("text", "cs")
       .setTranslation(180, 435)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs4 = SMS.createChild("text", "cs")
       .setTranslation(180, 465)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs5 = SMS.createChild("text", "cs")
       .setTranslation(480, 375)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs6 = SMS.createChild("text", "cs")
       .setTranslation(480, 405)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs7 = SMS.createChild("text", "cs")
       .setTranslation(480, 435)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var cs8 = SMS.createChild("text", "cs")
       .setTranslation(480, 465)    
       .setAlignment("left-center") 
       .setFont("B612/B612-Bold.ttf") 
       .setFontSize(28, 1.2)        
       .setColor(0,1,0)             
       .setText("");

var FCRCursor = mfd.createGroup();
var pathA = FCR.createChild("path");
var adi = FCR.createChild("path");
var cursor = FCR.createChild("path");


# fcr blippies
var blip1 = FCR.createChild("path");
var blip2 = FCR.createChild("path");
var blip3 = FCR.createChild("path");
var blip4 = FCR.createChild("path");
var blip5 = FCR.createChild("path");
var blip6 = FCR.createChild("path");
var blip7 = FCR.createChild("path");
var blip8 = FCR.createChild("path");
var blip9 = FCR.createChild("path");
var blip10 = FCR.createChild("path");
var blip11 = FCR.createChild("path");
var blip12 = FCR.createChild("path");
var blip13 = FCR.createChild("path");
var blip14 = FCR.createChild("path");
var blip15 = FCR.createChild("path");
var blip16 = FCR.createChild("path");
var blip17 = FCR.createChild("path");
var blip18 = FCR.createChild("path");
var blip19 = FCR.createChild("path");
var blip20 = FCR.createChild("path");

var bliparray = [blip1,blip2,blip3,blip4,blip5,blip6,blip7,blip8,blip9,blip10,blip11,blip12,blip13,blip14,blip15,blip16,blip17,blip18,blip19,blip20]; # really bad, but untill i learn a better way, this works xdd
# render the blips early
for(var ae = 0; ae < 20; ae += 1) {
       bliparray[ae].moveTo(375, 580) #
              .lineTo(375, 590) # draw a teeny tiny dash on the screen
              .set("stroke", "#FFFFFF") 
              .set("stroke-width", 10);
       # now hide it
       bliparray[ae].setVisible(0);
}


# render the cursor
cursor.moveTo(365, 605)
       .lineTo(365, 645) # left cursor barrier
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
cursor.moveTo(385, 605)
       .lineTo(385, 645) # right cursor barrier
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);





# Cursor limits:
# X=315 Y=355 This is the bottom right corner
# X=-315 Y=-355 This is the top right corner


# X= 50 to 700, so 650 units of movement for the cursor
# middle is 325
# Y= 210 to 960
# middle is
# Radar screen pattern
pathA.moveTo(50, 210)
       .lineTo(700,210) # horiz(650);
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
pathA.moveTo(50, 210)
       .lineTo(50,960)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
pathA.moveTo(700, 210)
       .lineTo(700,960)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
pathA.moveTo(50, 960)
       .lineTo(700,960)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
# That draws the square

# Now for range lines
# 4 Lines

#pathA.moveTo(50, 810)
#       .lineTo(700,810)
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3);
#pathA.moveTo(50, 660)
#       .lineTo(700,660)
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3);
#pathA.moveTo(50, 510)
#       .lineTo(700,510)
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3);
#pathA.moveTo(50, 360) 
#       .lineTo(700,360)
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3);


# 3 Lines
pathA.moveTo(50, 397.5) # 25% on Y
       .lineTo(700,397.5)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);


#pathA.moveTo(50, 585) # 50% on Y
#       .lineTo(700,585) 
#       .set("stroke", "#00FF00") 
#       .set("stroke-width", 3);


# Account for blanking point!

pathA.moveTo(50, 585) # +-60
       .lineTo(315,585) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);

pathA.moveTo(435, 585) # +-60
       .lineTo(700,585) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);


# Draw the attitude indicator

adi.moveTo(100, 585) 
       .lineTo(315,585) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
adi.moveTo(435, 585) 
       .lineTo(650,585) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
adi.moveTo(650, 585)
       .lineTo(650,605) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
adi.moveTo(100, 585) # Make the edge of them point down
       .lineTo(100,605) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);



pathA.moveTo(50, 772.5) # 75% on Y
       .lineTo(700,772.5) 
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
# Verticals

# Account for the blanking point!
pathA.moveTo(375, 210) # lower cross bound
       .lineTo(375, 525) # middle y is 585, go - 60 from middle
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);

pathA.moveTo(375, 645) # upper cross bound
       .lineTo(375, 960) # middle y is 585, go + 60 from middle
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);



pathA.moveTo(212.5, 210)  # left bound
       .lineTo(212.5,960)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);
pathA.moveTo(537.5, 210)  # right bound
       .lineTo(537.5,960)
       .set("stroke", "#00FF00") 
       .set("stroke-width", 3);

var radstb = FCR.createChild("text", "standby")
                .setTranslation(310, 440)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)         
                .setColor(0,1,0)              
                .setText("test");



# Top Lables - left to right
var m1 = lables.createChild("text", "m1")
                .setTranslation(75, 999)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)  
                .setText("MODE");

var m2 = lables.createChild("text", "m2")
                .setTranslation(230, 999)    
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("PRF");

var m3 = lables.createChild("text", "m3")
                .setTranslation(355, 999)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)         
                .setColor(1,1,1)              
                .setText("MENU");

var m4 = lables.createChild("text", "m4")
                .setTranslation(510, 999)     
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf")
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("FLT");

var m5 = lables.createChild("text", "m5")
                .setTranslation(645, 999)    
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)     
                .setColor(0,1,0)            
                .setText("POWER");


# Left side lables - top to bottom
var l1 = lables.createChild("text", "l1")
                .setTranslation(35, 175)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("ENG");

var rng = lables.createChild("text", "rng")
                .setTranslation(55, 275)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("");

var l2 = lables.createChild("text", "l2")
                .setTranslation(35, 375)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("FUEL");
var l3 = lables.createChild("text", "l3")
                .setTranslation(35, 575)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("SMS");
var l4 = lables.createChild("text", "l4")
                .setTranslation(35, 775)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("FCR");

var l5 = lables.createChild("text", "l5")
                .setTranslation(35, 975)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("");

# Right button lables, from top to bottom (again)

var r1 = lables.createChild("text", "r1")
                .setTranslation(695, 175)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("DTC");
var r2 = lables.createChild("text", "r2")
                .setTranslation(695, 375)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("FLT");
var r3 = lables.createChild("text", "r3")
                .setTranslation(695, 575)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("WEP");
var r4 = lables.createChild("text", "r4")
                .setTranslation(695, 775)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("RWR");
var r5 = lables.createChild("text", "r5")
                .setTranslation(695, 975)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("");





var update = func() {
  # Main loop xd
  var cradx = getprop("fdm/jsbsim/fcs/cradx");
  var cradz = getprop("fdm/jsbsim/fcs/cradz");
  if (cradx == nil) {
       cradx = 0;
  }
  if (cradz == nil) {
       cradz = 0;
  }
  cursor.setTranslation(cradx,cradz); 


  if (getprop(mfdval) == 2) { # FCR Scripting
    SMS.setVisible(0);
    RWR.setVisible(0);
    ENG.setVisible(0);
    FCR.setVisible(1); # engage the fcr 
    adi.setCenter(375,585);
    
    # ok heres the deal on rotation, math.pi is 360 deg, So pi and -pi will result in the same thing, a 360 turn clockwise and counter-clockwise.
    var rolldeg = getprop("orientation/roll-deg");
    var ptchdeg = getprop("orientation/pitch-deg");
    var rollscaled = misc.scalenum(rolldeg, -360, 360, -2*math.pi, 2*math.pi);
    var ptchscaled = misc.scalenum(ptchdeg, -90, 90, 375, -375);
    adi.setRotation(rollscaled);
    adi.setTranslation(0,ptchscaled);


    var radarmode = getprop("instrumentation/radar/mode/main");
    var radarzoom = getprop("instrumentation/radar/mode/zoom");
    var radarrang = getprop("instrumentation/radar/range");
    if (radarmode == 0) {
       r1.setText("TWS");
    }
    if (radarmode == 1) {
       r1.setText("RWS");
    }
    if (radarmode == 2) {
       r1.setText("ACM");
    }
    if (radarmode == 3) {
       # side looking rads
       r1.setText("SLR");
    }
    if (radarmode == 5) {
       # ag
       r1.setText("AG");
    }
    if (radarmode == 4) {
       # jammer
       r1.setText("JAM");
    }
    if (radarzoom == 1) {
       r2.setText("EXP");
    } else {
       r2.setText("NORM");
    }
    r3.setText("");
    r4.setText("");
    r5.setText("");
    l1.setText("↑");
    l2.setText("↓");
    l3.setText("");
    l4.setText("");
    l5.setText("");
    rng.setText(sprintf("%d", radarrang));
    if (getprop("su-27/instrumentation/N010-radar/emitting") == 0) {
      radstb.setText("RADAR STANDBY");
    } else {
       radstb.setText("");
       #print("The radar is active!");
       # Blip rendering
       var list = props.globals.getNode("/instrumentation/radar2/marker").getChildren("mark");
       var total = size(list);
       var mpid = 0;
       for(var i = 0; i < total; i += 1) {
              # Create a blip
              var mpstr = "/instrumentation/radar2/marker/mark[" ~ i ~ "]";
              if (getprop(""~mpstr~"/display") == 1) {
                     bliparray[i].setVisible(1);
                     var locx = getprop("instrumentation/radar2/marker/mark["~i~"]/location-x"); # this is -10 to 10 btw
                     var locz = getprop("instrumentation/radar2/marker/mark["~i~"]/range"); # the range is 0 - 10
                     if (locx == nil) {
                            locx = 0;
                     }
                     if (locz == nil) {
                            locz = 0;
                     }
                     
                     # locx has -10 for full left, +10 for full right, 0 for the center xd
                     # locz has 0 to 10 for range, lets say the radar range was 40, 0 would be 0nm, 5 would be 20nm, 10 would be 40nm away
                     # The blip exists and it probably needs to be updated (maybe)
                     # X=315 Y=355 This is the bottom right corner
                     # X=-315 Y=-355 This is the top right corner
                     
                     # scaling

                     # very complex, cant use jsbsim to scale no more, so ae
                     scaledX = misc.scalenum(locx, -10, 10, -315, 315); #  yae
                     scaledZ = misc.scalenum(-locz, 0, -10, -355, 355); #ae
                     scaledZ = (355 - scaledZ) - (355 / 2) - (355 / 4) - (355 / 8); # ae, ae, ae??   yae! thingy thingy thingy ae thingy ae thingy nae.   nae.    ...  nae. turns out you have to subtract half of the screen instead of adding it
                    #print("scaledz"); # ae
                    #print(scaledZ);
                    #print("scaledX");
                    #print(scaledX);
                    #print("we scaled xd"); # ae
                     # nae
                     bliparray[i].setTranslation(scaledX,scaledZ); # ae
              } else {
                     # disappeared
                     bliparray[i].setVisible(0);
                     bliparray[i].setTranslation(0,0);
              }
       }
    }
  } elsif (getprop(mfdval) == 0) {
       # main page
       ENG.setVisible(0);
       RWR.setVisible(0);
       FCR.setVisible(0);
       SMS.setVisible(0);
       FLT.setVisible(0);
       r1.setText("DTC");
       r2.setText("FLT");
       r3.setText("WEP");
       r4.setText("RWR");
       r5.setText("");
       l1.setText("ENG");
       l2.setText("FUEL");
       l3.setText("SMS");
       l4.setText("FCR");
       l5.setText("");
       rng.setText("");
  } elsif (getprop(mfdval) == 1) {
       # SMS
       FCR.setVisible(0);
       ENG.setVisible(0);
       RWR.setVisible(0);
       SMS.setVisible(1);
       FLT.setVisible(0);
       flare.setText("");
       chaff.setText("");
       prgm.setText("");
       prgmname.setText("");
       cs1.setText("");
       cs2.setText("");
       cs3.setText("");
       cs4.setText("");
       cs5.setText("");
       cs6.setText("");
       cs7.setText("");
       cs8.setText("");
       wepname.setText(getprop("controls/armament/selected-weapon"));
       r1.setText("");
       r2.setText("");
       r3.setText("");
       r4.setText("AUTO");
       r5.setText("ADEP");
       l1.setText("A/A");
       l2.setText("A/G");
       l3.setText("CMS");
       l4.setText("XAM");
       l5.setText("ECM");
       rng.setText("");
  } elsif (getprop(mfdval) == 9) {
       # SMS --> CMS
       FCR.setVisible(0);
       SMS.setVisible(1);
       wepname.setText("");
       flare.setText("Flare: " ~ sprintf("%d", getprop("f22/flare")) ~ "");
       chaff.setText("Chaff: " ~ sprintf("%d", getprop("f22/chaff")) ~ "");
       prgm.setText("Program: " ~ sprintf("%d", getprop("controls/CMS/prgmselected")) ~ "");
       prgmname.setText("Program Name: " ~ getprop("controls/CMS/prgmname") ~ "");
       r1.setText("");
       r2.setText("");
       r3.setText("");
       r4.setText("");
       r5.setText("");
       l1.setText("1");
       l2.setText("2");
       l3.setText("3");
       l4.setText("4");
       l5.setText("5");
       rng.setText("");
  } elsif (getprop(mfdval) == 80) { 
       # SMS --> Multishot
       r1.setText("");
       r2.setText("");
       r3.setText("");
       r4.setText("");
       r5.setText("");
       l1.setText("RADAR");
       l2.setText("NEXT");
       l3.setText("PREV");
       l4.setText("RSET");
       l5.setText("TOGL");
       rng.setText("");
       flare.setText("");
       chaff.setText("");
       prgm.setText("" ~ getprop("controls/armament/multishot/message"));
       prgmname.setText("Editing Target / Trigger will fire " ~ sprintf("%d", getprop("controls/armament/multishot/numcallsign")) ~ " weapons");

       cs1.setText(getprop("controls/armament/multishot/callsign1"));
       cs2.setText(getprop("controls/armament/multishot/callsign3"));
       cs3.setText(getprop("controls/armament/multishot/callsign5"));
       cs4.setText(getprop("controls/armament/multishot/callsign7"));

       cs5.setText(getprop("controls/armament/multishot/callsign2"));
       cs6.setText(getprop("controls/armament/multishot/callsign4"));
       cs7.setText(getprop("controls/armament/multishot/callsign6"));
       cs8.setText(getprop("controls/armament/multishot/callsign8"));
       wepname.setText("");
       


  } elsif (getprop(mfdval) == 5) { 
    FCR.setVisible(0);
    SMS.setVisible(0);
    ENG.setVisible(0);
    FLT.setVisible(0);
    RWR.setVisible(1);
    r1.setText("");
    r2.setText("");
    r3.setText("");
    r4.setText("");
    r5.setText("");
    l1.setText("");
    l2.setText("");
    l3.setText("");
    l4.setText("");
    l5.setText("");   
  } elsif (getprop(mfdval) == 4) { 
    FCR.setVisible(0);
    SMS.setVisible(0);
    ENG.setVisible(0);
    FLT.setVisible(1);
    RWR.setVisible(0);
    r1.setText("");
    r2.setText("");
    r3.setText("");
    r4.setText("");
    r5.setText("");
    l1.setText("");
    l2.setText("");
    l3.setText("");
    l4.setText("");
    l5.setText("");
    aoa.setText("AOA: " ~ sprintf("%d", getprop("/orientation/alpha-deg")) ~ "");
    gload.setText("G: " ~ sprintf("%d", getprop("/accelerations/pilot-gdamped")) ~ "");
  } elsif (getprop(mfdval) == 7) { # ENG 
    FCR.setVisible(0);
    SMS.setVisible(0);
    RWR.setVisible(0);
    FLT.setVisible(0);
    ENG.setVisible(1);
    r1.setText("");
    r2.setText("");
    r3.setText("");
    r4.setText("");
    r5.setText("");
    l1.setText("");
    l2.setText("");
    l3.setText("");
    l4.setText("");
    l5.setText("");
    rpm1.setText(sprintf("%d", getprop("/fdm/jsbsim/fcs/effected0n1")));
    rpm2.setText(sprintf("%d", getprop("/fdm/jsbsim/fcs/effected1n1")));
    egt1.setText(sprintf("%d", getprop("/engines/engine[0]/egt-degf")));
    egt2.setText(sprintf("%d", getprop("/engines/engine[1]/egt-degf")));
  } else {
    #print("No FCR Screen");
    FCR.setVisible(0);
  }
  #print("End of update loop");
  settimer(func update(), 0);
}

# Copied from the HUD
var init = setlistener("/sim/signals/fdm-initialized", func() {
  removelistener(init); # only call once
  if (getprop("sim/signals/fdm-initialized") == 1) {
     var therwr = rwrs.RWRCanvas.new("RWRCanvas", RWR, [375,585/2],768);
     timer = maketimer(0.5, func therwr.update());
     timer.start();
   }
  update();
});
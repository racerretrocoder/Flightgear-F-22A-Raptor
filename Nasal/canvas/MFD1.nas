print("Loading Left Canvas MFD...");

# 
# Canvas MFD System for The F-22A Raptor (Left)
#

# Copyright (c) Phoenix, Backdoor Interactive, 2026
# This code is "Ae" compatible.

mfdval = "/systems/MFD/modemfdl";

var mfd = canvas.new({
  "name": "Left-MFD",   # The name is optional but allow for easier identification
  "size": [1024, 1024],   # Size of the underlying texture (should be a power of 2, required) [Resolution]
  "view": [768, 1024],   # Virtual resolution (Defines the coordinate system of the canvas [Dimensions]
                        # which will be stretched the size of the texture, required)
  "mipmapping": 1       # Enable mipmapping (optional)
});

mfd.addPlacement({"node": "leftmfd"});
mfd.setColorBackground(0.00784, 0.00784, 0.0823);

var lables = mfd.createGroup();
  # FCR
var FCR = mfd.createGroup();
var FCRCursor = mfd.createGroup();
var pathA = FCR.createChild("path");
var cursor = FCR.createChild("path");


# b l i p ssssss
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
              .lineTo(375, 590) # right cursor barrier
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

var standby = FCR.createChild("text", "standby")
                .setTranslation(340, 340)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)         
                .setColor(0,1,0)              
                .setText("APG-88V2 AESA - VERSION 13743737423ABDS");



# Lables
var m1 = lables.createChild("text", "m1")
                .setTranslation(60, 130)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(1,1,1)             
                .setText("MENU");

var m2 = lables.createChild("text", "m2")
                .setTranslation(200, 130)    
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("SMS");

var m3 = lables.createChild("text", "m3")
                .setTranslation(340, 130)      
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)         
                .setColor(0,1,0)              
                .setText("PRF");

var m4 = lables.createChild("text", "m4")
                .setTranslation(480, 130)     
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf")
                .setFontSize(22, 1.2)        
                .setColor(0,1,0)             
                .setText("ENG");

var m5 = lables.createChild("text", "m5")
                .setTranslation(610, 130)    
                .setAlignment("left-center") 
                .setFont("B612/B612-Bold.ttf") 
                .setFontSize(22, 1.2)     
                .setColor(0,1,0)            
                .setText("FUEL");


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
    FCR.setVisible(1);
    if (getprop("instrumentation/radar/radar-standby") == 1) {
      standby.setText("RADAR STANDBY");
    } else {
       standby.setText("");
       print("The radar is active!");
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
                     print("scaledz"); # ae
                     print(scaledZ);
                     print("scaledX");
                     print(scaledX);
                     print("we scaled xd"); # ae
                     # nae
                     bliparray[i].setTranslation(scaledX,scaledZ); # ae
              } else {
                     # disappeared
                     bliparray[i].setVisible(0);
                     bliparray[i].setTranslation(0,0);
              }
       }




    }
  } else {
    print("No FCR Screen");
    FCR.setVisible(0);
  }
  print("End of update loop");
  settimer(func update(), 0);
}

# Copied from the HUD
var init = setlistener("/sim/signals/fdm-initialized", func() {
  removelistener(init); # only call once
  screen.log.write("To test out the new canvas MFD system: press / go into f22 and set canvasmfds to 1",1,1,0);
  update();
  
});

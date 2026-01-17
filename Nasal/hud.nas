#==============================================================================
					# F22 hud
          # Origanle from SU-27SK Yanes Bechir
#==============================================================================
setprop("f22/vva",7.5);
setprop("f22/vvb",8.5);
setprop("f22/vvad",0);
setprop("f22/vvbd",20); # vv offset
setprop("f22/hudx",26);
setprop("f22/hudz",19);
var pow2 = func(x) { return x * x; };
var vec_length = func(x, y) { return math.sqrt(pow2(x) + pow2(y)); };
var round0 = func(x) { return math.abs(x) > 0.01 ? x : 0; };
var clamp = func(x, min, max) { return x < min ? min : (x > max ? max : x); };
var Kts2KmH = func(x){if(x!= nil){return x * 1.85283} else {return 0} };
var KmH2Kts = func(x){return x * 0.53995};
var ft2m = func(x){if(x!= nil){return x * 0.3048}else {return 0}};
var m2ft = func(x){return x * 3.2808};
var OurRoll           = props.globals.getNode("orientation/roll-deg");
var HUD = {
  canvas_settings: {
    "name": "HUD",
    "size": [1024,1024],
    "view": [256,256],
    "mipmapping": 0
  },
  new: func(placement)
  {
    var m = {
      parents: [HUD],canvas: canvas.new(HUD.canvas_settings)};
      
    
 
    m.canvas.addPlacement(placement);
    m.canvas.setColorBackground(0.36, 1, 0.3, 0.00);
 
    m.root =
      m.canvas.createGroup()
              .setScale(1, 1/math.cos(25 * math.pi/180))
              .setTranslation(0, 0)
              .set("font", "LiberationFonts/LiberationMono-Regular.ttf")
              .setDouble("character-size", 18)
              .setDouble("character-aspect-ration", 0.9)
              .set("stroke", "rgba(0,255,0,0.9)");
#m.ccipGrp = m.canvas.createGroup();
#            me.centerOrigin = hudmath.HudMath.getCenterOrigin();
#            me.ccipGrp.setTranslation(me.centerOrigin);
#            me.pipperRadius = 10;
#            me.ccipPipper = me.ccipGrp.createChild("path")
#                          .moveTo(-me.pipperRadius,0)
#                          .arcSmallCW(me.pipperRadius,me.pipperRadius, 0, me.pipperRadius*2, 0)
#                          .arcSmallCW(me.pipperRadius,me.pipperRadius, 0, -me.pipperRadius*2, 0)
#                          .moveTo(-1,0)
#                          .arcSmallCW(1,1, 0, 1*2, 0)
#                          .arcSmallCW(1,1, 0, -1*2, 0)                   
#                          .setStrokeLineWidth(1)
#                          .setColor(0,1,0);
#            me.ccipCross = me.ccipGrp.createChild("path")
#                          .moveTo(-m.pipperRadius, -m.pipperRadius)
#                           .lineTo(m.pipperRadius, m.pipperRadius)
#                           .moveTo(-m.pipperRadius, m.pipperRadius)
#                           .lineTo( m.pipperRadius, -m.pipperRadius)                  
#                          .setStrokeLineWidth(1)
#                          .hide()
#                          .setColor(0,1,0);
#            m.ccipLine = m.ccipGrp.createChild("group");
              
    #######################
    var filename = "Aircraft/F-22/Models/Interior/Instruments/hud/F-22-HUD.svg";
    # Create a group for the parsed elements
    
    m.svg = m.canvas.createGroup();
    canvas.parsesvg(m.svg, filename);
    m.svg.setTranslation(9,0);
	m.svg.setScale(1);
	#m.EnRouteGroup = m.get_element("EnRoute");
	m.attitudeInd =m.get_element("Attitude");
    m.HdgScale = m.get_element("heading-scale"); 
    m.NavDirector = m.get_element("Nav-director");
    m.Rdr_Indicator = m.get_element("Rdr-Indicator");
    m.accel_pointer = m.get_element("accel-pointer");
    m.NavDirector= m.get_element("NavDirector");
    m.Glidingpath = m.get_element("Glidingpath");
    m.locIndicator = m.get_element("Localizer-sign");
    m.GSIndicator = m.get_element("GS-sign");
    m.modeEnRte = m.get_element("Rte-Mode-indic");
    m.modeRtn = m.get_element("Rtn-Mode-indic");
    m.modeLndg = m.get_element("Ldng-Mode-indic");

    m.speedtape = m.get_element("ias_range");
    m.alttape = m.get_element("alt_range");
        m.bomb_sight = m.get_element("bomb_sight");
    m.tgt1Marker = m.get_element("tgt1-marker");
    m.tgt2Marker = m.get_element("tgt2-marker");
    m.tgt3Marker = m.get_element("tgt3-marker");
    m.tgt4Marker = m.get_element("tgt4-marker");
    m.tgt5Marker = m.get_element("tgt5-marker");
    m.tgt6Marker = m.get_element("tgt6-marker");
    m.tgt7Marker = m.get_element("tgt7-marker");
    m.tgt8Marker = m.get_element("tgt8-marker");
    m.tgt9Marker = m.get_element("tgt9-marker");
    m.tgt10Marker = m.get_element("tgt10-marker");
    m.lockMarker = m.get_element("lock-marker");
    m.VV = m.get_element("VelocityVector");
  
    #########################################    
    m.text =
      m.root.createChild("group")
            .set("fill", "rgba(0,255,0,0.9)");
        


 #Coordinares are from top left .setTranslation(left,Top)

# heading
    m.headingind =
      m.text.createChild("text")
        .setAlignment("center-top")
        .setTranslation(130,24)#(left,Top)
        #.setFont("Liberation Sans Narrow")
        .setFontSize(06,0.5);


    # Airspeed
   #m.airspeed =
   #  m.text.createChild("text")
   #        .setAlignment("center-top")
   #        .setTranslation(30,100)#(left,Top)
   #        #.setFont("Liberation Sans Narrow")
   #        .setFontSize(06,0.5);
   #        
    #AP Airspeed Setting
    m.machspeed =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(30,190)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
    m.gmeter =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(30,198)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
   m.aoaind =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(30,206)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
   m.pullup =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(130,106)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
   m.bingoind =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(130,086)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
   m.callsignind =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(210,206)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
   m.gunammo =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(210,190)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(04,0.4);
#    # Altitude
    #m.altitude =
    #  m.text.createChild("text")
    #        .setAlignment("center-top")
    #        .setTranslation(233,100) #(left,Top)
    #        .setFontSize(06,0.5);
    #        
    #AP Altitude Setting
    m.APaltitude =
      m.text.createChild("text")
            .setAlignment("center-top")
            .setTranslation(220,15)#(left,Top)
            #.setFont("Liberation Sans Narrow")
            .setFontSize(12,1.4);

		# Pitch
    m.pitch =
      m.text.createChild("text")
            .setFontSize(8, 0.9)
            .setAlignment("right-center")
            .setTranslation(180, -5);
            
#    # Remaining LEG/Nav distance
    m.DistTo =
      m.text.createChild("text")
            .setAlignment("center-bottom")
            .setTranslation(140,180)
            .setFontSize(12,0.80);
 
    # Radar altidude
    m.rad_alt =
      m.text.createChild("text")
            .setAlignment("right-center")
            .setTranslation(220, 70);
 
    # Horizon
    m.horizon_group = m.root.createChild("group");
    m.h_trans = m.horizon_group.createTransform();
    m.h_rot   = m.horizon_group.createTransform();
 
  
 
    # Horizon line
 #  m.horizon_group.createChild("path")
 #                 .moveTo(51, 0)
 #                 .horizTo(200)
 #                 .setStrokeLineWidth(1.0);

           me.pipperRadius = 10;
              me.centerOrigin = hudmath.HudMath.getCenterOrigin();

m.ccipGrp = m.root.createChild("group");

           m.ccipGrp.setTranslation(me.centerOrigin);

           m.ccipPipper = m.ccipGrp.createChild("path")
                         .moveTo(-me.pipperRadius,0)
                         .arcSmallCW(me.pipperRadius,me.pipperRadius, 0, me.pipperRadius*2, 0)
                         .arcSmallCW(me.pipperRadius,me.pipperRadius, 0, -me.pipperRadius*2, 0)
                         .moveTo(-1,0)
                         .arcSmallCW(1,1, 0, 1*2, 0)
                         .arcSmallCW(1,1, 0, -1*2, 0)                   
                         .setStrokeLineWidth(1)
                         .setColor(0,1,0);
           m.ccipCross = m.ccipGrp.createChild("path")
                         .moveTo(-m.pipperRadius, -m.pipperRadius)
                          .lineTo(m.pipperRadius, m.pipperRadius)
                          .moveTo(-m.pipperRadius, m.pipperRadius)
                          .lineTo( m.pipperRadius, -m.pipperRadius)                  
                         .setStrokeLineWidth(1)
                         .hide()
                         .setColor(0,1,0);
           m.ccipLine = m.ccipGrp.createChild("group");



    m.input = {
		pitch:      "/orientation/pitch-deg",
		roll:       "/orientation/roll-deg",
		hdg:        "/orientation/heading-magnetic-deg",
		speed_n:    "velocities/speed-north-fps",
		speed_e:    "velocities/speed-east-fps",
		speed_d:    "velocities/speed-down-fps",
		alpha:      "/orientation/alpha-deg",
		beta:       "/orientation/side-slip-deg",
		ias:        "velocities/airspeed-kt",
		altitude:   "position/altitude-ft",	#PNK altitude
		vs:         "/velocities/vertical-speed-fps",
		rad_alt:    "/instrumentation/radar-altimeter/radar-altitude-ft",
		airspeed:   "velocities/airspeed-kt",
		mach:   "velocities/mach",
    gdamped: "accelerations/pilot-gdamped",
		target_spd  : "/autopilot/settings/target-speed-kt",
		target_alt  : "/autopilot/settings/target-altitude-ft",
		PNK_Mode	: "su-27/instrumentation/PNK-10/active-mode",
		NavInRange  : "instrumentation/nav/in-range",
		Is_LOC	    : "instrumentation/nav/frequencies/is-localizer-frequency",
		NavCrossTrackErr : "instrumentation/nav/crosstrack-error-m",
		Gs_InRange  : "instrumentation/nav/gs-in-range",
		GS_Deflection : "instrumentation/nav/gs-needle-deflection-norm",
		acc:        "/fdm/jsbsim/accelerations/udot-ft_sec2",
		route_active 		 :	"autopilot/route-manager/active",
		route_deflection	 :	"instrumentation/gps/cdi-deflection",
		DistanceToWP 	  	 :	"autopilot/route-manager/wp/dist",
		DME_Distance 	  	 :	"instrumentation/dme/indicated-distance-nm",
		DME_InRange			 :	"instrumentation/dme/in-range",
	wp_alt					 :	"instrumentation/gps/wp/wp/altitude-ft",
	radar_on 			 	 :	"f22/instrumentation/N010-radar/emitting",
		target_0x  			 :	"/instrumentation/radar/ai/models/aircraft/radar/x-shift",
		target_0z  			 :	"instrumentation/radar/ai/models/aircraft/radar/h-offset",
		target_0_inrange 	 :	"instrumentation/radar/ai/models/aircraft/radar/in-range",
		targetvalid			 :	"ai/models/aircraft/valid",		# Unused for now !!
    };
 


 
    foreach(var name; keys(m.input))
      m.input[name] = props.globals.getNode(m.input[name], 1);
 
    return m;
  },
  
 # Get an element from the SVG; handle errors; and apply clip rectangle
# if found (by naming convention : addition of _clip to object name).
    get_element : func(id) {
        var el = me.svg.getElementById(id);
        if (el == nil)
        {
            print("Failed to locate ",id," in SVG");
            return el;
        }
        var clip_el = me.svg.getElementById(id ~ "_clip");
        if (clip_el != nil)
        {
            clip_el.setVisible(0);
            var tran_rect = clip_el.getTransformedBounds();

            var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
                                   tran_rect[1], # 0 ys
                                   tran_rect[2],  # 1 xe
                                   tran_rect[3], # 2 ye
                                   tran_rect[0]); #3 xs
#            print(id," using clip element ",clip_rect, " trans(",tran_rect[0],",",tran_rect[1],"  ",tran_rect[2],",",tran_rect[3],")");
#   see line 621 of simgear/canvas/CanvasElement.cxx
#   not sure why the coordinates are in this order but are top,right,bottom,left (ys, xe, ye, xs)
            el.set("clip", clip_rect);
            el.set("clip-frame", canvas.Element.PARENT);
        }
        return el;
    },




  update: func()
  {
  var HudPower = getprop("systems/electrical/outputs/ILS-31HUD") or 0;
  var hudSwitch = getprop("controls/switches/ILS-31HUD") or 0;
  var once = 0;

  
 if (HudPower > 18){
		me.root.hide();
		me.svg.hide();
		print ("No hud");
#		return;
}
	else{
		me.root.show();
		me.svg.show();
#	print ("SEE hud");
		}

    me.attitudeInd.setVisible(0);
    me.attitudeInd.setScale(1,1);
    var rot = -me.input.roll.getValue() * math.pi / 180.0;
    var pitch_factor=22.18;
    var ptch = 392+ me.input.pitch.getValue() * pitch_factor;
    me.attitudeInd.setTranslation(0,ptch);
    me.attitudeInd.setRotation(rot);
    if (me.input.pitch.getValue()>0) {
           me.attitudeInd.setCenter(110,900-me.input.pitch.getValue()*(1815/90));
    }

     else{
        me.attitudeInd.setCenter(110,900+me.input.pitch.getValue()*-(1815/90));
     }
    me.gmeter.setText(sprintf("G %1.1f", me.input.gdamped.getValue()));
    me.aoaind.setText(sprintf("A %1.2f", me.input.alpha.getValue()));
    me.bingoind.setText("BINGO FUEL");
    me.pullup.setText("PULL UP");
    me.gunammo.setText(sprintf("GUNS %1.0f", getprop("ai/submodels/submodel[1]/count")));
    me.callsignind.setText(sprintf("RADAR %s", getprop("controls/radar/lockedcallsign")));
    me.machspeed.setText(sprintf("M %1.2f", me.input.mach.getValue()));
    #me.airspeed.setText(sprintf("%d", me.input.ias.getValue()));
    me.headingind.setText(sprintf("%d", me.input.hdg.getValue()));
    #me.altitude.setText(sprintf("%d", me.input.altitude.getValue()));
    var VVx = (me.input.beta.getValue() * getprop("f22/vvb")) + getprop("f22/vvad"); # adjust for view
    var VVy = (me.input.alpha.getValue() * getprop("f22/vva")) + getprop("f22/vvbd"); # adjust for view
    me.VV.setTranslation (VVx,VVy);


      var weaponmode = 0;
      var msltyp = getprop("controls/armament/selected-weapon");
      # Needed for missile.nas calculation
      if (msltyp == "JDAM") {
          weaponmode = 1;
      } elsif (msltyp == "GBU-39") {
          weaponmode = 1;
      } else {
        weaponmode = 0;
      }

            me.baseTranslation = [30,30];

me.centerOrigin = hudmath.HudMath.getCenterOrigin();
me.ccipGrp.setTranslation(me.centerOrigin);
me.pipperRadius = 10;


#      me.ccipInfo = f22.getCCIP();
#      if (!weaponmode) {
#          me.ccipGrp.hide();
#      } else {
#          hudmath.HudMath.reCalc();
#          var poscc = hudmath.HudMath.getPosFromCoord(me.ccipInfo[0]);
#          me.ccipPipper.setTranslation(poscc[0],poscc[1]);
#          if (me.ccipInfo[1] == 0) {
#              me.ccipCross.show();
#              me.ccipCross.setTranslation(poscc[0],poscc[1]);
#          } else {
#              me.ccipCross.hide();
#          }
#          me.ccipPipper.update();
#          me.ccipLine.removeAllChildren();
#          # 117.817 is VV location in SVG, 0.8 is x scale of SVG. 92.593 is VV location in SVG and 1.18 is y scale of SVG
#          me.ccipVVPos = [0.8*VVx-me.centerOrigin[0]+117.817*0.8+me.baseTranslation[0], 1.18*VVy-me.centerOrigin[1]+92.593*1.18+me.baseTranslation[1]];
#          me.ccipLineDist = math.sqrt(math.pow(me.ccipVVPos[0]-poscc[0],2)+math.pow(me.ccipVVPos[1]-poscc[1],2));
#          me.ccipLine.createChild("path")
#              .moveTo(poscc[0],poscc[1])
#              .lineTo(me.ccipVVPos)
#              .setStrokeDashArray([0,me.pipperRadius,me.ccipLineDist-3.5-me.pipperRadius,3.5*10])#3.5 is radius of VV. 
#              .setStrokeLineWidth(1)
#              .setColor(0,1,0);
#          me.ccipGrp.show();
#
#      }


   
##########################
		#ROUTE MODE :#
##########################	    
	if (me.input.PNK_Mode.getValue() == 0)
		{
	    if (me.input.route_active.getValue() ==1)
				me.NavDirector.setTranslation(me.input.route_deflection.getValue()*10,-150);
		}			
	if (me.input.route_active.getValue() ==1)
		me.DistTo.setText(sprintf("%2.1f", me.input.DistanceToWP.getValue()*1.852));
		
	if (me.input.DME_InRange.getValue() ==1 and me.input.route_active.getValue() == 0)
		me.DistTo.setText(sprintf("%2.1f", me.input.DME_Distance.getValue()*1.852));
		
	if (me.input.PNK_Mode.getValue() == 0 or me.input.PNK_Mode.getValue() == 1)
	{ me.modeEnRte.setVisible(1);}else{me.modeEnRte.setVisible(0);}
			
##########################
		#LANDING MODE :#
##########################
	if (me.input.PNK_Mode.getValue() == 2 and me.input.Is_LOC.getValue() == 1 and me.input.NavInRange.getValue() == 1)
		{ 
		me.modeLndg.setVisible(1);
		me.NavDirector.setVisible(1);
		me.Glidingpath.setVisible(1);
		me.locIndicator.setVisible(1);
		me.Glidingpath.setTranslation(me.input.NavCrossTrackErr.getValue() * 0.056, me.input.GS_Deflection.getValue() * -12.2) ;
		me.NavDirector.setTranslation(getprop("instrumentation/nav/heading-needle-deflection")*4.4,me.input.GS_Deflection.getValue() * -3.6) ;
		if (me.input.Gs_InRange.getValue() == 1){me.GSIndicator.setVisible(1);}else {me.GSIndicator.setVisible(0)}
		#me.GSIndicator.setVisible(1);
		
		}else
		{
		me.locIndicator.setVisible(0);
		me.GSIndicator.setVisible(0);
		me.modeLndg.setVisible(0);
		me.NavDirector.setVisible(0);

		}
      me.speedtape.setVisible(0);
      me.alttape.setVisible(0);
      me.speedtape.setTranslation(13.508,getprop("velocities/airspeed-kt"));
      
  #      me.ccipInfo = f22.getCCIP();
  if (!weaponmode) {
      me.ccipGrp.hide();
      me.bomb_sight.setVisible(0);
  } else {
      me.bomb_sight.setVisible(1);
#                 hudmath.HudMath.reCalc();
#                 if (me.ccipInfo[0] != nil or me.ccipInfo[0] > 2000) {
#             var poscc = hudmath.HudMath.getPosFromCoord(me.ccipInfo[0]);
#                 } else {
#                   print("Posc is too high! turning off");
#                  # break;
#                 }
##print(poscc[0]);
#print(poscc[1] - 1005);
#      me.bomb_sight.setTranslation(poscc[0],poscc[1] - 1005);
  }
				me.Glidingpath.setVisible(0);
		me.modeRtn.setVisible(0);	# Until implemented , this should be hidden unconditionnally	
			var lock= getprop("instrumentation/radar/lock");		
		var radarON= getprop("su-27/instrumentation/N010-radar/emitting");
  		var missile= getprop("controls/armament/selected-weapon-digit");
    # check bingo
    if (getprop("f22/isbingo") == 1){
      me.bingoind.setVisible(getprop("f22/blink"));
    } else {
      me.bingoind.setVisible(0);
    }

    if (getprop("sim/model/radar/time-until-impact") < 8 and getprop("sim/model/radar/time-until-impact") != -1){
      me.pullup.setVisible(getprop("f22/blink"));
    } else {
      me.pullup.setVisible(0);
    }

    if (getprop("orientation/alpha-deg") > 30 ){
      me.aoaind.setVisible(getprop("f22/blink"));
    } else {
      me.aoaind.setVisible(1);
    }

		if (radarON == 0)
		{
			#print("Radar off ");
			me.tgt1Marker.setVisible(0);
			me.tgt2Marker.setVisible(0);
			me.tgt3Marker.setVisible(0);
			me.tgt4Marker.setVisible(0);
			me.tgt5Marker.setVisible(0);
			me.tgt6Marker.setVisible(0);
			me.tgt7Marker.setVisible(0);
			me.tgt8Marker.setVisible(0);
			me.tgt9Marker.setVisible(0);
			me.tgt10Marker.setVisible(0);
      me.lockMarker.setVisible(0);
      me.NavDirector.setVisible(0);
		me.Glidingpath.setVisible(0);
		}
		if (radarON == 0){me.Rdr_Indicator.setVisible(1);}else {me.Rdr_Indicator.setVisible(0);}
		if (missile == 2){
      if (lock == 1){
        me.NavDirector.setVisible(0);
        me.Glidingpath.setVisible(0);
      }else {
        me.NavDirector.setVisible(0);
        me.Glidingpath.setVisible(0);
        }	
        }else {
          me.NavDirector.setVisible(0);
          }		




#**************LOCK MARKER *********************#
		if(radar.GetTarget() != nil){
      var target1_x = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("h-offset",1).getValue();
      var target1_z = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("v-offset",1).getValue();
      if (target1_x or 0 > 0 and radarON ==1)
      {
        var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
        var oriAngle = math.asin(target1_x / dist_O);
        if(target1_z < 0){
          oriAngle = 3.141592654 - oriAngle;
        }
        var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
        target1_x = dist_O * math.sin(oriAngle - Rollrad);
        target1_z = dist_O * math.cos(oriAngle - Rollrad);
        var kx = abs(target1_x/7.25);
        var kz = abs(target1_z/6);
        if((kx > 1) or (kz > 1)){
          if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
        }
        if (radarON == 1){
              me.lockMarker.setVisible(1);
              me.lockMarker.setTranslation(target1_x*getprop("f22/hudx"), -190+ -target1_z*getprop("f22/hudz"));}
      }
    }

#		#**************TARGET1 MARKER *********************#
		var target1_x = getprop("instrumentation/radar2/targets/multiplayer/h-offset");
		var target1_z = getprop("instrumentation/radar2/targets/multiplayer/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
      if (radarON == 1){
						me.tgt1Marker.setVisible(0);
						me.tgt1Marker.setTranslation(target1_x*18, -190+ -target1_z*16);}
		}
#		#**************TARGET2 MARKER *********************#
		var target2_x = getprop("instrumentation/radar2/targets/multiplayer[1]/h-offset");
		var target2_z = getprop("instrumentation/radar2/targets/multiplayer[1]/v-offset");
		if (target2_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target2_x, 2)+math.pow(target2_z, 2));
      var oriAngle = math.asin(target2_x / dist_O);
      if(target2_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target2_x = dist_O * math.sin(oriAngle - Rollrad);
      target2_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target2_x/7.25);
      var kz = abs(target2_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target2_x = target2_x / kx;
            target2_z = target2_z / kx;
          }else{
            target2_z = target2_z / kz;
            target2_x = target2_x / kz;
          }
      }
      if (radarON == 1){
						me.tgt2Marker.setVisible(0);
						me.tgt2Marker.setTranslation(target2_x*18, -190+ -target2_z*16);}
		}
#		#**************TARGET3 MARKER *********************#
		var target3_x = getprop("instrumentation/radar2/targets/multiplayer[2]/h-offset");
		var target3_z = getprop("instrumentation/radar2/targets/multiplayer[2]/v-offset");
		if (target3_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target3_x, 2)+math.pow(target3_z, 2));
      var oriAngle = math.asin(target3_x / dist_O);
      if(target3_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target3_x = dist_O * math.sin(oriAngle - Rollrad);
      target3_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target3_x/7.25);
      var kz = abs(target3_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
          target3_x = target3_x / kx;
          target3_z = target3_z / kx;
        }else{
          target3_z = target3_z / kz;
          target3_x = target3_x / kz;
        }
      }
      if (radarON == 1){
						me.tgt3Marker.setVisible(0);
						me.tgt3Marker.setTranslation(target3_x*18, -190+ -target3_z*16);}
		}
#		#**************TARGET4 MARKER *********************#
		var target4_x = getprop("instrumentation/radar2/targets/multiplayer[3]/h-offset");
		var target4_z = getprop("instrumentation/radar2/targets/multiplayer[3]/v-offset");
		if (target4_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target4_x, 2)+math.pow(target4_z, 2));
      var oriAngle = math.asin(target4_x / dist_O);
      if(target4_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target4_x = dist_O * math.sin(oriAngle - Rollrad);
      target4_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target4_x/7.25);
      var kz = abs(target4_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
          target4_z = target4_z / kx;
          target4_x = target4_z / kx;
        }else{
          target4_z = target4_z / kz;
          target4_x = target4_x / kz;
        }
      }
      if (radarON == 1){
						me.tgt4Marker.setVisible(0);
						me.tgt4Marker.setTranslation(target4_x*15, -190+ -target4_z*16);}
		}
#		#**************TARGET5 MARKER *********************#
		target1_x = getprop("instrumentation/radar2/targets/multiplayer[4]/h-offset");
		target1_z = getprop("instrumentation/radar2/targets/multiplayer[4]/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
			if (radarON == 1){
						me.tgt5Marker.setVisible(0);
						me.tgt5Marker.setTranslation(target1_x*20, -190+ -target1_z*16);}
		}
#		#**************TARGET6 MARKER *********************#
		target1_x = getprop("instrumentation/radar2/targets/multiplayer[5]/h-offset");
		target1_z = getprop("instrumentation/radar2/targets/multiplayer[5]/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
			if (radarON == 1){
						me.tgt6Marker.setVisible(0);
						me.tgt6Marker.setTranslation(target1_x*20, -195+ -target1_z*16);}
		}
#		#**************TARGET7 MARKER *********************#
		var target7_x = getprop("instrumentation/radar2/targets/tanker[0]/h-offset");
		var target7_z = getprop("instrumentation/radar2/targets/tanker[0]/v-offset");
		if (target7_x or 0 > 0 and radarON ==1)
		{
			if (radarON == 1){
						me.tgt7Marker.setVisible(0);
						me.tgt7Marker.setTranslation(target7_x*15, -145+ -target7_z*16);}
		}
#		#**************TARGET8 MARKER *********************#
		target1_x = getprop("instrumentation/radar2/targets/Mig-28[2]/h-offset");
		target1_z = getprop("instrumentation/radar2/targets/Mig-28[2]/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
			if (radarON == 1){
						me.tgt8Marker.setVisible(0);
						me.tgt8Marker.setTranslation(target1_x*18, -190+ -target1_z*16);}
		}
#		#**************TARGET9 MARKER *********************#
		target1_x = getprop("instrumentation/radar2/targets/Mig-28[1]/h-offset");
		target1_z = getprop("instrumentation/radar2/targets/Mig-28[1]/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
      if (radarON == 1){
						me.tgt9Marker.setVisible(0);
						me.tgt9Marker.setTranslation(target1_x*18, -190+ -target1_z*16);}
		}
#		#**************TARGET10 MARKER *********************#
		target1_x = getprop("instrumentation/radar2/targets/Mig-28[0]/h-offset");
		target1_z = getprop("instrumentation/radar2/targets/Mig-28[0]/v-offset");
		if (target1_x or 0 > 0 and radarON ==1)
		{
			var dist_O = math.sqrt(math.pow(target1_x, 2)+math.pow(target1_z, 2));
      var oriAngle = math.asin(target1_x / dist_O);
      if(target1_z < 0){
        oriAngle = 3.141592654 - oriAngle;
      }
      var Rollrad = (OurRoll.getValue() / 180) * 3.141592654;
      target1_x = dist_O * math.sin(oriAngle - Rollrad);
      target1_z = dist_O * math.cos(oriAngle - Rollrad);
      var kx = abs(target1_x/7.25);
      var kz = abs(target1_z/6);
      if((kx > 1) or (kz > 1)){
        if(kx > kz){
            target1_x = target1_x / kx;
            target1_z = target1_z / kx;
          }else{
            target1_z = target1_z / kz;
            target1_x = target1_x / kz;
          }
      }
			if (radarON == 1){
						me.tgt10Marker.setVisible(0);
						me.tgt10Marker.setTranslation(target1_x*18, -190+ -target1_z*16);}
		}
 
    var speed_error = 0;
    if( me.input.target_spd.getValue() != nil )
      speed_error = 4 * clamp(
        me.input.target_spd.getValue() - me.input.airspeed.getValue(),
        -15, 15
      );

 
    settimer(func me.update(), 0);
  },
		# Get an element from the SVG; handle errors; and apply clip rectangle
		# if found (by naming convention : addition of _clip to object name).
     get_element : func(id) {
        var el = me.svg.getElementById(id);
        if (el == nil)
        {
            print("Failed to locate ",id," in SVG");
            return el;
        }
        var clip_el = me.svg.getElementById(id ~ "_clip");
        if (clip_el != nil)
        {
            clip_el.setVisible(0);
            var tran_rect = clip_el.getTransformedBounds();

            var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
                                   tran_rect[1], # 0 ys
                                   tran_rect[2],  # 1 xe
                                   tran_rect[3], # 2 ye
                                   tran_rect[0]); #3 xs
#            print(id," using clip element ",clip_rect, " trans(",tran_rect[0],",",tran_rect[1],"  ",tran_rect[2],",",tran_rect[3],")");
#   see line 621 of simgear/canvas/CanvasElement.cxx
#   not sure why the coordinates are in this order but are top,right,bottom,left (ys, xe, ye, xs)
            el.set("clip", clip_rect);
            el.set("clip-frame", canvas.Element.PARENT);
        }
        return el;
    }
};




 
var init = setlistener("/sim/signals/fdm-initialized", func() {
  removelistener(init); # only call once
    hudmath.HudMath.init([-5.63907,-0.08217,1.41853], [-5.7967,0.10206,1.2481], [256,296], [0.124048, 0.586015], [0.879649,0.045312], 0);
  var hud_pilot = HUD.new({"node": "hudglass"});
  #hud_pilot.setupccip();
  hud_pilot.update();
});

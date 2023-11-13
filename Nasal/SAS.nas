#----------------------------------------------------------------------------
# Stability Augmentation System
#----------------------------------------------------------------------------

var t_increment     = 0.0075;
var p_lo_speed      = 300;
var p_lo_speed_sqr  = p_lo_speed * p_lo_speed;
var p_vlo_speed     = 160;
var gear_lo_speed   = 10;
var gear_lo_speed_sqr = gear_lo_speed * gear_lo_speed;

var roll_lo_speed   = 450;
var roll_lo_speed_sqr = roll_lo_speed * roll_lo_speed;

var p_kp            = -0.05;
var e_smooth_factor = 0.1;
var r_smooth_factor = 0.2;
var p_max           = 0.2;
var p_min           = -0.2;
#+54 mm for the 2000 & -30 mm

var max_e           = 1;
var min_e           = 0.55;
var maxG = 10 ; #mirage 2000 max everyday 9 G; overload 11G and 12 G will damage the aircraft
var minG = -4; #-3.5

# Orientation and velocities
var Roll       = props.globals.getNode("orientation/roll-deg");
var PitchRate  = props.globals.getNode("orientation/pitch-rate-degps", 1);
var YawRate    = props.globals.getNode("orientation/yaw-rate-degps", 1);
var AirSpeed   = props.globals.getNode("velocities/airspeed-kt");
var GroundSpeed   = props.globals.getNode("velocities/groundspeed-kt");
var mach       = props.globals.getNode("velocities/mach");

# SAS and Autopilot Controls
var SasPitchOn = props.globals.getNode("controls/SAS/pitch");
var SasRollOn  = props.globals.getNode("controls/SAS/roll");
var SasYawOn   = props.globals.getNode("controls/SAS/yaw");

var DeadZPitch = props.globals.getNode("controls/SAS/dead-zone-pitch");
var DeadZRoll  = props.globals.getNode("controls/SAS/dead-zone-roll");

# Autopilot Locks
var ap_alt_lock   = props.globals.getNode("autopilot/locks/altitude");
var ap_hdg_lock   = props.globals.getNode("autopilot/locks/heading");

# Inputs
var RawElev       = props.globals.getNode("controls/flight/elevator");
var RawAileron    = props.globals.getNode("controls/flight/aileron");
var RawRudder     = props.globals.getNode("controls/flight/rudder");
var AileronTrim   = props.globals.getNode("controls/flight/aileron-trim", 1);
#var ElevatorTrim  = props.globals.getNode("controls/flight/elevator-trim", 1);
var Dlc           = props.globals.getNode("controls/flight/DLC", 1);
var Flaps         = props.globals.getNode("surface-positions/aux-flap-pos-norm", 1);
#var WSweep        = props.globals.getNode("surface-positions/wing-pos-norm", 1);
# Outputs
var SasRoll       = props.globals.getNode("controls/flight/SAS-roll", 1);
var SasPitch      = props.globals.getNode("controls/flight/SAS-pitch", 1);
var SasYaw        = props.globals.getNode("controls/flight/SAS-yaw", 1);
var SasGear        = props.globals.getNode("controls/flight/SAS-gear", 1);

var airspeed       = 0;
var airspeed_sqr   = 0;
var last_e         = 0;
var last_p_var_err = 0;
var p_input        = 0;
var last_p_bias    = 0;
var last_a         = 0;
var last_r         = 0;
var w_sweep        = 0;
# var e_trim         = 0;
var steering       = 0;
var dt_mva_vec     = [0,0,0,0,0,0,0];

# Elevator Trim
#if ( ElevatorTrim.getValue() != nil ) { e_trim = ElevatorTrim.getValue() }

#var trimUp = func {
#	e_trim += (airspeed < 120.0) ? t_increment : t_increment * 14400 / airspeed_sqr;
#	if (e_trim > 1) e_trim = 1;
#	ElevatorTrim.setValue(e_trim);
#}

#var trimDown = func {
#	e_trim -= (airspeed < 120.0) ? t_increment : t_increment * 14400 / airspeed_sqr;
#	if (e_trim < -1) e_trim = -1;
#	ElevatorTrim.setValue(e_trim);
#}

# Stability Augmentation System
var computeSAS = func {

#Mirage 2000
#I) Elevator :
#1)Few sensibility near stick neutral position <-traduce by sqare yaw
#2)Trim + elevator clipped -> at less than 80 % of stick : (trim + elevator) have to be < 80%
#3)at speed > 300kts : the stick position is equals to a Gload. So the stick drive the G.
#4)at low speed : (bellow 160 kt I suppose) the important is to stabilize the aoa

#II)Roll
#1)Few sensibility near stick neutral position
#2)High Roll : Clipped to respect roll speed limitation
#3)Ponderation : elevator order & Gload to decrease roll speed at high aoa and/or high Gload
#4)To the stick order is added trim order.the stabilisation is realized in terme of angular speed roll

#III)Yaw axis
#1)limitation of yaw depend of the elevator
#2)This limitation is mesured by transveral acceleration
#3)Anti skid function : when "no yaw", and order is gived to the rudder to keep transversal acceleratioon to 0
#4)When gears are out, yaw' order authority is increased in order to cover crosswind landing



#IV)Slat
#1)Slats depend of the incidences
#2)start at aoa = 4 and are fully out at aoa = 10
#3)slat get in when gear are out (In emergency taht implid very low speed landing, they can get out)
#4)open speed is : 2,6 sec from 0 to fullly open.
#5)if oil presure < 180 bars this time is 5.2 sec


#V)Gear
#Special flightgear :
#1) depend of the yaw order
#2) The turn has to be very high for very low speed and have to decrease a lot while take off acceeleration

	var roll     = Roll.getValue();
	var roll_rad = roll * 0.017453293;
	airspeed     = AirSpeed.getValue();
	airspeed_sqr = airspeed * airspeed;
	var raw_e    = RawElev.getValue();
	var raw_a    = RawAileron.getValue();
	var a_trim   = AileronTrim.getValue();
        var alpha = getprop ("/orientation/alpha-deg");
        var  gload = getprop ("/accelerations/pilot-g");
        var raw_r    = RawRudder.getValue();
        var pitch_r  = PitchRate.getValue();
        var myMach   = mach.getValue();
        
 ##################################################################################################
if(getprop ("/autopilot/locks/AP-status")=="AP1"){
        SasPitch.setValue(raw_e);
        SasRoll.setValue(raw_a);
        SasYaw.setValue(raw_r);
        SasGear.setValue(raw_r);
 }else{

		# Pitch Channel
		var pitch_rate = PitchRate.getValue();
		var yaw_rate   = YawRate.getValue();
		var p_bias     = 0;
		var smooth_e   = raw_e;
		var dlc_trim   = 0;
		var gain       = 0;
		
		
		#Sqare gain :Attenuate neutral positions
		p_input = raw_e * raw_e;
		#p_input = math.int(p_input/1000)*1000;
		if(raw_e<0){ p_input *= -1;}
		
		#var wbody = getprop("/velocities/wBody-fps")*FT2M;
		#print("gload :", gload, " wBody : ",getprop("/velocities/wBody-fps")*FT2M," ratio :", 2*(wbody)/gload);
		
		 #NB : airspeed in this case has to be changed in "absolute" speed
		if(myMach > (0.8)){
		
		  #if(p_input
		  #p_input *= (600/p_lo_speed_sqr) / (myMach*myMach);  
		  #p_input = raw_e * raw_e* raw_e;
		
		}elsif(airspeed < p_vlo_speed){
		#Gain depend of Aoas
		
		}
				
		last_e = p_input;
		SasPitch.setValue(p_input);
		#SASpitch = p_input; # Used by adverse.nas        
        
#########################################################################################        

		# Roll Channel
		var sas_roll = 0;
		# Squares roll input, then applies quadratic law.
		#if (SasRollOn.getValue()) {
		
                  sas_roll = (raw_a * raw_a);
                  if (raw_a < 0 ) { sas_roll *= -1 }
                  sas_roll += a_trim;
                  if (myMach > (600 /roll_lo_speed)) {
                  sas_roll *= ((600 /roll_lo_speed)*(600 /roll_lo_speed)) / (myMach*myMach);
				
		  }
		#} else {
		#	sas_roll = raw_a + a_trim;
		#}
		#SASroll = sas_roll; # Used by adverse.nas
		SasRoll.setValue(sas_roll);
		
#

#########################################################################################
	# Yaw Channel
	
	var smooth_r = raw_r;
	#if (SasYawOn.getValue()) {
		smooth_r = last_r + ((raw_r - last_r) * r_smooth_factor);
		last_r = smooth_r;
	#}
	SasYaw.setValue(smooth_r);
	
	#Gear Channel
	#Appli Quadratic law from low speed
	
	var gear_input  = raw_r;
	
	if (airspeed > gear_lo_speed) {
           gear_input *= gear_lo_speed_sqr / airspeed_sqr;
           #print("raw :", raw_r," Factor :", gear_lo_speed_sqr / airspeed_sqr," gear_input :", gear_input);
				
        }
	SasGear.setValue(gear_input);
	
}	
		
#########################################################################################"
     #To calculate the best slats position

     #var airspeed = getprop ("/velocities/airspeed-kt");
     
     if(getprop ("/controls/gear/gear-down")== 0){
       var slats = 0;
       if (alpha >= 2) {
           var  gload = getprop ("/accelerations/pilot-g");
           if(gload< 9){
               var slats =  (alpha - 3)/6;
               #print("slats: ",slats,"   alpha :",alpha  );  
           }
       }
       setprop("/controls/flight/flaps", slats);
     }
     
     var stallwarning  = "0";
     if(getprop ("/gear/gear[2]/wow") == 0) {
        
        #STALL ALERT !!
        if(alpha>=29){stallwarning = "2";}  
        elsif(airspeed < 100){stallwarning = "2";}  
         
        #STALL WARNING      
        elsif(alpha>=20){stallwarning = "1";}
        elsif(airspeed < 130){stallwarning = "1";}       
     } 
     setprop("/sim/alarms/stall-warning", stallwarning); 

}

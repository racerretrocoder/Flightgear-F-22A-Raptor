var showPylonsDlg = func{
	if(getprop("/payload/armament/msg")){
		if(getprop("/gear/gear/compression-ft")<0.01){
			screen.log.write("Damage is ON, Land the Raptor to change the loadout!",1,0,0);
			return;
		}
	}
var (width,height) = (980,600);
var title = 'F-22 Weapons :';
 
# create a new window, dimensions are WIDTH x HEIGHT, using the dialog decoration (i.e. titlebar)
var window = canvas.Window.new([width,height],"dialog").set('title',title);
 
# adding a canvas to the new window and setting up background colors/transparency
var myCanvas = window.createCanvas().set("background", canvas.style.getColor("bg_color"));
 
# creating the top-level/root group which will contain all other elements/group
var root = myCanvas.createGroup();
 
# create a new layout for the dialog:
var mainVBox = canvas.VBoxLayout.new();
# assign the layout to the Canvas

myCanvas.setLayout(mainVBox);

var pylonsMap = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setImage("Aircraft/F-22/gui/F-22-Pylons.png")
	.setFixedSize(697,197); # image dimensions
mainVBox.addItem(pylonsMap);



var Hbox2 = canvas.HBoxLayout.new();
mainVBox.addItem(Hbox2);

var P8Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P8Ctls);

var P6Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P6Ctls);

var P4Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P4Ctls);

var P10Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P10Ctls);

var P2Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P2Ctls);

var P1Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P1Ctls);

var P9Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P9Ctls);

var P3Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P3Ctls);

var P5Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P5Ctls);

var P7Ctls = canvas.VBoxLayout.new();
Hbox2.addItem(P7Ctls);


var Lbl_pyln8 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P8:"~getprop("sim/weight[7]/selected"));
P8Ctls.addItem(Lbl_pyln8);

var Lbl_pyln6 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P6:"~getprop("sim/weight[5]/selected"));
P6Ctls.addItem(Lbl_pyln6);

var Lbl_pyln4 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P4:"~getprop("sim/weight[3]/selected"));
P4Ctls.addItem(Lbl_pyln4);

var Lbl_pyln10 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P10:"~getprop("sim/weight[9]/selected"));
P10Ctls.addItem(Lbl_pyln10);

var Lbl_pyln2 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P2:"~getprop("sim/weight[1]/selected"));
P2Ctls.addItem(Lbl_pyln2);

var Lbl_pyln1 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P1:"~getprop("sim/weight/selected"));
P1Ctls.addItem(Lbl_pyln1);

var Lbl_pyln9 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P9:"~getprop("sim/weight[8]/selected"));
P9Ctls.addItem(Lbl_pyln9);

var Lbl_pyln3 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P3:"~getprop("sim/weight[2]/selected"));
P3Ctls.addItem(Lbl_pyln3);

var Lbl_pyln5 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P5:"~getprop("sim/weight[4]/selected"));
P5Ctls.addItem(Lbl_pyln5);

var Lbl_pyln7 = canvas.gui.widgets.Label.new(root, canvas.style, {} )
	.setText("P7:"~getprop("sim/weight[6]/selected"));
P7Ctls.addItem(Lbl_pyln7);


var pylons_update = func{
	Lbl_pyln8.setText("P8: "~getprop("sim/weight[7]/selected"));
	Lbl_pyln6.setText("P6: "~getprop("sim/weight[5]/selected"));
	Lbl_pyln4.setText("P4: "~getprop("sim/weight[3]/selected"));
	Lbl_pyln10.setText("P10: "~getprop("sim/weight[9]/selected"));
	Lbl_pyln2.setText("P2: "~getprop("sim/weight[1]/selected"));
	Lbl_pyln1.setText("P1: "~getprop("sim/weight/selected"));
	Lbl_pyln9.setText("P9: "~getprop("sim/weight[8]/selected"));
	Lbl_pyln3.setText("P3: "~getprop("sim/weight[2]/selected"));
	Lbl_pyln5.setText("P5: "~getprop("sim/weight[4]/selected"));
	Lbl_pyln7.setText("P7: "~getprop("sim/weight[6]/selected"));
	}
###############################
######### Pylon8 ##############	
###############################

# click button P8:None
var btn_P8_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P8_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P8: None");
		setprop("sim/weight[7]/selected","None");

		pylons_update();
		});
P8Ctls.addItem(btn_P8_empty);

# click button P8:R-73
var btn_P8_R_73 = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-9X")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P8_R_73.listen("clicked", func {
        # add code here to react on click on button.
		print("P8: Aim-9x");
		setprop("sim/weight[7]/selected","Aim-9x");
		setprop("/controls/armament/station[7]/release","false");

		pylons_update();
		});
P8Ctls.addItem(btn_P8_R_73);

# click button P8:aim-9m
var btn_P8_smk_red = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-9M")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P8_smk_red.listen("clicked", func {
        # add code here to react on click on button.
		print("P8: Aim-9m");
		setprop("sim/weight[7]/selected","Aim-9m");
		setprop("/controls/armament/station[7]/release","false");

		pylons_update();
		});
P8Ctls.addItem(btn_P8_smk_red);

# click button P8:smoke-yellow
var btn_P8_smk_yellw = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("smoke: red")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P8_smk_yellw.listen("clicked", func {
        # add code here to react on click on button.
		print("P8: smoke-red");
		setprop("sim/weight[7]/selected","smoke-red");
		setprop("/controls/armament/station[7]/release","false");

		pylons_update();
		});
P8Ctls.addItem(btn_P8_smk_yellw);

# click button P8:smoke-blue
var btn_P8_smk_blue = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("smoke: blue")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P8_smk_blue.listen("clicked", func {
        # add code here to react on click on button.
		print("P8: smoke-blue");
		setprop("sim/weight[7]/selected","smoke-blue");
		setprop("/controls/armament/station[7]/release","false");

		pylons_update();
		});
P8Ctls.addItem(btn_P8_smk_blue);
###############################
######### Pylon6 ##############	
###############################

# click button P6:None
var btn_P6_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P6_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P6: None");
		setprop("sim/weight[5]/selected","None");

		pylons_update();
		});
P6Ctls.addItem(btn_P6_empty);

# click button P6:R-27R
var btn_P6_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P6_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P6: Aim-120");
		setprop("sim/weight[5]/selected","Aim-120");
		setprop("/controls/armament/station[5]/release","false");

		pylons_update();
		});
P6Ctls.addItem(btn_P6_R27R);

# click button P6:R-27T
var btn_P6_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("debug XMAA")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P6_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P6: Warning debug Xadvanced Multi air to air loaded on pylon 6");
		setprop("sim/weight[5]/selected","XMAA");
		setprop("/controls/armament/station[5]/release","false");

		pylons_update();
		});
P6Ctls.addItem(btn_P6_R27T);

# click button P6:R-27ER
var btn_P6_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("none")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P6_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P6: R-27ER");
		setprop("sim/weight[5]/selected","none");
		setprop("/controls/armament/station[5]/release","false");

		pylons_update();
		});
P6Ctls.addItem(btn_P6_R27ER);

# click button P6:R-27ET
var btn_P6_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("R-27ET")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P6_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P6: R-27ET");
		setprop("sim/weight[5]/selected","R-27ET");
		setprop("/controls/armament/station[5]/release","false");

		pylons_update();
		});
P6Ctls.addItem(btn_P6_R27ET);

###############################
######### Pylon4 ##############	
###############################

# click button P4:None
var btn_P4_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P4_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P4: None");
		setprop("sim/weight[3]/selected","None");

		pylons_update();
		});
P4Ctls.addItem(btn_P4_empty);

# click button P4:R-27R
var btn_P4_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P4_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P4: Aim-120");
		setprop("sim/weight[3]/selected","Aim-120");
		setprop("/controls/armament/station[3]/release","false");

		pylons_update();
		});
P4Ctls.addItem(btn_P4_R27R);

# click button P4:GBU39
var btn_P4_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P4_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P4: GBU-39");
		setprop("sim/weight[3]/selected","GBU-39");
		setprop("/controls/armament/station[3]/release","false");

		pylons_update();
		});
P4Ctls.addItem(btn_P4_R27T);




#    JDAM p


# click button P4:R-27ER
var btn_P4_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("JDAM")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P4_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P4: JDAM");
		setprop("sim/weight[3]/selected","JDAM");
		setprop("/controls/armament/station[3]/release","false");

		pylons_update();
		});
P4Ctls.addItem(btn_P4_R27ER);

# click button P4:R-27ET
var btn_P4_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39 (rear)")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P4_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P4: GBU-29");
		setprop("sim/weight[11]/selected","GBU-39");
		setprop("/controls/armament/station[11]/release","false");

		pylons_update();
		});
P4Ctls.addItem(btn_P4_R27ET);

###############################
######### Pylon10 #############	
###############################

# click button P10:None
var btn_P10_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P10_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P10: None");
		setprop("sim/weight[9]/selected","None");

		pylons_update();
		});
P10Ctls.addItem(btn_P10_empty);

# click button P10:R-27R
var btn_P10_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P10_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P10: Aim-120");
		setprop("sim/weight[9]/selected","Aim-120");
		setprop("/controls/armament/station[9]/release","false");

		pylons_update();
		});
P10Ctls.addItem(btn_P10_R27R);

# click button P10:GBU-39
var btn_P10_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P10_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P10: GBU-39");
		setprop("sim/weight[9]/selected","GBU-39");
		setprop("/controls/armament/station[9]/release","false");

		pylons_update();
		});
P10Ctls.addItem(btn_P10_R27T);

# click button P10:JDAM
var btn_P10_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("none")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P10_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P10: JDAM");
		setprop("sim/weight[9]/selected","none");
		setprop("/controls/armament/station[9]/release","false");

		pylons_update();
		});
P10Ctls.addItem(btn_P10_R27ER);

# click button P10:R-27ET
var btn_P10_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39 (rear)")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P10_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P10: R-27ET");
		setprop("sim/weight[12]/selected","GBU-39");
		setprop("/controls/armament/station[12]/release","false");

		pylons_update();
		});
P10Ctls.addItem(btn_P10_R27ET);

###############################
######### Pylon2 ##############	
###############################

# click button P2:None
var btn_P2_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P2_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P2: None");
		setprop("sim/weight/selected","None");

		pylons_update();
		});
P2Ctls.addItem(btn_P2_empty);

# click button P2:R-27R
var btn_P2_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P2_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P2: Aim-120");
		setprop("sim/weight/selected","Aim-120");
		setprop("/controls/armament/station/release","false");

		pylons_update();
		});
P2Ctls.addItem(btn_P2_R27R);

# click button P2:R-27T
var btn_P2_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P2_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P2: GBU-39");
		setprop("sim/weight/selected","GBU-39");
		setprop("/controls/armament/station/release","false");

		pylons_update();
		});
P2Ctls.addItem(btn_P2_R27T);

# click button P2:R-27ER
var btn_P2_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("none")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P2_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P2: R-27ER");
		setprop("sim/weight/selected","R-27ER");
		setprop("/controls/armament/station/release","false");

		pylons_update();
		});
P2Ctls.addItem(btn_P2_R27ER);

# click button P2:R-27ET
var btn_P2_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39 (rear)")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P2_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P2: R-27ET");
		setprop("sim/weight[14]/selected","GBU-39");
		setprop("/controls/armament/station[14]/release","false");

		pylons_update();
		});
P2Ctls.addItem(btn_P2_R27ET);

###############################
######### Pylon1 ##############	
###############################

# click button P1:None
var btn_P1_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P1_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P1: None");
		setprop("sim/weight[1]/selected","None");

		pylons_update();
		});
P1Ctls.addItem(btn_P1_empty);

# click button P1:R-27R
var btn_P1_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P1_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P1: Aim-120");
		setprop("sim/weight[1]/selected","Aim-120");
		setprop("/controls/armament/station[1]/release","false");

		pylons_update();
		});
P1Ctls.addItem(btn_P1_R27R);

# click button P1:GBU-39
var btn_P1_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P1_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P1: GBU-39");
		setprop("sim/weight[1]/selected","GBU-39");
		setprop("/controls/armament/station[1]/release","false");

		pylons_update();
		});
P1Ctls.addItem(btn_P1_R27T);

# click button P1:R-27ER
var btn_P1_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("JDAM")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P1_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P1: JDAM");
		setprop("sim/weight[1]/selected","JDAM");
		setprop("/controls/armament/station[1]/release","false");

		pylons_update();
		});
P1Ctls.addItem(btn_P1_R27ER);

# click button P1:R-27ET
var btn_P1_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("GBU-39 (rear)")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P1_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P1: GBU39");
		setprop("sim/weight[13]/selected","GBU-39");
		setprop("/controls/armament/station[13]/release","false");

		pylons_update();
		});
P1Ctls.addItem(btn_P1_R27ET);

###############################
######### Pylon9 ##############	
###############################

# click button P9:None
var btn_P9_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P9_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P9: None");
		setprop("sim/weight[8]/selected","None");

		pylons_update();
		});
P9Ctls.addItem(btn_P9_empty);

# click button P9:R-27R
var btn_P9_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P9_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P9: Aim-120");
		setprop("sim/weight[8]/selected","Aim-120");
		setprop("/controls/armament/station[8]/release","false");

		pylons_update();
		});
P9Ctls.addItem(btn_P9_R27R);

# click button P9:R-27T
var btn_P9_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("debug XMAA")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P9_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P9: Warning XMAA loaded on pylon 9");
		setprop("sim/weight[8]/selected","XMAA");
		setprop("/controls/armament/station[8]/release","false");

		pylons_update();
		});
P9Ctls.addItem(btn_P9_R27T);

# click button P9:R-27ER
var btn_P9_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("none")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P9_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P9: R-27ER");
		setprop("sim/weight[8]/selected","R-27ER");
		setprop("/controls/armament/station[8]/release","false");

		pylons_update();
		});
P9Ctls.addItem(btn_P9_R27ER);

# click button P9:R-27ET
var btn_P9_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("R-27ET")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P9_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P9: R-27ET");
		setprop("sim/weight[8]/selected","R-27ET");
		setprop("/controls/armament/station[8]/release","false");

		pylons_update();
		});
P9Ctls.addItem(btn_P9_R27ET);

###############################
######### Pylon3 ##############	
###############################

# click button P3:None
var btn_P3_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P3: None");
		setprop("sim/weight[2]/selected","None");

		pylons_update();
		});
P3Ctls.addItem(btn_P3_empty);

# click button P3:R-27R
var btn_P3_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Ext-Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P3: Ext-Aim-120");
		setprop("sim/weight[2]/selected","Aim-120");
		setprop("/controls/armament/station[2]/release","false");

		pylons_update();
		});
P3Ctls.addItem(btn_P3_R27R);

# click button P3:R-27T
var btn_P3_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Ext-Aim-9X")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P3: Aim-9x external");
		setprop("sim/weight[2]/selected","Aim-9x");
		setprop("/controls/armament/station[2]/release","false");

		pylons_update();
		});
P3Ctls.addItem(btn_P3_R27T);

# click button P3:R-27ER
var btn_P3_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Debug Aim7")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P3: Warning debug Aim7 added to external pylon 3");
		setprop("sim/weight[2]/selected","Aim-7");
		setprop("/controls/armament/station[2]/release","false");

		pylons_update();
		});
P3Ctls.addItem(btn_P3_R27ER);

# click button P3:R-27ET
var btn_P3_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Debug Aim-9m")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P3: R-27ET");
		setprop("sim/weight[2]/selected","Aim-9m");
		setprop("/controls/armament/station[2]/release","false");

		pylons_update();
		});
P3Ctls.addItem(btn_P3_R27ET);

##################################################
## Tanks##########################################
##################################################



# click button add dropleft
var btn_P3_ADDTANK = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Add Droptank")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_ADDTANK.listen("clicked", func {
        # add code here to react on click on button.
		print("Left DT added");
		setprop("controls/armament/ldt",1);

		pylons_update();
		});
P3Ctls.addItem(btn_P3_ADDTANK);

# click button add dropleft
var btn_P3_REMTANK = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Remove tank")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P3_REMTANK.listen("clicked", func {
        # add code here to react on click on button.
		print("Left DT removed");
		setprop("controls/armament/ldt",0);

		pylons_update();
		});
P3Ctls.addItem(btn_P3_REMTANK);


###############################
######### Pylon5 ##############	
###############################

# click button P5:None
var btn_P5_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: None");
		setprop("sim/weight[4]/selected","None");

		pylons_update();
		});
P5Ctls.addItem(btn_P5_empty);

# click button P5:R-27R
var btn_P5_R27R = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Ext-Aim-120")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_R27R.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: Aim-120");
		setprop("sim/weight[4]/selected","Aim-120");
		setprop("/controls/armament/station[4]/release","false");

		pylons_update();
		});
P5Ctls.addItem(btn_P5_R27R);

# click button P5:R-27T
var btn_P5_R27T = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Ext-Aim-9X")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_R27T.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: Ext Aim-9x");
		setprop("sim/weight[4]/selected","Aim-9x");
		setprop("/controls/armament/station[4]/release","false");

		pylons_update();
		});
P5Ctls.addItem(btn_P5_R27T);

# click button P5:R-27ER
var btn_P5_R27ER = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Debug Aim7")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_R27ER.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: Warning Debug aim7 added to external pylon 5");
		setprop("sim/weight[4]/selected","Aim-7");
		setprop("/controls/armament/station[4]/release","false");

		pylons_update();
		});
P5Ctls.addItem(btn_P5_R27ER);

# click button P5:R-27ET
var btn_P5_R27ET = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Debug Aim-9m")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_R27ET.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: Aim-9m");
		setprop("sim/weight[4]/selected","Aim-9m");
		setprop("/controls/armament/station[4]/release","false");

		pylons_update();
		});
P5Ctls.addItem(btn_P5_R27ET);

### Pylon 5 drop tanks


# click button P5: add drop tank
var btn_P5_DT = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Add Droptank")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_DT.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: drop tank added");
		setprop("/controls/armament/rdt",1);

		pylons_update();
		});
P5Ctls.addItem(btn_P5_DT);


# click button P5: purge drop tank
var btn_P5_RDT = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Remove Tank")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P5_RDT.listen("clicked", func {
        # add code here to react on click on button.
		print("P5: drop tank purged");
		setprop("/controls/armament/rdt",0);

		pylons_update();
		});
P5Ctls.addItem(btn_P5_RDT);




###############################
######### Pylon7 ##############	
###############################

# click button P7:None
var btn_P7_empty = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("None")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P7_empty.listen("clicked", func {
        # add code here to react on click on button.
		print("P7: None");
		setprop("sim/weight[6]/selected","None");

		pylons_update();
		});
P7Ctls.addItem(btn_P7_empty);
	
# click button P7:R-73
var btn_P7_R_73 = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-9X")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P7_R_73.listen("clicked", func {
        # add code here to react on click on button.
		print("P7: Aim-9x");
		setprop("sim/weight[6]/selected","Aim-9x");
		setprop("/controls/armament/station[6]/release","false");

		pylons_update();
		});
P7Ctls.addItem(btn_P7_R_73);

# click button P7:smoke-red
var btn_P7_smk_red = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("Aim-9m")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P7_smk_red.listen("clicked", func {
        # add code here to react on click on button.
		print("P7: Aim-9m");
		setprop("sim/weight[6]/selected","Aim-9m");
		setprop("/controls/armament/station[6]/release","false");

		pylons_update();
		});
P7Ctls.addItem(btn_P7_smk_red);

# click button P7:smoke-yellow
var btn_P7_smk_yellw = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("smoke: red")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P7_smk_yellw.listen("clicked", func {
        # add code here to react on click on button.
		print("P7: smoke-red");
		setprop("sim/weight[6]/selected","red");
		setprop("/controls/armament/station[6]/release","false");

		pylons_update();
		});
P7Ctls.addItem(btn_P7_smk_yellw);

# click button P7:smoke-blue
var btn_P7_smk_blue = canvas.gui.widgets.Button.new(root, canvas.style, {})
        .setText("smoke: blue")
        #.move(300, 300)
        .setFixedSize(90, 25);

btn_P7_smk_blue.listen("clicked", func {
        # add code here to react on click on button.
		print("P7: smoke-blue");
		setprop("sim/weight[6]/selected","smoke-blue");
		setprop("/controls/armament/station[6]/release","false");
 !
		pylons_update();
		});
P7Ctls.addItem(btn_P7_smk_blue);


var statusbar =canvas.HBoxLayout.new();
mainVBox.addItem(statusbar);

var version=canvas.gui.widgets.Label.new(root, canvas.style, {wordWrap: 0});
version.setText("FlightGear v" ~ getprop("/sim/version/flightgear"));
statusbar.addItem(version);

var Acversion=canvas.gui.widgets.Label.new(root, canvas.style, {wordWrap: 0});
Acversion.setText("F-22A v0.9        This is still experimental. Dont add any R-XXX Missiles        Made by Yanes Bechir 2016, Edited by Phoenix 2020");
statusbar.addItem(Acversion);

}

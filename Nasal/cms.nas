# cms.nas
# Authors: Phoenix
# F-22A custom counter messures controller (Which is programable)

# blade 3 flap deg flare 0-1
# blade 3 position deg chaff 0-1
setprop("controls/CMS/prgmname","None");
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

# Counting
var seqchaff = 1;
var seqflare = 1;
var relchaff = 1;
var relflare = 1;

var resetchaff = func() {
    setprop("rotors/main/blade[3]/position-deg",0);  
    chaffreset.stop();
}

var resetflare = func() {
    setprop("rotors/main/blade[3]/flap-deg",0);  
  setprop("/ai/submodels/submodel/flare-release",0);
    flarereset.stop();
}

var stopchaffseq = func() {
    chaffmainseq1.stop();
    chaffmainseq1.stop();
    chaffmainseq2.stop();
    chaffmainseq3.stop();
    chaffmainseq4.stop();
    chaffmainseq5.stop();
    chaffmainseq6.stop();
    chaffmainseq7.stop();
    chaffmainseq8.stop();
    chaffmainseq.stop(); 
}
var stopchaffdelay = func() {
    chaffmaindelay1.stop();
    chaffmaindelay1.stop();
    chaffmaindelay2.stop();
    chaffmaindelay3.stop();
    chaffmaindelay4.stop();
    chaffmaindelay5.stop();
    chaffmaindelay6.stop();
    chaffmaindelay7.stop();
    chaffmaindelay8.stop();
    chaffmaindelay.stop();  
}

var stopflareseq = func() {
    flaremainseq1.stop();
    flaremainseq1.stop();
    flaremainseq2.stop();
    flaremainseq3.stop();
    flaremainseq4.stop();
    flaremainseq5.stop();
    flaremainseq6.stop();
    flaremainseq7.stop();
    flaremainseq8.stop();
    flaremainseq.stop(); 
}
var stopflaredelay = func() {
    flaremaindelay1.stop();
    flaremaindelay1.stop();
    flaremaindelay2.stop();
    flaremaindelay3.stop();
    flaremaindelay4.stop();
    flaremaindelay5.stop();
    flaremaindelay6.stop();
    flaremaindelay7.stop();
    flaremaindelay8.stop();
    flaremaindelay.stop();  
}

var runchaffseq = func() {
    f22.flare();
    stopchaffdelay();
    if (data3 == 1){chaffmainseq1.start();}
    if (data3 == 2){chaffmainseq1.start();}
    if (data3 == 3){chaffmainseq2.start();}
    if (data3 == 4){chaffmainseq3.start();}
    if (data3 == 5){chaffmainseq4.start();}
    if (data3 == 6){chaffmainseq5.start();}
    if (data3 == 7){chaffmainseq6.start();}
    if (data3 == 8){chaffmainseq7.start();}
    if (data3 == 9){chaffmainseq8.start();}
    if (data3 == 10){chaffmainseq.start();}
    print("chaff:delay per rel: "~data3);
    print("chaff:delay per seq: "~data9);
    print("chaff:num of seqs: "~data7);

    if (seqchaff > data7) {
        print("chaff seqs finish");
        stopchaffseq();
        return 0;
    }

    print("chaff seq start!");
    chaff();
    if (relchaff > data5) {
        print("Chaff rel fin. delaying");
        seqchaff = seqchaff + 1;
        stopchaffseq();
        if (data9 == 1){chaffmaindelay1.start();}
        if (data9 == 2){chaffmaindelay1.start();}
        if (data9 == 3){chaffmaindelay2.start();}
        if (data9 == 4){chaffmaindelay3.start();}
        if (data9 == 5){chaffmaindelay4.start();}
        if (data9 == 6){chaffmaindelay5.start();}
        if (data9 == 7){chaffmaindelay6.start();}
        if (data9 == 8){chaffmaindelay7.start();}
        if (data9 == 9){chaffmaindelay8.start();}
        if (data9 == 10){chaffmaindelay.start();}
        #chaffdelay.start();
        relchaff = 0;
    }
}

var runflareseq = func() {
    f22.flare();
    stopflaredelay();
    if (data4 == 1){flaremainseq1.start();}
    if (data4 == 2){flaremainseq1.start();}
    if (data4 == 3){flaremainseq2.start();}
    if (data4 == 4){flaremainseq3.start();}
    if (data4 == 5){flaremainseq4.start();}
    if (data4 == 6){flaremainseq5.start();}
    if (data4 == 7){flaremainseq6.start();}
    if (data4 == 8){flaremainseq7.start();}
    if (data4 == 9){flaremainseq8.start();}
    if (data4 == 10){flaremainseq.start();}
    print("flare:delay per rel: "~data4);
    print("flare:delay per seq: "~data10);
    print("flare:num of seqs: "~data8);

    if (seqflare > data8) {
        print("flare seqs finish");
        stopflareseq();
        return 0;
    }

    print("flare seq start!");
    flare();
    if (relflare > data6) {
        print("flare rel fin. delaying");
        seqflare = seqflare + 1;
        stopflareseq();
        if (data10 == 1){flaremaindelay1.start();}
        if (data10 == 2){flaremaindelay1.start();}
        if (data10 == 3){flaremaindelay2.start();}
        if (data10 == 4){flaremaindelay3.start();}
        if (data10 == 5){flaremaindelay4.start();}
        if (data10 == 6){flaremaindelay5.start();}
        if (data10 == 7){flaremaindelay6.start();}
        if (data10 == 8){flaremaindelay7.start();}
        if (data10 == 9){flaremaindelay8.start();}
        if (data10 == 10){flaremaindelay.start();}
        #chaffdelay.start();
        relflare = 0;
    }
}



var chaff = func() {
    if (getprop("f22/chaff") < 1){return 1;}
    setprop("f22/chaff",getprop("f22/chaff") - 1);
    setprop("rotors/main/blade[3]/position-deg",rand());
    print("chaff rel");
    screen.log.write("Chaff");
    relchaff = relchaff + 1;
    chaffreset.start();

}

var flare = func() {
    if (getprop("f22/flare") < 1){return 1;}
    setprop("f22/flare",getprop("f22/flare") - 1);
    setprop("rotors/main/blade[3]/flap-deg",rand());
    setprop("/ai/submodels/submodel/flare-release",1);
    screen.log.write("Flare");
    print("flare rel");
    relflare = relflare + 1;
    flarereset.start();
    damage.flare_released(); # show a flare model on MP
}

var finish = func() {
    seqchaff = 1;
    seqflare = 1;
    relchaff = 1;
    relflare = 1;
}

var updatecms = func() {
    var prgmselect = getprop("/controls/CMS/prgmselected");
    if (prgmselect == 1) {var letter = "a";}
    if (prgmselect == 2) {var letter = "b";}
    if (prgmselect == 3) {var letter = "c";}
    if (prgmselect == 4) {var letter = "d";}
    if (prgmselect == 5) {var letter = "e";}
    programname = getprop("/controls/CMS/prgm"~prgmselect~"name");
    #print("CMS program name: "~programname);
    setprop("controls/CMS/prgmname",programname);
    data1 = getprop("controls/CMS/" ~ letter ~ "1");     #   can Chaff on press of the button
    data2 = getprop("controls/CMS/" ~ letter ~ "2");     #   can Flare on press of the button
    data3 = getprop("controls/CMS/" ~ letter ~ "3");     #   Chaff delay per release
    data4 = getprop("controls/CMS/" ~ letter ~ "4");     #   Flare delay per release
    data5 = getprop("controls/CMS/" ~ letter ~ "5");     #   amnt Chaff to release in 1 sequence
    data6 = getprop("controls/CMS/" ~ letter ~ "6");     #   amnt Flare to release in 1 sequence
    data7 = getprop("controls/CMS/" ~ letter ~ "7");     #   Chaff Seq's
    data8 = getprop("controls/CMS/" ~ letter ~ "8");     #   Flare Seq's
    data9 = getprop("controls/CMS/" ~ letter ~ "9");     #   Chaff Delay per sequence
    data10 = getprop("controls/CMS/" ~ letter ~ "10");   #   Flare Delay per sequence

}




var check = func() {
    if (relchaff > data5) {
        print("Chaff rel fin. delaying");
        chaffdelayrel.stop();
        chaffdelayseq.start();
        relchaff = 0;

    }
}

var trigger = func() {
    updatecms();
    f22.flare();
    finish(); # reset sequnses
    print("CMS triggered");
    if (data1 == 1){
        # deploy chaff (on press)
        chaff();
        relchaff = 0;
    }
    if (data2 == 1){
        # deploy flare (on press)
        flare();
        relflare = 0;
    }
    #chaffdelayrel = maketimer(data3,chaff); # Delay per release
    #flaredelayrel = maketimer(data4,flare); # Delay per release
    #runchaffseq(data3,data5,data7,data9);
    if (data3 == 1){chaffmainseq1.start();}
    if (data3 == 2){chaffmainseq1.start();}
    if (data3 == 3){chaffmainseq2.start();}
    if (data3 == 4){chaffmainseq3.start();}
    if (data3 == 5){chaffmainseq4.start();}
    if (data3 == 6){chaffmainseq5.start();}
    if (data3 == 7){chaffmainseq6.start();}
    if (data3 == 8){chaffmainseq7.start();}
    if (data3 == 9){chaffmainseq8.start();}
    if (data3 == 10){chaffmainseq.start();}

    if (data4 == 1){flaremainseq1.start();}
    if (data4 == 2){flaremainseq1.start();}
    if (data4 == 3){flaremainseq2.start();}
    if (data4 == 4){flaremainseq3.start();}
    if (data4 == 5){flaremainseq4.start();}
    if (data4 == 6){flaremainseq5.start();}
    if (data4 == 7){flaremainseq6.start();}
    if (data4 == 8){flaremainseq7.start();}
    if (data4 == 9){flaremainseq8.start();}
    if (data4 == 10){flaremainseq.start();}

}

#chaffdelayrel = maketimer(data3,chaff); # Delay per release
    checkrel = maketimer(0,check);
flarereset = maketimer(0.1,resetflare);
chaffreset = maketimer(0.1,resetchaff);

    # Chaff

    chaffmainseq1 = maketimer(0.1,runchaffseq);
    chaffmainseq2 = maketimer(0.2,runchaffseq);
    chaffmainseq3 = maketimer(0.3,runchaffseq);
    chaffmainseq4 = maketimer(0.4,runchaffseq);
    chaffmainseq5 = maketimer(0.5,runchaffseq);
    chaffmainseq6 = maketimer(0.6,runchaffseq);
    chaffmainseq7 = maketimer(0.7,runchaffseq);
    chaffmainseq8 = maketimer(0.8,runchaffseq);
    chaffmainseq9 = maketimer(0.9,runchaffseq);
    chaffmainseq = maketimer(1,runchaffseq);


    chaffmaindelay1 = maketimer(1,runchaffseq);
    chaffmaindelay2 = maketimer(2,runchaffseq);
    chaffmaindelay3 = maketimer(3,runchaffseq);
    chaffmaindelay4 = maketimer(4,runchaffseq);
    chaffmaindelay5 = maketimer(5,runchaffseq);
    chaffmaindelay6 = maketimer(6,runchaffseq);
    chaffmaindelay7 = maketimer(7,runchaffseq);
    chaffmaindelay8 = maketimer(8,runchaffseq);
    chaffmaindelay9 = maketimer(9,runchaffseq);
    chaffmaindelay = maketimer(10,runchaffseq);

    # flare

    flaremainseq1 = maketimer(0.1,runflareseq);
    flaremainseq2 = maketimer(0.2,runflareseq);
    flaremainseq3 = maketimer(0.3,runflareseq);
    flaremainseq4 = maketimer(0.4,runflareseq);
    flaremainseq5 = maketimer(0.5,runflareseq);
    flaremainseq6 = maketimer(0.6,runflareseq);
    flaremainseq7 = maketimer(0.7,runflareseq);
    flaremainseq8 = maketimer(0.8,runflareseq);
    flaremainseq9 = maketimer(0.9,runflareseq);
    flaremainseq = maketimer(1,runflareseq);


    flaremaindelay1 = maketimer(1,runflareseq);
    flaremaindelay2 = maketimer(2,runflareseq);
    flaremaindelay3 = maketimer(3,runflareseq);
    flaremaindelay4 = maketimer(4,runflareseq);
    flaremaindelay5 = maketimer(5,runflareseq);
    flaremaindelay6 = maketimer(6,runflareseq);
    flaremaindelay7 = maketimer(7,runflareseq);
    flaremaindelay8 = maketimer(8,runflareseq);
    flaremaindelay9 = maketimer(9,runflareseq);
    flaremaindelay = maketimer(10,runflareseq);

#chaffmaindelay.stop();
#chaffmaindelay1.stop();
#chaffmaindelay2.stop();
#chaffmaindelay3.stop();
#chaffmaindelay4.stop();
#chaffmaindelay5.stop();
#chaffmaindelay6.stop();
#chaffmaindelay7.stop();
#chaffmaindelay8.stop();
#chaffmaindelay9.stop();

    chaffmainseq.stop();
    #runchaffseq();

print("cms.nas: Ready");
updatecms();
updatetimer = maketimer(1,updatecms);
updatetimer.start();
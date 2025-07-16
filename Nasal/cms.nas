# cms.nas
# Authors: Phoenix
# F-22A custom counter messures controller

# blade 3 flap deg flare 0-1
# blade 3 position deg chaff 0-1

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

var runchaffseq = func() {
    f22.flare();
    chaffmaindelay.stop();
        chaffmainseq.start();
    print("delay per rel: "~data3);
    print("delay per seq: "~data9);
    print("num of seqs: "~data7);

    if (seqchaff > data7) {
        print("chaff seqs finish");
    chaffmainseq.stop();
        return 0;
    }

    print("chaff seq start!");
    chaff();
    if (relchaff > data5) {
        print("Chaff rel fin. delaying");
        seqchaff = seqchaff + 1;
        chaffmainseq.stop();
        chaffmaindelay.start();
        #chaffdelay.start();
        relchaff = 0;
    }
}


var chaff = func() {
    setprop("rotors/main/blade[3]/position-deg",rand());
    print("chaff rel");
    relchaff = relchaff + 1;
    chaffreset.start();

}

var flare = func() {
    setprop("rotors/main/blade[3]/flap-deg",rand());
    setprop("/ai/submodels/submodel/flare-release",1);
    print("flare rel");
    relflare = relflare + 1;
    flarereset.start();
    damage.flare_released(); # show a flare model on MP
}

var finish = func() {
    seqchaff = 0;
    seqflare = 0;
    relchaff = 0;
    relflare = 0;
}

var updatecms = func() {
    var prgmselect = getprop("/controls/CMS/prgmselected");
    if (prgmselect == 1) {var letter = "a";}
    if (prgmselect == 2) {var letter = "b";}
    if (prgmselect == 3) {var letter = "c";}
    if (prgmselect == 4) {var letter = "d";}
    if (prgmselect == 5) {var letter = "e";}
    programname = getprop("/controls/CMS/prgm"~prgmselect~"name");
    print("CMS program name: "~programname);
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
    chaffmainseq.start();


}

#chaffdelayrel = maketimer(data3,chaff); # Delay per release
    checkrel = maketimer(0,check);
flarereset = maketimer(0.1,resetflare);
chaffreset = maketimer(0.1,resetchaff);


    chaffmainseq = maketimer(0.8,runchaffseq);
    chaffmaindelay = maketimer(3,runchaffseq);
    chaffmainseq.stop();
    #runchaffseq();

print("cms.nas: Ready");
updatecms();
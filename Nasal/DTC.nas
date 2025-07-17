# Data Cartridge for the F-22A Raptor
# All code by Scarface 1 -- Phoenix
# This can be used to share CMDS prgms, set datalink, COMM Radios, Other settings
setprop("f22/dtcdesc","");
    # Datalink
    var readdatalink = func(datacart,pointer) {
        var line1 = split(":",datacart[pointer + 1]);
        print("Datalink config mode enabled -->");
        print(line1[0]);
        if (line1[0] == "CODE") {
            var line2 = split(":", datacart[pointer + 2]);    
            var code = num(line2[0]);   
            print("DTC.nas: Datalink code changed to: "~code);
            setprop("instrumentation/datalink/channel",code);
        }
    }

    # BINGO
    var readbingo = func(datacart,pointer) {
        var line1 = split(":",datacart[pointer + 1]);
        print("DTC BINGO:");
        print(line1[0]);
        var code = num(line1[0]);   
        print("DTC.nas: Bingo Fuel changed to: "~code);
        setprop("f22/bingo",code);
    }

    var readscrlog = func(datacart,pointer) {
        var line1 = split(":",datacart[pointer + 1]);
        print("SCREENLOG:");
        print(line1[0]);
        var msg = line1[0];   
        screen.log.write(msg);
        print("from DTC Cart: SCREENLOG: "~msg);
    }
    var readdtcdesc = func(datacart,pointer) {
        var line1 = split(":",datacart[pointer + 1]);
        print("DTCDESC:");
        print(line1[0]);
        var msg = line1[0];   
        setprop("f22/dtcdesc",msg);
        print("from DTC Cart: DTCDESC: "~msg);
    }

    # Chaff Flare Programs
    var readcmdsdata = func(datacart,pointer) {
    print("Found CMDS!");
    screen.log.write("Found CMDS's Programs on the DTC");
    # ok we know that the datacart[pointer] == "CMDS:" lets see whats below
    # Expect "PRGM1" or "PRGM2", etc
    var entries = size(datacart) - pointer;
    for(var i = 0; i < entries; i += 1) { # start at 0
            print("i = "~i~ "\n");
        var line1 = split(":", datacart[pointer + i]);
        if (line1[0] == "PRGM1") {
            print("Found PRGM1");
            # Program1!

            var listname = split(":",datacart[pointer + i + 1]);
            var prgmname = listname[0];
            var letter = "a";
            # data1 = getprop("controls/CMS/" ~ letter ~ "1");     #   can Chaff on press of the button
            # data2 = getprop("controls/CMS/" ~ letter ~ "2");     #   can Flare on press of the button
            # data3 = getprop("controls/CMS/" ~ letter ~ "3");     #   Chaff delay per release
            # data4 = getprop("controls/CMS/" ~ letter ~ "4");     #   Flare delay per release
            # data5 = getprop("controls/CMS/" ~ letter ~ "5");     #   amnt Chaff to release in 1 sequence
            # data6 = getprop("controls/CMS/" ~ letter ~ "6");     #   amnt Flare to release in 1 sequence
            # data7 = getprop("controls/CMS/" ~ letter ~ "7");     #   Chaff Seq's
            # data8 = getprop("controls/CMS/" ~ letter ~ "8");     #   Flare Seq's
            # data9 = getprop("controls/CMS/" ~ letter ~ "9");     #   Chaff Delay per sequence
            # data10 = getprop("controls/CMS/" ~ letter ~ "10");   #   Flare Delay per sequence
            var data1 = split(":",datacart[pointer + i + 2]);
            var data2 = split(":",datacart[pointer + i + 3]);
            var data3 = split(":",datacart[pointer + i + 4]);
            var data4 = split(":",datacart[pointer + i + 5]);
            var data5 = split(":",datacart[pointer + i + 6]);
            var data6 = split(":",datacart[pointer + i + 7]);
            var data7 = split(":",datacart[pointer + i + 8]);
            var data8 = split(":",datacart[pointer + i + 9]);
            var data9 = split(":",datacart[pointer + i + 10]);
            var data10 = split(":",datacart[pointer + i + 11]);
            var num1 = num(data1[0]);
            var num2 = num(data2[0]);
            var num3 = num(data3[0]);
            var num4 = num(data4[0]);
            var num5 = num(data5[0]);
            var num6 = num(data6[0]);
            var num7 = num(data7[0]);
            var num8 = num(data8[0]);
            var num9 = num(data9[0]);
            var num10 = num(data10[0]);
            print("Data read from DTC on PRGM1!");
            print("CMDS PRGM1 Name: "~prgmname);
            print(num1);
            print(num2);
            print(num3);
            print(num4);
            print(num5);
            print(num6);
            print(num7);
            print(num8);
            print(num9);
            print(num10);
        }
        elsif (line1[0] == "PRGM2") {
            print("Found PRGM2");
            # Program2!
            var listname = split(":",datacart[pointer + 1]);
            var prgmname = listname[0];
            var letter = "a";
            var data1 = split(":",datacart[pointer + i + 2]);
            var data2 = split(":",datacart[pointer + i + 3]);
            var data3 = split(":",datacart[pointer + i + 4]);
            var data4 = split(":",datacart[pointer + i + 5]);
            var data5 = split(":",datacart[pointer + i + 6]);
            var data6 = split(":",datacart[pointer + i + 7]);
            var data7 = split(":",datacart[pointer + i + 8]);
            var data8 = split(":",datacart[pointer + i + 9]);
            var data9 = split(":",datacart[pointer + i + 10]);
            var data10 = split(":",datacart[pointer + i + 11]);
            var num1 = num(data1[0]);
            var num2 = num(data2[0]);
            var num3 = num(data3[0]);
            var num4 = num(data4[0]);
            var num5 = num(data5[0]);
            var num6 = num(data6[0]);
            var num7 = num(data7[0]);
            var num8 = num(data8[0]);
            var num9 = num(data9[0]);
            var num10 = num(data10[0]);
            print("Data read from DTC on PRGM2!");
            print("CMDS PRGM2 Name: "~prgmname);
            print(num1);
            print(num2);
            print(num3);
            print(num4);
            print(num5);
            print(num6);
            print(num7);
            print(num8);
            print(num9);
            print(num10);
            }   elsif (line1[0] == "PRGM3") {
            print("Found PRGM3");
            # Program3!
            var listname = split(":",datacart[pointer + i + 1]);
            var prgmname = listname[0];
            var letter = "a";
            var data1 = split(":",datacart[pointer + i + 2]);
            var data2 = split(":",datacart[pointer + i + 3]);
            var data3 = split(":",datacart[pointer + i + 4]);
            var data4 = split(":",datacart[pointer + i + 5]);
            var data5 = split(":",datacart[pointer + i + 6]);
            var data6 = split(":",datacart[pointer + i + 7]);
            var data7 = split(":",datacart[pointer + i + 8]);
            var data8 = split(":",datacart[pointer + i + 9]);
            var data9 = split(":",datacart[pointer + i + 10]);
            var data10 = split(":",datacart[pointer + i + 11]);
            var num1 = num(data1[0]);
            var num2 = num(data2[0]);
            var num3 = num(data3[0]);
            var num4 = num(data4[0]);
            var num5 = num(data5[0]);
            var num6 = num(data6[0]);
            var num7 = num(data7[0]);
            var num8 = num(data8[0]);
            var num9 = num(data9[0]);
            var num10 = num(data10[0]);
            print("Data read from DTC on PRGM3!");
            print("CMDS PRGM3 Name: "~prgmname);
            print(num1);
            print(num2);
            print(num3);
            print(num4);
            print(num5);
            print(num6);
            print(num7);
            print(num8);
            print(num9);
            print(num10);
            } elsif (line1[0] == "PRGM4") {
            print("Found PRGM4");
            # Program4!
            var listname = split(":",datacart[pointer + i + 1]);
            var prgmname = listname[0];
            var letter = "d";
            var data1 = split(":",datacart[pointer + i + 2]);
            var data2 = split(":",datacart[pointer + i + 3]);
            var data3 = split(":",datacart[pointer + i + 4]);
            var data4 = split(":",datacart[pointer + i + 5]);
            var data5 = split(":",datacart[pointer + i + 6]);
            var data6 = split(":",datacart[pointer + i + 7]);
            var data7 = split(":",datacart[pointer + i + 8]);
            var data8 = split(":",datacart[pointer + i + 9]);
            var data9 = split(":",datacart[pointer + i + 10]);
            var data10 = split(":",datacart[pointer + i + 11]);
            var num1 = num(data1[0]);
            var num2 = num(data2[0]);
            var num3 = num(data3[0]);
            var num4 = num(data4[0]);
            var num5 = num(data5[0]);
            var num6 = num(data6[0]);
            var num7 = num(data7[0]);
            var num8 = num(data8[0]);
            var num9 = num(data9[0]);
            var num10 = num(data10[0]);
            print("Data read from DTC on PRGM4!");
            print("CMDS PRGM4 Name: "~prgmname);
            print(num1);
            print(num2);
            print(num3);
            print(num4);
            print(num5);
            print(num6);
            print(num7);
            print(num8);
            print(num9);
            print(num10);
            }
        }
    }


    # Fileops
    var exportdir = getprop("/sim/fg-home")~"/Export";
    var loadcart = func(dtcpath) {
        print("loading DTC");
        print(dtcpath.getValue()); # has to be getValue
        var data = nil;

        # error detection
        call(func{data=io.readfile(dtcpath.getValue());},nil,var erroronload = []);
        if (size(erroronload)) {
            screen.log.write("Error loading DTC");
        } elsif (data != nil) {
        print("DTC.nas: READ");
        print(data);
        var datasplit = split("\n", data);
        print("DATA ENTRIES IN DTC: "~size(datasplit));
        var entries = size(datasplit);
        for(var i = 0; i < entries; i += 1) {
                var newvector = split(":", datasplit[i]); 
                # Syntax parser
                if (newvector[0] == "DLINK"){
                    readdatalink(datasplit,i);
                    print("Executed: DLINK");
                }
                if (newvector[0] == "BINGO"){
                    readbingo(datasplit,i);
                    print("Executed: BINGO");
                }
                if (newvector[0] == "CMDS"){
                    readcmdsdata(datasplit,i);
                    print("Executed: CMDS");
                }
                if (newvector[0] == "SCREENLOG"){
                    readscrlog(datasplit,i);
                    print("Executed: SCREENLOG");
                }
                if (newvector[0] == "DTCDESC"){
                    readdtcdesc(datasplit,i);
                    print("Executed: DTCDESC");
                }
                else{
                    print("Unknown command at [line] "~i);
                }
        }
        }
    }
changedtc = gui.FileSelector.new(callback: loadcart,title: "Select a Data Cartridge (.raptordtc)",button: "Load DTC",dir: exportdir,dotfiles: 1,pattern: ["*.raptordtc"]);

selectnewdtc = func(){
changedtc.open();
}
#selectnewdtc();
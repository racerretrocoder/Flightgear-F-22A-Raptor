# this is a simple auto updating script     \\\\ Phoenix
# looks for an xml file on the github repo, reads the <version> and compares it with our <version>
print("Loading vercheck.nas...");
var checkinfo = func() {
    # update check
    var ourversion = getprop("/version/version");
    var newversion = getprop("/version/rep/version/version"); # version version version version version version version version 
    var newdetail = getprop("/version/rep/version/detail");
    # now check
    if (ourversion != newversion) {
        # new version!
        screen.log.write("New F-22A Raptor updates available on github!",0,1,0);
        screen.log.write("Details on update: "~newdetail~"",0,1,0);
        screen.log.write("https://github.com/racerretrocoder/Flightgear-F-22A-Raptor",0,1,0);
    } 
}

var checkupdate = func() {
    var httpstring="https://raw.githubusercontent.com/racerretrocoder/Flightgear-F-22A-Raptor/refs/heads/master/ver.xml"; # in order for this to work, after every commit, click download master zip (you can cancel it to save time)
	var params1=props.Node.new({
		"url"		:	httpstring,
		"targetnode"	:	"/version/rep",
		"complete"	:	"/version/complete"
	});
	fgcommand("xmlhttprequest", params1);
	#removelistener(login_listener);
	login_listener=setlistener("/version/complete", checkinfo);
}

var aestart = func() {
    # wait 10 seconds, then check
    if (getprop("f22/cancheckupdates") == 1) {
        print("vercheck.nas Checking for F-22A updates on GitHub...");
        checkupdate();
    }
    ae.stop();
}
var ae = maketimer(10,aestart);
ae.start();
print("vercheck.nas: Ready!");
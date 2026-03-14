# this is a simple auto updating script
# looks for an xml file on the github repo, reads the <version> and compares it with our <version>

var checkinfo = func() {
    print("info check!");
}

var checkupdate = func() {
    var httpstring="https://raw.githubusercontent.com/racerretrocoder/Flightgear-F-22A-Raptor/refs/heads/master/ver.xml";
        print(httpstring);
		var params1=props.Node.new({
			"url"		:	httpstring,
			"targetnode"	:	"/version/rep",
			"complete"	:	"/version/complete"
		});
		fgcommand("xmlhttprequest", params1);
		#removelistener(login_listener);
		login_listener=setlistener("/version/complete", checkinfo);
}
checkupdate();
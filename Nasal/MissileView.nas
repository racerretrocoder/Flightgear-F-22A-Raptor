#print("*** LOADING MissileView.nas ... ***");
var missile_view_handler = {
  init: func(node) {
    me.viewN = node;
    me.current = nil;
    me.legendN = props.globals.initNode("/sim/current-view/missile-view", "");
    me.dialog = props.Node.new({ "dialog-name": "missile-view" });
    me.listener = nil;
  },
  start: func {
    me.listener = setlistener("/sim/signals/ai-updated", func me._update_(), 1);
    me.reset();
    fgcommand("dialog-show", me.dialog);
  },
  stop: func {
    fgcommand("dialog-close", me.dialog);
    if (me.listener!=nil)
    {
      removelistener(me.listener);
      me.listener=nil;
    }
  },
  reset: func {
    me.select(0);
  },
  find: func(callsign) {
    forindex (var i; me.list)
      if (me.list[i].callsign == callsign)
        return i;
    return nil;
  },
  select: func(which, by_callsign=0) {
    if (by_callsign or num(which) == nil)
      which = me.find(which) or 0;  # turn callsign into index

    me.setup(me.list[which]);
  },
  next: func(step) {
    #ai.model.update();
    me._update_();
    var i = me.find(me.current);
    i = i == nil ? 0 : math.mod(i + step, size(me.list));
    me.setup(me.list[i]);
  },
  _update_: func {
    var self = { callsign: getprop("/sim/multiplay/callsign"), model:,
        node: props.globals, root: '/' };
    #ai.myModel.update();
    me.list = [self] ~ myModel.get_list();
    if (!me.find(me.current))
      me.select(0);
  },
  setup: func(mpid) {
#  
#  
#  
#  
#  
#  
#  
#  

    me.current = "eject";
   me.legendN.setValue("eject");
    setprop("/sim/current-view/z-offset-m", 10);
    setprop("/sim/current-view/heading-offset-deg", 110);
    setprop("/sim/current-view/pitch-offset-deg", 30);
    
    #print(me.current);

    me.viewN.getNode("config").setValues({
      "eye-lat-deg-path": "/ai/models/missile[" ~ mpid ~ "]/position/latitude-deg",
      "eye-lon-deg-path": "/ai/models/missile[" ~ mpid ~ "]/longitude-deg",
      "eye-alt-ft-path": "/ai/models/missile[" ~ mpid ~ "]/position/altitude-ft",
      "eye-heading-deg-path": "/ai/models/missile[" ~ mpid ~ "]/orientation/true-heading-deg",
      "target-lat-deg-path": "/ai/models/missile[" ~ mpid ~ "]/position/latitude-deg",
      "target-lon-deg-path": "/ai/models/missile[" ~ mpid ~ "]/position/longitude-deg",
      "target-alt-ft-path": "/ai/models/missile[" ~ mpid ~ "]/position/altitude-ft",
      "target-heading-deg-path": "/ai/models/missile[" ~ mpid ~ "]/orientation/true-heading-deg",
      "target-pitch-deg-path": "/ai/models/missile[" ~ mpid ~ "]/orientation/pitch-deg",
      "target-roll-deg-path": "/ai/models/missile[" ~ mpid ~ "]/orientation/roll-deg",
      "heading-offset-deg":180
    });
  },
};

var myModel = ai.AImodel.new();
myModel.init();

view.manager.register("Missile View",missile_view_handler);


var view_firing_missile = func(mpid)
{


    # We memorize the initial view number
    var actualView = getprop("/sim/current-view/view-number");

    # We activate the AI view (on this aircraft it is the number 8)
    view.setViewByIndex(101);
    
    # We feed the handler
    missile_view_handler.setup(mpid);
}

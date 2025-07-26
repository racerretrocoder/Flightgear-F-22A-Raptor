# Electrical System
#
# Gary Neely aka 'Buckaroo'
#
# General-purpose electrical system for voltage propogation, loosely based on the Flightgear
# system but implemented in nasal rather than C. See my related document for details and
# configuration notes.
#
# For most purposes you will not need to edit this file. You might want to change the update
# period, and if you choose a different component location you might want to change the
# component path.
#
# Version 1.1. Released under GPL v2.
#


var ELECTRICAL_UPDATE	= 0.3;									# Update interval in seconds. Set to 0 for once/frame
var component_path	= "/sim/systems/electrical";						# Location of component and connector lists



var component_list	= props.globals.getNode(component_path).getChildren("component");	# Get list of components
var components		= {};									# Component hash
var components_lastvolts= {};									# Quick test hash (see update section)
var suppliers		= [];
var connector_list	= props.globals.getNode(component_path).getChildren("connector");	# Get list of connectors
var connectors		= [];									# Connector list



var electrical_update = func {
										# Update suppliers:
										# Mostly this is to update alternators based on the status
										# of their source-prop, typically engine RPM. But it might
										# also update the status of an external power souce, or a
										# weakened or discharged battery. Currently these last two
										# are stubs; fill in code if desired.
  foreach(var supplier; suppliers) {
    var volts = 0;
    var ideal_volts = components[supplier].getNode("volts").getValue();		# Not very realistic, but good enough
    var kind = components[supplier].getNode("kind").getValue();
    if (kind == "alternator") {
      var min = components[supplier].getNode("source-min").getValue();
      var source_val = getprop(components[supplier].getNode("source-prop").getValue());
      if (min == nil) { min = 0; }						# Minimum value may not yet be initialized
      if (min == 0 or source_val >= min) {					# Alternator has good volts if source is up to speed
        volts = ideal_volts;
      }
      else {
        volts = source_val / min * ideal_volts;					# Otherwise it delivers some weak fractional voltage
      }
    }
    elsif (kind == "external") {						# Simple conditions for ground service
      if (getprop("/gear/gear[0]/wow") and getprop("velocities/groundspeed-kt") < 0.1) {
        volts = ideal_volts;
      }
    }
    else { #kind == "battery"							# Stub: currently batteries always show good volts.
      volts = ideal_volts;
    }
    setprop(components[supplier].getNode("prop").getValue(),volts);
  }


										# The lastvolts hash keeps a record of the last
										# setting of outputs. If a component can receive volts
										# from 2 or more suppliers, we want the greatest of these
										# otherwise one set to 0 might over-write one set to 28.
  foreach(var i; keys(components_lastvolts)) {					# Reset lastvolts for each component
    components_lastvolts[i] = -1;
  }

										# Propogate power:
  foreach(var connector; connectors) {
    var closed = 1;								# Circuit begins closed
    var last_test = 0;
    var switches = connector.getChildren("switch");				# Begin testing all associated switches
    foreach(var switch; switches) {
      last_test = getprop(switch.getValue());					# Save the last test for 'variable' outputs
      if (last_test == nil or last_test == 0) {
        closed = 0;								# Stop tests if any switch is open
        break;
      }
    }
    var input_component = components[connector.getNode("input").getValue()];
    var output = connector.getNode("output").getValue();
    var input_volts = 0;							# Default to an open circuit
    if (closed) {								# Switches all tested positive
      input_volts = getprop(input_component.getChildren("prop")[0].getValue());
      if (input_volts == nil) { input_volts = 0; }				# Non-suppliers may not yet be initialized

      if (input_volts > 0 and connector.getNode("variable") != nil) {		# Indicates special variable control switch output
        if (connector.getNode("scale") != nil) {				# Indicates variable output scales input volts
          input_volts = input_volts * last_test * connector.getNode("scale").getValue();
        }
        else {
          input_volts = last_test;						# Output value takes on value of last switch output
        }
      }

      var scheme = connector.getNode("scheme").getValue();			# Scheme stuff:
      if (scheme == 0) {}							# Output is simply input volts
      elsif (scheme == 1) {
        input_volts = last_test;						# Propagate the last value of the last switch
      }
      elsif (scheme == 2) {
        input_volts = input_volts * last_test;					# Propagate volts * the value of the last switch
      }
      elsif (scheme == 3) {
        if (connector.getNode("scalar-value") != nil) {
          input_volts = connector.getNode("scalar-value").getValue();		# Propagate a real number
        }
        elsif (connector.getNode("scalar-prop") != nil) {
          input_volts = getprop(connector.getNode("scalar-prop").getValue());	# Propagate a real number from a property
        }
        else { input_volts = 1; }						# Should never see this if validations worked
      }

										# Factoring option:
      if (input_volts > 0) {
        if (connector.getNode("factor") != nil) {
          input_volts = input_volts * connector.getNode("factor").getValue();
        }
        elsif (connector.getNode("factor-prop") != nil) {
          input_volts = input_volts * getprop(connector.getNode("factor-prop").getValue());
        }
      }

    }
    if (input_volts > components_lastvolts[output]) {				# Update only if input > previous inputs
      var output_component = components[output];
      var output_props = output_component.getChildren("prop");
      for (var i=0; i<size(output_props); i+=1) {				# Set component's outputs to new volts
        setprop(output_props[i].getValue(),input_volts);
      }
      components_lastvolts[output] = input_volts;				# Record best input volts for this component
    }
  } # foreach connectors

  settimer(electrical_update, ELECTRICAL_UPDATE);				# You go back, Jack, do it again...
}



var electrical_init = func {

  print("Initializing electrical system...");
  										# Validate and build component list:
  for(var i=0; i<size(component_list); i+=1) {
    										# Validations:
    if (component_list[i].getNode("name") == nil) {
      print("Error: missing name for component ",i);
      continue;									# Skip component if no name
    }
    var name = component_list[i].getNode("name").getValue();
    if (contains(components,name)) {
      print("Error: duplicate component '",name,"'");
      continue;									# Skip if duplicate
    }
    if (component_list[i].getNode("kind") == nil) {
      print("Error: missing kind for component '",name,"'");
      continue;									# Skip if no kind
    }
    var kind = component_list[i].getNode("kind").getValue();
    if (kind != "battery" and
        kind != "alternator" and
        kind != "external" and
        kind != "output") {
      print("Error: bad kind for component '",name,"'");
      continue;									# Skip if bad kind
    }
    var supplier = 0;
    if (kind != "output") { supplier = 1; }
    if (supplier and component_list[i].getNode("volts") == nil) {
      print("Error: missing volts for supplier '",name,"'");
      continue;									# Skip if supplier has no ideal volts
    }
    if (kind == "alternator" and component_list[i].getNode("source-prop") == nil) {
      print("Error: missing source-prop for alternator '",name,"'");
      continue;									# Skip if alternator and no source-prop
    }
    if (kind == "alternator" and component_list[i].getNode("source-min") == nil) {
      print("Error: missing source-min for alternator '",name,"'");
      continue;									# Skip if alternator and no source-min
    }
    if (size(component_list[i].getChildren("prop")) == 0) {
      print("Error: missing prop component(s) for ",name);
      continue;									# Skip if no properties
    }
  
  										# All validations passed,
    components[name]		= component_list[i];				# Add component to hash
    components_lastvolts[name]	= 0;						# Setup quickie test hash
    if (supplier) {
      append(suppliers,name);							# Append supplier name to suppliers list
    }
  }
  
  
  										# Validate and build connector list:
  for(var i=0; i<size(connector_list); i+=1) {
    										# Validations:
    var name = "";
    if (connector_list[i].getNode("name") != nil and
        size(connector_list[i].getNode("name").getValue()) > 0) {		# Optional name field; used only in error reporting
      name = " ("~connector_list[i].getNode("name").getValue()~")";		# form: ' (<name>) '
    }
    if (connector_list[i].getNode("input") == nil) {
      print("Error: missing input for connector ",i,name);
      continue;									# Skip connector if no input
    }
    var input = connector_list[i].getNode("input").getValue();
    if (!contains(components,input)) {
      print("Error: connector ",i,name," input: '",input,"' has no match in component list");
      continue;									# Skip connector if input matches no component
    }
    if (connector_list[i].getNode("output") == nil) {
      print("Error: missing output for connector ",i,name);
      continue;									# Skip connector if no output
    }
    var output = connector_list[i].getNode("output").getValue();
    if (!contains(components,output)) {
      print("Error: connector ",i,name," output: '",output,"' has no match in component list");
      continue;									# Skip connector if output matches no component
    }
    if (input == output) {
      print("Error: connector ",i,name," tried to tie to itself");
      continue;									# Skip connector if output matches input
    }
    if (components[output].getNode("kind").getValue() != "output") {
      print("Error: connector ",i,name," tried to tie to a source");
      continue;									# Skip connector if output is a source
    }
    if    (connector_list[i].getNode("scheme") == nil)				{ connector_list[i].getNode("scheme",1); connector_list[i].getNode("scheme").setValue(0); }
    elsif (connector_list[i].getNode("scheme").getValue() == "volts")		{ connector_list[i].getNode("scheme").setValue(0); }
    elsif (connector_list[i].getNode("scheme").getValue() == "switch")		{ connector_list[i].getNode("scheme").setValue(1); }
    elsif (connector_list[i].getNode("scheme").getValue() == "switch-volts")	{ connector_list[i].getNode("scheme").setValue(2); }
    elsif (connector_list[i].getNode("scheme").getValue() == "scalar")		{ connector_list[i].getNode("scheme").setValue(3); }
    else {
      print("Error: connector ",i,name," has an invalid scheme");
      continue;									# Skip connector if bad scheme
    }
    if (connector_list[i].getNode("scheme").getValue() == 3) {
      if (connector_list[i].getNode("scalar-value") == nil and
          connector_list[i].getNode("scalar-prop") == nil) {
        print("Error: connector ",i,name," scalar missing scalar-value or scalar-prop");
        continue;								# Skip connector if bad scheme
      }
      if (connector_list[i].getNode("scalar-value") != nil and
          connector_list[i].getNode("scalar-prop") != nil) {
        print("Error: connector ",i,name," scalar has both scalar-value and scalar-prop");
        continue;								# Skip connector if bad scheme
      }
    }
  										# All validations passed,
    append(connectors,connector_list[i]);					# Add connector to list
  }
  
  print("...Done.");
}



electrical_init();
settimer(electrical_update, 3);


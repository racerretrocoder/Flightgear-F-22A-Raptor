# Phoenix's Railgun Experiments
#
#   Idea: We have 2 planes ina circle fight. Our plane has a railgun and the bandit is.. well a bandit
#   in order for the railgun shot to hit we need 2 things
#   1: Our heading pointing within a set range of +- 5 degreese at the target, 2: Our pitch pointing within a setrange of +- 5 degreese at the target
#   
#   the heading is simple as:

#   if(ourhdg > bandithdg1) {
#       print("Attack Complies 1/2");
#       if(ourhdg < bandithdg2){
#           print("Attack Complies 2/2");
#          Calculate pitch here
#           }
#       }
#   } else{
#       print("Bandit Not withen Heading");
#       radar_timer.stop();
#       # How to get the next locked radar target: radar.tgts_list[radar.Target_Index].Callsign.getValue()
#       }



# pitch is more complicated
#this model may explain more

#
#       TGTHERE
#          |\
#          |  \
#          |    \
#altitude  |      \          
#above us  |        \        
#from tgt  |          \      
#          |            \    
#          | 90deg        \    the angle to the target is what we need to get 
#          |________________\ <--OUR PLANE
#           Exact distance to 
#             tgt (in FT)
           
# to calculate the opposite we can do If the target is greater than our alt. Adjacent = targetalt - our alt
# atan (sin(a)/cos(a) is our way through)
# then we convert to deg

var ourhdg = getprop("orientation/heading-deg");


var test = func() {
    # heading part first


var num = math.atan2(6000, 2000);

}
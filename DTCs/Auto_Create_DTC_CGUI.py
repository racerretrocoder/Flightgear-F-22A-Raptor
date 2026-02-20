# Create_DTC.py
import os,time
os.system("cls")
print("============================================================")
print("FlightGear F-22A Automatic Raptor Datacartidge Creator (DTC)")
print("Use this to automatically create a custom DTC to use")
print("Code written by Phoenix")
print("============================================================")
link16code = 0
dlans = "n"
dlans = input("Would you like to include a datalink code? (y/n) ")
if dlans == "y":
    try:
        link16code = int(input("Please enter the datalink code: "))
    except:
        print("The datalink code bust be an integar!")
else:
    print("Ok no datalink code will be applied") 
bingo = int(input("What should bingo fuel be? (number, integer) "))
cmds = input("Do you want to modify the default CMDS programs? (This feature not ready yet)")
if cmds == "y":
    prgmname = input("Please enter a name for PRGM1 ")
    print("The datalink code bust be an integar!")
else:
    print("Ok CMDs will remain there default values") 

print("Thats all! The DTC will be outputed to output.raptordtc. Drop it in your export folder for FG. Enjoy! :)")
with open('output.raptordtc', 'a') as raptordtc:
    raptordtc.write('RAPTORDTC: \n')
    raptordtc.write('SCREENLOG: \n')
    raptordtc.write('Loading DTC...: \n')
    if link16code != 0:
        raptordtc.write('DLINK: \n')
        raptordtc.write('CODE: \n')
        raptordtc.write(f'{link16code}: \n')
    raptordtc.write('BINGO: \n')
    raptordtc.write(f'{bingo}: \n')
    raptordtc.write('SCREENLOG: \n')
    raptordtc.write('DTC Loaded!: \n')
    raptordtc.close()
print("The file has finished!")
time.sleep(10)
exit()
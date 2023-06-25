#--------- IMPORT MODULS ---------------------------------------------------------------------------------
import sys
from hashlib  import sha3_256, sha3_512, shake_128, shake_256
from tkinter import S
import os
import subprocess
import random
import codecs

def SHA3_function(hex_value):
    """
    Function that converts the hex value given in input to the SHA3_tb to string, in order to 
    use SHA3 python function correctly
    """
    if (SHA3_MODE=="00"):
        hash = sha3_256(bytes.fromhex(hex_value))
        result = hash.hexdigest()
    if (SHA3_MODE=="01"):
        hash = sha3_512(bytes.fromhex(hex_value))
        result = hash.hexdigest() 
    if (SHA3_MODE=="10"):
        hash = shake_128(bytes.fromhex(hex_value))
        result = hash.hexdigest(96)   
    if (SHA3_MODE=="11"):
        if SHA3_OP=="00":
            hash = shake_256(bytes.fromhex(hex_value))
            result = hash.hexdigest(128)   
        if SHA3_OP=="01":
            hash = shake_256(bytes.fromhex(hex_value))
            result = hash.hexdigest(32) 
    return result

def compare_results(SHA3_PY_result, SHA3_VHDL_result):

    PY_result = SHA3_PY_result.strip()
    VHDL_result = SHA3_VHDL_result.strip()
    if (PY_result==VHDL_result):
        err=0
    else:
        err=1
        
    return err



#----------------------------------------------------------------------------------------------------------------------------------------------
#********************************************* MAIN FILE **************************************************************************************
#----------------------------------------------------------------------------------------------------------------------------------------------
SHA3_MODE=input("Please enter the primitive you want to execute:\n\t-00) SHA3_256\n\t-01) SHA3_512\n\t-10) SHAKE_128\n\t-11) SHAKE_256\n")	
print("Please enter the operation you want to execute.\n")	

if SHA3_MODE=="00":
    SHA3_OP=input("00) H(pk)\n01) H(c)\n10) H(m)\n")
elif SHA3_MODE=="01":
    SHA3_OP=input("00) G(d)\n01) G(m||H(pk))\n10) G(m'||h)\n")
elif SHA3_MODE=="10":
    SHA3_OP=input("00) XOF \n01) PRF\n")
else:
    SHA3_OP=input("00) KDF (264 bit) \n01) KDF (512bit)\n")



#----------------------------------------------------------------------------------------------------------------------------------------------
#********************************************* FILE management ********************************************************************************
#----------------------------------------------------------------------------------------------------------------------------------------------



if SHA3_MODE=="00":
    if SHA3_OP=="00":
        input_filename = 'SHA3_IN_0000.txt'
        results_filename = "SHA3_OUT_0000.txt"
        log_filename = "log_file_SHA3_0000.txt"
    if SHA3_OP=="01":
        input_filename = 'SHA3_IN_0001.txt'
        results_filename = "SHA3_OUT_0001.txt"
        log_filename = "log_file_SHA3_0001.txt"
    elif SHA3_OP=="10":
        input_filename = 'SHA3_IN_0010.txt'
        results_filename = "SHA3_OUT_0010.txt"
        log_filename = "log_file_SHA3_0010.txt"

elif SHA3_MODE=="01":
    if SHA3_OP=="00":
        input_filename = 'SHA3_IN_0100.txt'
        results_filename = "SHA3_OUT_0100.txt"
        log_filename = "log_file_SHA3_0100.txt"
    if SHA3_OP=="01":
        input_filename = 'SHA3_IN_0101.txt'
        results_filename = "SHA3_OUT_0101.txt"
        log_filename = "log_file_SHA3_0101.txt"
    elif SHA3_OP=="10":
        input_filename = 'SHA3_IN_0110.txt'
        results_filename = "SHA3_OUT_0110.txt"
        log_filename = "log_file_SHA3_0110.txt"
elif SHA3_MODE=="10":
    if SHA3_OP=="00":
        input_filename = 'SHA3_IN_1000.txt'
        results_filename = "SHA3_OUT_1000.txt"
        log_filename = "log_file_SHA3_1000.txt"
    if SHA3_OP=="01":
        input_filename = 'SHA3_IN_1001.txt'
        results_filename = "SHA3_OUT_1001.txt"
        log_filename = "log_file_SHA3_1001.txt"
elif SHA3_MODE=="11":
    if SHA3_OP=="00":
        input_filename = 'SHA3_IN_1100.txt'
        results_filename = "SHA3_OUT_1100.txt"
        log_filename = "log_file_SHA3_1100.txt"
    if SHA3_OP=="01":
        input_filename = 'SHA3_IN_1101.txt'
        results_filename = "SHA3_OUT_1101.txt"
        log_filename = "log_file_SHA3_1101.txt"


script_dir = os.path.abspath(os.path.join(os.path.dirname(__file__),"../txt_files/"))
script_dir_OUT = os.path.abspath(os.path.join(os.path.dirname(__file__),"./LOG_FILES"))

input_filename = os.path.join(script_dir, input_filename)
results_filename = os.path.join(script_dir, results_filename)

log_filename= os.path.join(script_dir_OUT, log_filename)


#open and check input file
try:
	input_filename = open(input_filename, 'r')
except:
	print("error: fail in opening file " + input_filename + "\n")
	sys.exit()

#open and check result file
try:
	results_file = open(results_filename, 'r')
except:
	print("error: fail in opening file " + results_filename + "\n")
	sys.exit()


# open and check log file
try:
	log_file = open(log_filename, 'w')
except:
	print("error: fail in opening file " + log_filename + "\n")
	sys.exit()


file_line = 0

error=0
error_buffer=0
tot_error=0
tot_error_buffer=0

first_line=0
stream=0

list_input_0000=[]
list_out_VHDL=[]
cnt=0


for line in input_filename:

    str1 = line.replace("\n","")

    if (str1=="."):
        a=''.join(list_input_0000)
        print("The data in input is:")
        print(a)
        print("\n")
        SHA3_PY_result=SHA3_function(''.join(list_input_0000))

        SHA3_VHDL_result_UPPER=results_file.readline()
        SHA3_VHDL_result = SHA3_VHDL_result_UPPER.lower()

        while SHA3_VHDL_result_UPPER!="-\n":
            list_out_VHDL.append(SHA3_VHDL_result_UPPER[0:16])
            SHA3_VHDL_result_UPPER=results_file.readline()
            SHA3_VHDL_result = SHA3_VHDL_result_UPPER.lower()
        
        SHA3_VHDL_result=''.join(list_out_VHDL)
        SHA3_VHDL_result= SHA3_VHDL_result.lower()
            

        err=compare_results(SHA3_PY_result, SHA3_VHDL_result)
        if(err==0):
            log_file.write("[INPUT: " + format(file_line) + "] = "+ SHA3_PY_result +"\n")
            log_file.write("-\n")
        else:
            tot_error=tot_error+1
            log_file.write("[INPUT: " + format(file_line) + "] : error found.\n\t- expected: "+ SHA3_PY_result +"\n\t- obtained: " + SHA3_VHDL_result + "\n")
            log_file.write("-\n")
        
    elif (str1=="-" ):
        str=str1
    else:
        
        if SHA3_MODE=="10":
            if stream==4:
                str1=str1[0:4]
                list_input_0000.append(str1)
            else:
                list_input_0000.append(str1)
        elif SHA3_MODE=="11":
            if SHA3_OP=="00":
                if stream==4:
                    str1=str1[0:2]
                    list_input_0000.append(str1)
                else:
                    list_input_0000.append(str1) 
            else:
                list_input_0000.append(str1)           
        else:
            list_input_0000.append(str1)  
        stream = stream +1

    file_line=file_line+1


#----------------------------------CLOSE FILES-----------------------------------------------------------------------
input_filename.close()
results_file.close()
log_file.close()

#-----------------------------------------------------------THE END-----------------------------------------------------		
print("\nThere are " + format(tot_error) + " errors in SHA3 permutation evoluation!\n")	
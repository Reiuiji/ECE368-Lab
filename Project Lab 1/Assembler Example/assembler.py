#!/usr/bin/python
#
# This application will output assembled coded for the UMD 16 bit RISC achitecture
#
# Version: 1.1
#
# Last Updated : March 3, 2015
#
# ECE 368 UMD RISC Project
# (c) Daniel Noyes, MIT License
#

import os, sys, string
import fileinput
import re #regex
import argparse

rows, columns = os.popen('stty size', 'r').read().split() #grab the console size

#input Parser
parser = argparse.ArgumentParser(description='output the assemled code(HEX) for the UMD 24 bit RISC arch')
parser.add_argument("-f", "--file", dest='file', help="input file")
parser.add_argument("-v", "--verbose", action="store_true", dest="verbose", default=False, help="shows building it")
parser.add_argument("-b", "--binary", action="store_true", dest="binary", default=False, help="Output Binary Equivalent")
parser.add_argument("-c", "--coe", action="store_true", dest="coe", default=False, help="Output Coe File")
args = parser.parse_args()

#OPERATION TYPES: based on the instruction modes
RR_TYPE = ['ADD','SUB','AND','OR','MOV']
I_TYPE   = ['ADDI','ANDI','SL','SR','LW','SW','JAL','RTL']
D_TYPE  = ['LWV','SWV','LWVI','LWVD','LWVS','NOP','SWED','SWEI']
B_TYPE= ['BRA']

#ID Set Types
ID_TYPE={
		'LWV':0,'SWV':0,   #ID 00
		'LWVD':1,'SWED':1, #ID 01
		'LWVI':2,'SWEI':2, #ID 10
		'LWVS':3,'NOP':3   #ID 11
		}

#instruction OPCODES
OPCODES={
		"ADD":0, "SUB":1, "AND":2, "OR":3, "MOV":4, "ADDI":5,
		"ANDI":6, "SL":7, "SR":8, "LW":9, "SW":10, "LWV":11,
		"SWV":12, "JAL":13, "RTL":14, "BRA":15,
		#Special Instructions
		"LWVI":11, "LWVD":11, "LWVS":11, "NOP":12, "SWED":12, "SWEI":12
		}
#CPU REGISTERS
REGISTERS={
		"R0":0,"R1":1,"R2":2,"R3":3,"R4":4,"R5":5,"R6":6,"R7":7,"R8":8,
		"R9":9,"R10":10,"R11":11,"R12":12,"R13":13,"R14":14,"R15":15
		}
#SHADOW REGISTERS
SHADOW_REG={
		"S0":0,"S1":1,"S2":2,"S3":3
		}


def Remove_Comments(INPUT_LINES,debug):
	print('Removing Comments Started')
	TRIMED_LINES = []
	#Remove all comments in the code
	for Line in INPUT_LINES:
		if len(Line) > 0:
			s_line = Line.split()
			comment = False
			Line_No_Comment = ''
			for String in s_line:

				if len(String) > 0:
					if String[0] == ';':
						comment = True

					if comment == False:
						if Line_No_Comment == '':
							Line_No_Comment = String
						else:
							Line_No_Comment = Line_No_Comment + '\t' + String

			if Line_No_Comment != '': #nothing in the line so skip
				TRIMED_LINES.append(Line_No_Comment)

	INPUT_LINES =('\n'.join(TRIMED_LINES))

	if debug == True:
		print(" Removed Comments ".center(int(columns), '*'))
		print(INPUT_LINES)
		print(" !Removed Comments! ".center(int(columns), '*'))

	print('Removing Comments Complete')
	return (INPUT_LINES)
#!Remove_Comments

#Build_Labels
def Build_Labels(INPUT,debug):
	if debug == True:
		print('Processing Labels')

	INPUT_LINES = INPUT.split('\n')

	LINE_POS = 0
	TRIMED_LINES = []
	LABELS = {}
	#GRAB ALL TAGS in the code
	for Line in INPUT_LINES:
		if len(Line) > 0:
			s_line = Line.split()
			if len(s_line) > 0:
				opcode = s_line[0]
				#Figure out if 1st segment is a opcode of a mem tag
				if not opcode in RR_TYPE+I_TYPE+D_TYPE+B_TYPE:
					if not opcode in LABELS:
						LABELS[opcode] = LINE_POS
						Line = ' '.join(s_line[1:])
						Line ='\t'+Line
					else:
						print('CAUTION: Duplicate Labels (',opcode,') in Line ',LINE_POS,'!')
				if Line != '\t':
					TRIMED_LINES.append(Line)
				LINE_POS+=1

	INPUT_LINES =('\n'.join(TRIMED_LINES))

	if debug == True:
		print(" Process Labels ".center(int(columns), '*'))
		if not LABELS:
			print('No Labels in code')
		else:
			print('Labels:')
			print(LABELS)
		print(" !Process Labels! ".center(int(columns), '*'))
		print(" Label Removed Code ".center(int(columns), '*'))
		print(INPUT_LINES)
		print(" !Label Removed Code! ".center(int(columns), '*'))

	print('Processing Labels Complete')
	return (INPUT_LINES, LABELS)
#!Build_Labels

#Assembler : build each operation based on the instruction type
def Assembler(INPUT,LABELS,Binary):

	OUTPUT=''
	INPUT_LINES=INPUT.split('\n')

	for Line in INPUT_LINES:
		#remove the comma in the code, dont need it anymore
		Line = re.sub(',','',Line)
		args=Line.split('\t')
		opcode = args[0]

		#RR Type
		if opcode in RR_TYPE:
			RA = args[1]
			RB = args[2]
			OPDATA = (OPCODES[opcode]<<12| REGISTERS[RA]<<8| REGISTERS[RB]<<4)
			if Binary == True:
				OUTPUT+= "{0:b}".format(OPDATA) + '\n'
			else:
				OUTPUT+= '%04X' % OPDATA + '\n'

		#I Type
		if opcode in I_TYPE:
			RA = args[1]
			IMMED = args[2]
			if IMMED[0] == '$':
				IMMED = int(IMMED[1:], 16);
			else:
				IMMED = int(IMMED, 16);
			OPDATA = (OPCODES[opcode]<<12| REGISTERS[RA]<<8 | int(IMMED))
			if Binary == True:
				OUTPUT+= "{0:b}".format(OPDATA) + '\n'
			else:
				OUTPUT+= '%04X' % OPDATA + '\n'

		#D Type
		if opcode in D_TYPE:
			RA = args[1]
			RS = args[2]
			IMMED = args[3]
			ID = ID_TYPE[opcode]
			OPDATA = (OPCODES[opcode]<<12 | REGISTERS[RA]<<8 | SHADOW_REG[RS]<<6 | ID << 4 | int(IMMED))
			if Binary == True:
				OUTPUT+= "{0:b}".format(OPDATA) + '\n'
			else:
				OUTPUT+= '%04X' % OPDATA + '\n'

		#B Type
		if opcode in B_TYPE:
			MASK = args[1]
			IMMED = args[2]
			OPDATA = (OPCODES[opcode]<<12 | REGISTERS[RA]<<8 | REGISTERS[RB])
			if Binary == True:
				OUTPUT+= "{0:b}".format(OPDATA) + '\n'
			else:
				OUTPUT+= '%04X' % OPDATA + '\n'



	return(OUTPUT)
#!Assembler


#	PARSE THE INPUT
def Parse_input(file,debug):
	print('Opening file',file)
	if not os.path.isfile(file):
		print('File does not exist')
		parser.print_help()
		sys.exit(2)
	else:
		f = open(file, 'r')
		INPUT = f.read()
		f.close()
		INPUT = INPUT.upper()

	#Display Input file
	if debug == True:
		print(" {0} ".format(file.upper()).center(int(columns), '*'))
		print(INPUT)
		print(" !{0} ".format(file.upper()).center(int(columns), '*'))

	#Remove trailing space(\n,\t,\s,\r)
	while INPUT[-1]=='\n' or INPUT[-1]=='\t' or INPUT[-1]=='\s' or INPUT[-1]=='\r':
		INPUT=INPUT[:-1]

	#Split the input file into each line
	INPUT_LINES = INPUT.split('\n')
	if debug == True:
		print('Parsed file',file,'into', len(INPUT_LINES), 'lines.')

	#Removing the comments
	INPUT_LINES = Remove_Comments(INPUT_LINES,debug)

	#Build Labels
	LABELS = {}
	(INPUT_LINES,LABELS) = Build_Labels(INPUT_LINES,debug)

	#Finished Parsing the file
	return (INPUT_LINES, LABELS)

#init
def main () :
	if not args.file:
		print('\n*[ERROR] : no input file*\n')
		parser.print_help()
		sys.exit(2)

	#Force COE to be hex
	if args.coe == True:
		args.binary == False

	print("Processing Stage 1")
	(INPUT, LABELS) = Parse_input(args.file,args.verbose)
	print('Stage 1 Complete')

	print("Processing Stage 2")
	OUTPUT = Assembler(INPUT,LABELS,args.binary)
	print('Stage 2 Complete')

	print("Process Complete\n\n")
	if args.verbose == True:
		if args.binary == True:
			print("Binary OUTPUT:")
			print("[OP][RA][RB]            : RR [0,1,2,3,4]")
			print("[OP][RA][   IMMED 8   ]:  I [5,6,7,8,9,A,D,E]")
			print("[OP][RA]RSID[ IMMED 4 ]:  D [B,C]")
			print("[OP][MS][   IMMED 8   ]:  B [F]")
			print(OUTPUT)
			print("NOTES:\nOP : opcode\nRA : Register A\nRB : Register B\nIMMED : Immediate value\nRS : Shadow Register\nID : Special Instruction")
		else:
			print("Hexadecimal OUTPUT:")
			print("OAB   : RR [0,1,2,3,4]")
			print("OA[IM]:  I [5,6,7,8,9,A,D,E]")
			print("OAS[I]:  D [B,C]")
			print("OM[IM]:  B [F]")
			print(OUTPUT)
			print("NOTES:\nO : opcode\nA : Register A\nB : Register B\nI/IM : Immediate value\nS : Shadow Register + Special Instruction")
	elif args.coe == True:
		print("\n\nCoe Format File:\n")
		COE = "memory_initialization_radix=16;\nmemory_initialization_vector=\n"
		LINES=OUTPUT.split('\n')
		for O in LINES:
			COE+="{0},\n".format(O)
		COE = COE[:-4] + ";"
		print(COE)
	#return OUTPUT
	else:
		print(OUTPUT)


if __name__ == "__main__" :
	main ()

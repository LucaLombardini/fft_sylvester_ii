#! /env/python

###############################################################################
#   Global definitions and imports
import math
SOURCE = "../src/fft_unit.vhd"
N_SAMPLES = 16

###############################################################################
# can be useful, i believe that

def reverse_kogge_stone(a,b):
    generate = a & b
    propagate = a ^ b
    max_iter = math.ceil( math.log2( max(a,b) ) ) / 2
    k = 1
    while k <= max_iter:
        generate |= (generate >> k) & propagate
        propagate &= (propagate >> k)
        k *= 2
    return (a ^ b ^ (generate >> 1))

###############################################################################
#   Basic functions used to manipulate instances

def newInstName(level, group, inst, num):   # creates a string for a new name
    return "lv{}_gr{}_{}{}".format(level, group, inst, num)

def slotMap(port):                          # can map both generic and port maps
    return ", ".join(port)

def newBitSig(name, sigtype):
    return "\tSIGNAL {} : {};".format(name, sigtype)

def newNumSig(name, sigtype, up_limit):
    return "\tSIGNAL {} : {}({}-1 DOWNTO 0);".format(name,sigtype, up_limit)

def newButterfly(inst_name, port_map):
    return "\t{} : butterfly PORT MAP ({});".format(inst_name, port_map)

def newMux(inst_name, gen_map, port_map):
    return "\t{} : mux2to1 GENERIC MAP({}) PORT MAP({});".format(inst_name, gen_map, port_map)

def newConnection(dest, source):
    return "\t{} <= {};".format(dest,source)

def newSeparator(text): 
    return "--" + "#"*77 + "\n" + "--#\t{}".format(text)

###############################################################################
#   Class simulating the content of the file

class vhdl_file():
    def __init__(self):
        self.head = []
        self.foot = ["END ARCHITECTURE;"]
        self.list_of_sigs = []
        self.list_of_inst = []

    def addHeader(self, string):
        self.head += [string]

    def addFooter(self, element):
        self.foot = self.foot[:-1] + [element] + self.foot[-1]

    def addSignal(self, element):
        self.list_of_sigs += [element]
    
    def addInstance(self, element):
        self.list_of_inst += [element]

    def __str__(self):
        assembled = "\n".join(self.head) + "\n"
        assembled += "\n".join(self.list_of_sigs) + "\n"
        assembled += "BEGIN\n"
        assembled += "\n".join(self.list_of_inst) + "\n"
        assembled += self.footer
        return assembled
###############################################################################
#   iterate inside the fft_unit.vhd to change the instantiation part

outputFile = vhdl_file()

coef_real = [524287, 484379, 370728, 200636, 0, 847940, 677848, 564197]
coef_imag = [0, 847940, 677848, 564197, 524288, 564197, 677848, 847940]

FROM_DATA_IN = "DATA_IN(io_width*data_ports*(butt_per_level-{0})-1 DOWNTO io_width*data_ports*(butt_per_level-{0}-1))"
FROM_COEF_IN = "COEFF_IN(io_width*(coef_ports-{0})-1 DOWNTO io_width*(coef_ports-{0}-1))"
FROM_DATA_MXD=
FROM_COEF_BUF= "w_pipe_{0}(io_width*(coef_ports-{1}) DOWNTO io_width*(coef_ports-{1}-1))"

with open(SOURCE,"r") as filein:
    for linein in filein:
        if "SIGNAL" not in linein:  
            outputFile.addHeader(linein.rstrip("\n"))
        else: # start creating new defs
            break
    # butterfly inst
    stage = 0
    max_subgroups = 1
    while max_subgroups != N_SAMPLES:
        sublimit = N_SAMPLES / (max_subgroups*2)
        w_index = 0
        for group in range(max_subgroups)
            for i in range(sublimit):
                a_index = 2 * sublimit * group + 1
                b_index = reverse_kogge_stone(a_index, sublimit)
                newButtName = newInstName(stage, group, "but", i) ##DO BUTTERFLY
                startBit = "START" if stage == 0 else "doneAggr{}".format(stage-1)
                dataIn = FROM_DATA_IN.format(i) if stage == 0 else 
                coefIn = FROM_COEF_IN.format(w_index) if stage == 0 else FROM_COEF_BUF.format(w_index)
                doneBit = ""
                dataOut = ""
                newButtPort = slotMap(["CLK", "RST_n", startBit, dataIn, coefIn, doneBit, dataOut])
                ## PUT A MUX @ OUT
                ## PUT REGISTERS?
                ## DO SIGNAL ASSIGNMENT
            w_index = reverse_kogge_stone(w_index, N_SAMPLE/4)
        max_subgroups *= 2
        stage += 1

## RENAME!!!
with open("tmp","w") as fileout:
    fileout.write(outputFile)

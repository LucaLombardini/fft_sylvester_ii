#! /env/python

###############################################################################
#   Global definitions and imports
import math
import os
SOURCE = "../src/fft_unit.vhd"
N_SAMPLES = 16
n_coef = 8

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

ordinal = lambda n: "%d%s" % (n,"tsnrhtdd"[(n//10%10!=1)*(n%10<4)*n%10::4])

###############################################################################
#   Basic functions used to manipulate instances

def newInstName(level, group, inst, num):   # creates a string for a new name
    return "lv{}_gr{}_{}{}".format(level, group, inst, num)

def makeMap(port):                          # can map both generic and port maps
    return ", ".join(port)

def newBitSig(name, sigtype):
    return "\tSIGNAL {} : {};".format(name, sigtype)

def newNumSig(name, sigtype, up_limit):
    return "\tSIGNAL {} : {}({}-1 DOWNTO 0);".format(name, sigtype, up_limit)

def newButterfly(inst_name, port_map):
    return "\t{} : butterfly PORT MAP ({});".format(inst_name, port_map)

def newPipe(inst_name, port_map):
    return "\t{} : pipe_machine PORT MAP({});".format(inst_name, port_map)

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
        assembled += "\n".join(self.foot)
        return assembled
###############################################################################
#   iterate inside the fft_unit.vhd to change the instantiation part

outputFile = vhdl_file()

#coef_real = [524287, 484379, 370728, 200636, 0, 847940, 677848, 564197]
#coef_imag = [0, 847940, 677848, 564197, 524288, 564197, 677848, 847940]

FROM_DATA_IN = "DATA_IN(io_width*{0}-1 DOWNTO io_width*{1})"
FROM_COEF_IN = "COEF_IN(io_width*{0}-1 DOWNTO io_width*{1})"
FROM_BETWEEN = "lv{}_out{}"
DONE_BETWEEN = "lv{}_gr{}_done{}"
DONE_AGGR = "doneAggr{}"
PIPE_MACHINE = "pipe{}"
FROM_COEF_BUF= "w_pipe{0}(io_width*{1}-1 DOWNTO io_width*{2})"
COEF_USED = "lev{0}_w{1}"
TO_DATA_OUT = "DATA_OUT(io_width*{0}-1 DOWNTO io_width*{1})"

with open(SOURCE,"r") as filein:
    for linein in filein:
        if "SIGNAL" not in linein and "BEGIN" not in linein:
            outputFile.addHeader(linein.rstrip("\n"))
        else: # start creating new defs
            break
    # butterfly inst
    stage = 0
    max_subgroups = 1
    while max_subgroups != N_SAMPLES:
        outputFile.addInstance(newSeparator(ordinal(stage+1) + " Layer"))
        sublimit = N_SAMPLES // (max_subgroups*2)
        w_index = 0
        doneList = []
        assList = [] ## store temporaneo delle assegnazioni, fatte al fondo di
        for group in range(max_subgroups):
            for i in range(sublimit):
                a_index = 2 * sublimit * group + i
                b_index = reverse_kogge_stone(a_index, sublimit)
                if stage == 0:          # first stage is different, direct input
                    startBit = "START"  # and reverse ordered data
                    _index = N_SAMPLES-a_index
                    portAIn = FROM_DATA_IN.format(_index, _index-1)
                    dataInA = "lv0_in{}".format(a_index) 
                    _index = N_SAMPLES - b_index
                    portBIn = FROM_DATA_IN.format(_index, _index-1)
                    dataInB = "lv0_in{}".format(b_index)
                    _index = n_coef - w_index
                    coefFrom = FROM_COEF_IN.format(_index, _index-1)
                    assList += [newConnection(dataInA, portAIn)]
                    assList += [newConnection(dataInB, portBIn)]
                    outputFile.addSignal(newNumSig(dataInA,"signed","io_width"))
                    outputFile.addSignal(newNumSig(dataInB,"signed","io_width"))
                else:           # the others take inputs from the prev. stage
                    startBit = DONE_AGGR.format(stage-1)
                    dataInA = FROM_BETWEEN.format(stage - 1, a_index)
                    dataInB = FROM_BETWEEN.format(stage - 1, b_index)
                    _index = n_coef - w_index
                    coefFrom = FROM_COEF_BUF.format(stage - 1, _index, _index-1)
                coefIn = COEF_USED.format(stage,w_index)
                # new output signals
                dataOutA = FROM_BETWEEN.format(stage, a_index)
                dataOutB = FROM_BETWEEN.format(stage, b_index)
                doneBit = DONE_BETWEEN.format(stage,group,i)
                doneList += [doneBit]
                ## new butterfly
                newButtName = newInstName(stage, group, "but", i)
                newButtPort = makeMap(["CLK", "RST_n", startBit, dataInA, dataInB, coefIn, doneBit, dataOutA, dataOutB])
                _butterfly = newButterfly(newButtName, newButtPort)
                # add declarations and connections to vhdl file
                outputFile.addSignal(newNumSig(dataOutA,"signed","io_width"))
                outputFile.addSignal(newNumSig(dataOutB,"signed","io_width"))
                outputFile.addSignal(newBitSig(doneBit,"std_logic"))
                outputFile.addInstance(_butterfly)
                #outputFile.addSignal(newBitSig(startBit,"std_logic"))
            ## coefIn da portare fuori, al gruppo, non qui @ butterfly
            outputFile.addSignal(newNumSig(coefIn,"signed","io_width"))
            assList += [newConnection(coefIn, coefFrom)]
            w_index = reverse_kogge_stone(w_index, N_SAMPLES//4)
        max_subgroups *= 2
        if stage != (math.log2(N_SAMPLES)-1): ## last stage doesnt need pipe
            next_start = DONE_AGGR.format(stage)
            outputFile.addSignal(newBitSig(next_start,"std_logic"))
            ## add a new pipe_machine for W propagation
            ## pipemachine prende aggregated done, non il singolo
            pipeIn = "COEF_IN" if stage == 0 else "w_pipe{}".format(stage-1)
            pipeOut = "w_pipe{}".format(stage)
            outputFile.addSignal(newNumSig(pipeOut,"signed","io_width*n_coef"))
            newPipeName = PIPE_MACHINE.format(stage)
            #newPipeGeneric = makeMap(["io_width*n_coef"])
            newPipePort = makeMap(["CLK", "RST_n", startBit, DONE_AGGR.format(stage), pipeIn, pipeOut])
            _pipemachine = newPipe(newPipeName,newPipePort)
            #_pipemachine = newPipe(newPipeName,newPipeGeneric,newPipePort)
            outputFile.addInstance(_pipemachine)
        else: ## last stage has output reorder
            next_start = "DONE"
        for _ in assList:
            outputFile.addInstance(_)
        outputFile.addInstance(newConnection(next_start,' AND '.join(doneList)))
        stage += 1

# reorder
outputFile.addInstance(newSeparator("Output reorder"))
a_index = 0
for i in range(N_SAMPLES):
    _outPtr = N_SAMPLES - i
    outputFile.addInstance(newConnection(TO_DATA_OUT.format(_outPtr,_outPtr-1),"lv{}_out{}".format(stage-1,a_index)))
    a_index = reverse_kogge_stone(a_index, N_SAMPLES//2)

## RENAME!!!
with open("tmp","w") as fileout:
    fileout.write(outputFile.__str__())

os.rename("tmp",SOURCE)

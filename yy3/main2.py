import os
import math
import random

M_FILE_NAME = "kk.m" # using matlab to cal R^2 (running m file: kk.m)

Data_File = "test1.csv"
row = 7
fb = float(0.16)
kb = 5
#l = 0.0022


def generate_m_file(filename,D,l,tb):
    f = open(filename,'w')
    f.write("sec('"+Data_File+"',"+str(row)+","+str(fb)+","+str(kb)+","+str(tb)+","+str(D)+"*10^-12*24*3600"+","+str(l)+");")
    f.write("exit")
    f.close()



def get_RR(Data):
    l = float(float(Data[0])/10000)
    D = float(float(Data[1])/100)
    tb = float(Data[2])
    print l,D,tb
    PATH_TO_MATLAB = "/home/quake0day/matlab/bin/matlab"
    generate_m_file(M_FILE_NAME,D,l,tb)
    NAME = M_FILE_NAME.split('.')[0]
    msg = os.system(PATH_TO_MATLAB + " -nodisplay -r "+NAME+" > dump")
    # using sed editor to extract R^2
    msg = os.system("sed -n '14p' dump > dump1")
    f =open('dump1','r') 
    # RR = R^2
    RR = f.read()
    print RR

    return 1-float(RR)




def hillclimb(domain,costf):
    # create a random D
    sol = [random.randint(domain[i][0],domain[i][1])
            for i in range(len(domain))]

    # main loop
    while 1:

        #create the sol neighbors list
        neighbors=[]
        for j in range(len(domain)):

            #in each direction, change a little
            if sol[j] > domain[j][0]:
                neighbors.append(sol[0:j]+[sol[j]-1]+sol[j+1:])
            if sol[j] < domain[j][1]:
                neighbors.append(sol[0:j]+[sol[j]+1]+sol[j+1:])

        # find the optmial sol
        current = costf(sol)
        best = current
        for j in range(len(neighbors)):
            cost = costf(neighbors[j])
            if cost < best:
                best = cost
                sol = neighbors[j]
        if best == current:
			break
    return sol
domain = [(20,21),(100,400),(25,29)]
best_sol = hillclimb(domain,get_RR)
print "best_sol="+str(best_sol)
#generate_m_file(M_FILE_NAME,12)

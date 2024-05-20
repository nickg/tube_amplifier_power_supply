from PyQSPICE import clsQSPICE as pqs

import pandas as pd
import matplotlib as mpl
import matplotlib.pyplot as plt

#make this file root for relative paths
import os
path_to_this_file = os.path.dirname(os.path.realpath(__file__))

#change directory to the lc filter directory
pqs.chdir(path_to_this_file)

fig1, (axT, axB) = plt.subplots(2,1,sharex=True,constrained_layout=True)

run_heater_llc = pqs('heater_llc.qsch')
run_heater_llc.qsch2cir()
run_heater_llc.cir2qraw()
run_heater_llc.setNline(4999)

heater_llc_results = run_heater_llc.LoadQRAW(["V(vdc)", "I(L1)", "V(iload)"])
heater_llc_results.plot(ax=axT, x="Time",  y="V(vdc)", label="controlled vout")
heater_llc_results.plot(ax=axB, x="Time",  y="V(iload)", label="load current")

plt.show()
plt.close('all')

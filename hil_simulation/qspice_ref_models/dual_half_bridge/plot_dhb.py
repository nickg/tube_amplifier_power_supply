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

run_dhb = pqs('dual_half_bridge.qsch')
run_dhb.qsch2cir()
run_dhb.cir2qraw()
run_dhb.setNline(4999)

dhb_results = run_dhb.LoadQRAW(["V(vdc)", "I(L1)", "V(iload)"])
dhb_results.plot(ax=axT, x="Time",  y="V(vdc)", label="controlled vout")
dhb_results.plot(ax=axB, x="Time",  y="V(iload)", label="load current")

plt.show()
plt.close('all')

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

# run_closed_loop = pqs('boost_closed_loop.qsch')
# run_closed_loop.qsch2cir()
# run_closed_loop.cir2qraw()
# run_closed_loop.setNline(4999)

# closed_loop_results = run_closed_loop.LoadQRAW(["V(vdc)", "I(L1)", "V(sampled_current)"])
# closed_loop_results.plot(ax=axT, x="Time",  y="V(vdc)", label="controlled vout")
# closed_loop_results.plot(ax=axB, x="Time",  y="V(sampled_current)", label="controlled iin")

run_voltage_closed_loop = pqs('boost_voltage_closed_loop.qsch')
run_voltage_closed_loop.qsch2cir()
run_voltage_closed_loop.cir2qraw()
run_voltage_closed_loop.setNline(4999)

voltage_closed_loop_results = run_voltage_closed_loop.LoadQRAW(["V(vdc)", "I(L1)", "V(sampled_current)"])
voltage_closed_loop_results.plot(ax=axT, x="Time",  y="V(vdc)", label="controlled vout")
voltage_closed_loop_results.plot(ax=axB, x="Time",  y="V(sampled_current)", label="controlled iin")

# run_open_loop = pqs('boost_open_loop.qsch')
# run_open_loop.qsch2cir()
# run_open_loop.cir2qraw()
# run_open_loop.setNline(4999)

# open_loop_results = run_open_loop.LoadQRAW(["V(vdc)", "I(L1)", "V(sampled_current)"])
# open_loop_results.plot(ax=axT, x="Time",  y="V(vdc)", label="open vout")
# open_loop_results.plot(ax=axB, x="Time",  y="V(sampled_current)", label="open iin")



plt.show()
plt.close('all')

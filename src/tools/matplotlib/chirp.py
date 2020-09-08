import os
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import numpy as np
import urllib.request
import matplotlib.patches as patches
import matplotlib.transforms as transforms

# print message after packages imported successfully
print("import of packages successful")

def cm2inch(*tupl):
    inch = 2.54
    if isinstance(tupl[0], tuple):
        return tuple(i/inch for i in tupl[0])
    else:
        return tuple(i/inch for i in tupl)

os.chdir("E:/model_hc/src/tools/matplotlib/")
os.getcwd()

data_t = np.loadtxt(fname = "E:/model_hc/src/tools/matplotlib/chirp_0_20.txt")

t = data_t[:,0]

fig = plt.figure(figsize=cm2inch(18.4,8))
ax = fig.gca()
l = ax.plot(t*1e6, data_t[:,1])[0]
plt.xlabel('t [$\mu$s]')
plt.ylabel('$\Psi_A$ [V]')
plt.xticks(np.arange(0,2500,500))
plt.yticks(np.arange(-1,1.5,0.5))

plt.subplots_adjust(left=0.12, right=0.90,bottom=0.15, top=0.90, hspace=0.20, wspace=0.20)

# plt.savefig("E:/model_hc/reports/figures/eps/chirp_0_20.eps", format="eps")
plt.show()

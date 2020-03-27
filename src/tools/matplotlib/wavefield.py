import os
import matplotlib.pyplot as plt
from matplotlib.gridspec import GridSpec
import matplotlib.patches as patches
import matplotlib.transforms as transforms
#from mpl_toolkits.mplot3d import Axes3D  # noqa: F401 unused import
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
import numpy as np
import urllib.request


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
data_t = np.loadtxt(fname = "E:/model_hc/src/tools/matplotlib/Vz_i.txt")


x = data_t[:,0]
x_size = np.size(np.unique(x))
y = data_t[:,1]
y_size = np.size(np.unique(y))
x = np.reshape(x,(y_size,x_size))
y = np.reshape(y,(y_size,x_size))
z = data_t[:,2]
z = np.reshape(z,(y_size,x_size))



fig = plt.figure(figsize=cm2inch(18.4,12))
ax = fig.gca()
plt.pcolor(x*1e3, y*1e3, z, cmap='RdBu', vmin = 0, vmax = 2.5e-3)
plt.xlabel('x [mm]')
plt.ylabel('y [mm]')
ax.annotate('actuator', xy=(-85, 0), xytext=(-200, -50),
             arrowprops=dict(facecolor='black', shrink=1),
             )
ax.annotate('sensor', xy=(85, 0), xytext=(150, -50),
             arrowprops=dict(facecolor='black', shrink=1),
             )
ax.annotate('wave reflection\n in the cell', xy=(-55, 52), xytext=(-200, 95),
             arrowprops=dict(facecolor='black', shrink=1),
             )
#circ = patches.Circle((0, 0), 57, transform=ax.transData,
#facecolor='grey', alpha=0.25)
#ax.add_patch(circ)

ax.annotate('damage area', xy=(25, 15), xytext=(76, 95),
             arrowprops=dict(facecolor='black', shrink=1),
             )
#fig_1.legend(labels=damage,
#            loc=7,
#            title='damage size')

#plt.subplots_adjust(bottom=0.12, right=0.80, top=0.95, hspace=0.30, wspace=0.30)

plt.savefig("E:/model_hc/reports/figures/eps/wavefield.eps", format="eps")
plt.show()

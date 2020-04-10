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

data_fft = np.loadtxt(fname = "E:/model_hc/src/tools/matplotlib/mgntPhiFFT.txt")
f = data_fft[:,0]
frequency = (f==16.5e3)
maxValueFFT = np.amax(data_fft[frequency,1])


x_d = np.arange(0,140,20)
xp = np.linspace(x_d[0],x_d[-1],100)
fig = plt.figure(figsize=cm2inch(18.4,8))
ax = fig.gca()
y = np.array(data_fft[frequency,1:]/maxValueFFT)
y = y.flatten()
w = [5, 5, 1, 1, 1, 1, 5]
p = np.polyfit(x_d,y,4,w=w)
yp = np.poly1d(p)

l1 = ax.plot(x_d,y,'rx')[0]
l2 = ax.plot(xp,yp(xp),'b')[0]
plt.xlabel('d [mm]')
plt.ylabel('I [-]')

plt.subplots_adjust(left=0.10, bottom=0.15, right=0.90, top=0.95, wspace=0.23, hspace=0.30)
plt.savefig("E:/model_hc/reports/figures/eps/madif.eps", format="eps")
plt.show()

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
bandwidth_1 = (f>=5.5e3) & (f<=7.5e3)
bandwidth_2 = (f>=15.0e3) & (f<=17.0e3)
maxValueFFT = np.amax(data_fft[:,1])

damage = ['0', '20', '40', '60', '80', '100', '120']

fig_1 = plt.figure(figsize=cm2inch(18.4,12))
gs=GridSpec(2,2) # 2 rows, 2 columns

ax1 = fig_1.add_subplot(gs[0,:])
ax2 = fig_1.add_subplot(gs[1,0])
ax3 = fig_1.add_subplot(gs[1,1])


l1 = ax1.plot(f*1e-3,data_fft[:,1:]/maxValueFFT)[0]
ax1.set_xlabel('f [kHz]')
ax1.set_ylabel('$\Psi_S$ [-]')
ax1.text(0.02, 0.95, 'a)', transform=ax1.transAxes,
fontsize=12, fontweight='bold', va='top')
ax1.set_xticks(np.arange(0,21,2.5))
ax1.set_xlim(0, 20)

trans = transforms.blended_transform_factory(
ax1.transData, ax1.transAxes)

rect_1 = patches.Rectangle((5.5,0), width=2, height=1,
transform=trans, color='grey',
alpha=0.25)
ax1.add_patch(rect_1)

rect_2 = patches.Rectangle((15.0,0), width=2, height=1,
transform=trans, color='grey',
alpha=0.25)
ax1.add_patch(rect_2)

ax1.annotate('bandwidth $\#1$', xy=(6, 0.7), xytext=(0.5, 0.5),
             arrowprops=dict(facecolor='black', shrink=0.01),
             )
ax1.annotate('bandwidth $\#2$', xy=(16, 0.86), xytext=(8.5, 0.7),
             arrowprops=dict(facecolor='black', shrink=0.01),
             )
def plot_bar(l,x,range_x,y,range_y,ax,width,a):
    x_ticks = np.arange(len(x[range_x]))
    l = ax.bar(x_ticks + a*width, y[range_x,range_y], width)[0]


y = data_fft[:,1:]/maxValueFFT
a = np.arange(-len(damage)/2+0.5,len(damage)/2+0.5)
for count, l in zip(np.arange(np.size(data_fft[:,1:],1)), ['l21', 'l22', 'l23', 'l24', 'l25','l26','l27']):
    plot_bar(l,f,bandwidth_1,y,count,ax2,0.1,a[count])

labels = f[bandwidth_1]*1e-3;
ax2.get_xaxis().set_tick_params(direction='out')
ax2.xaxis.set_ticks_position('bottom')
ax2.set_xticks(np.arange(len(f[bandwidth_1])))
ax2.set_xticklabels(labels)
ax2.set_xlim(0-1, len(labels))
ax2.set_xlabel('f [kHz]')
ax2.set_ylabel('$\Psi_S$ [-]')

ax2.text(0.05, 0.95, 'b)', transform=ax2.transAxes,
fontsize=12, fontweight='bold', va='top')

for count, l in zip(np.arange(np.size(data_fft[:,1:],1)), ['l31', 'l32', 'l33', 'l34', 'l35', 'l36', 'l37']):
    plot_bar(l,f,bandwidth_2,y,count,ax3,0.1,a[count])

labels = f[bandwidth_2]*1e-3;
ax3.get_xaxis().set_tick_params(direction='out')
ax3.xaxis.set_ticks_position('bottom')
ax3.set_xticks(np.arange(len(f[bandwidth_2])))
ax3.set_xticklabels(labels)
ax3.set_xlim(0-1, len(labels))
ax3.set_xlabel('f [kHz]')
ax3.set_ylabel('$\Psi_S$ [-]')

ax3.text(0.05, 0.95, 'c)', transform=ax3.transAxes,
fontsize=12, fontweight='bold', va='top')
title_pl = 'średnica wady'
title_en = 'd [mm]'
fig_1.legend(labels=damage,
            loc=7,
            title=title_en)

plt.subplots_adjust(left=0.10, bottom=0.10, right=0.90, top=1.00, wspace=0.23, hspace=0.30)
plt.savefig("E:/model_hc/reports/figures/eps/mgntPhiFFT.eps", format="eps")
plt.show()

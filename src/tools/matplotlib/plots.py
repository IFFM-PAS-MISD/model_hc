import os
import matplotlib.pyplot as plt
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

os.chdir("E:/model_hc/reports/figures/matplotlib/")
os.getcwd()

data_fft = np.loadtxt(fname = "E:/model_hc/reports/figures/matplotlib/mgntPhiFFT.txt")
data_t = np.loadtxt(fname = "E:/model_hc/reports/figures/matplotlib/mgntPhi.txt")
f = data_fft[:,0]
t = data_t[:,0]
maxValueFFT = np.amax(data_fft[:,1])
maxValue = np.amax(data_t[:,1])

damage = ['0 mm', '5 mm', '10 mm', '15 mm', '20 mm', '25 mm', '30 mm']

fig_1 = plt.figure(figsize=cm2inch(18.4,12))

ax1 = fig_1.add_subplot(221)
ax2 = fig_1.add_subplot(222)
ax3 = fig_1.add_subplot(223)
ax4 = fig_1.add_subplot(224)
#ax3 = fig_1.add_subplot(123)


l1 = ax1.plot(t*1e6, data_t[:,1:]/maxValue)[0]
ax1.set_xlabel('t [$\mu$s]')
ax1.set_ylabel('V [-]')
ax1.text(0.05, 0.95, 'a)', transform=ax1.transAxes,
fontsize=12, fontweight='bold', va='top')

l2 = ax2.plot(f*1e-3,data_fft[:,1:]/maxValueFFT)[0]
ax2.set_xlabel('f [kHz]')
ax2.set_ylabel('V [-]')
ax2.text(0.05, 0.95, 'b)', transform=ax2.transAxes,
fontsize=12, fontweight='bold', va='top')
ax2.set_xticks(np.arange(0,21,5))

l3 = ax1.plot(t*1e6, data_t[:,1:]/maxValue)[0]
ax3.set_xlabel('t [$\mu$s]')
ax3.set_ylabel('V [-]')
ax3.text(0.05, 0.95, 'c)', transform=ax3.transAxes,
fontsize=12, fontweight='bold', va='top')

l4 = ax2.plot(f*1e-3,data_fft[:,1:]/maxValueFFT)[0]
ax4.set_xlabel('f [kHz]')
ax4.set_ylabel('V [-]')
ax4.text(0.05, 0.95, 'd)', transform=ax4.transAxes,
fontsize=12, fontweight='bold', va='top')
ax4.set_xticks(np.arange(0,21,5))

trans = transforms.blended_transform_factory(
ax2.transData, ax2.transAxes)

rect_1 = patches.Rectangle((15,0), width=3, height=1,
transform=trans, color='yellow',
alpha=0.5)
ax2.add_patch(rect_1)

rect_2 = patches.Rectangle((5,0), width=3, height=1,
transform=trans, color='yellow',
alpha=0.5)
ax2.add_patch(rect_2)



#b1 = ax3.bar(f*1e-3,data_fft[:,1]/maxValueFFT)
#ax3.set_xlabel('f [kHz]')
#ax3.set_ylabel('V [-]')
#ax3.set_title('c)')
#ax3.set_xticks(np.arange(0,21,5))

#plt.yticks(np.arange(0, 81, 10))
fig_1.legend(labels=damage,
            loc=7,
            title='damage size')

plt.subplots_adjust(bottom=0.12, right=0.80, top=0.95, hspace=0.30, wspace=0.30)
#plt.show()
plt.savefig("E:/model_hc/reports/figures/eps/time_fft.eps", format="eps")

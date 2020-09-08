import matplotlib.pyplot as plt
import numpy as np
import math

# print message after packages imported successfully
print("import of packages successful")


def cm2inch(*tupl):
    inch = 2.54
    if isinstance(tupl[0], tuple):
        return tuple(i/inch for i in tupl[0])
    else:
        return tuple(i/inch for i in tupl)


data_num_474 = np.loadtxt(fname="E:/model_hc/data/processed/num/Cg_474.txt")
data_num_475 = np.loadtxt(fname="E:/model_hc/data/processed/num/Cg_475.txt")
# data_exp = np.loadtxt(fname="E:/model_hc/data/processed/exp/voltage_exp_464.txt")
theta = data_num_474[:,0]

fig,axs = plt.subplots(1,2, subplot_kw=dict(polar=True), figsize=cm2inch(18.4,10))
axs[0].plot(theta, data_num_474[:,1],'ro',theta, data_num_475[:,1],'bs')
axs[0].text(0.30, 1.25, 'A0 mode', transform=axs[0].transAxes,
fontsize=12, fontweight='bold', va='top')
axs[0].set_rmax(1000)
axs[0].set_yticks([500, 800, 1000])
axs[1].plot(theta, data_num_474[:,2],'ro',theta, data_num_475[:,2],'bs')
axs[1].text(0.3, 1.25, 'S0 mode', transform=axs[1].transAxes,
fontsize=12, fontweight='bold', va='top')
axs[1].set_rmax(1000)
axs[1].set_yticks([4000, 6000, 8000])
plt.sca(axs[1])
line_labels = ['Present model', 'Homogenised']
plt.legend(labels=line_labels, bbox_to_anchor=(-0.3, -0.5, 0.5, 0.5))

plt.subplots_adjust(left=0.15, bottom=0.05, right=0.90, top=0.95, wspace=0.25, hspace=0.40)
plt.savefig("E:/model_hc/reports/figures/eps/cg.eps", format="eps")
plt.show()

import matplotlib.pyplot as plt
import numpy as np
# print message after packages imported successfully
print("import of packages successful")


def cm2inch(*tupl):
    inch = 2.54
    if isinstance(tupl[0], tuple):
        return tuple(i/inch for i in tupl[0])
    else:
        return tuple(i/inch for i in tupl)


velocity = np.empty([512, 1])
for i in [474, 475]:
    velocity = np.hstack((velocity,np.loadtxt(fname=f"E:/model_hc/data/processed/num/Vxy_r0_th0_{i}.txt")))
    velocity = np.hstack((velocity,np.loadtxt(fname=f"E:/model_hc/data/processed/num/Vz_r0_th0_{i}.txt")))
    velocity = np.hstack((velocity, np.loadtxt(fname=f"E:/model_hc/data/processed/num/Vxy_r200_th0_{i}.txt")))
    velocity = np.hstack((velocity, np.loadtxt(fname=f"E:/model_hc/data/processed/num/Vz_r200_th0_{i}.txt")))

velocity = velocity*1e3

fig, axs = plt.subplots(2, 2, figsize=cm2inch(18.4,12))
l1 = axs[0,0].plot(velocity[:,1]*1e3, velocity[:,2], 'r', linewidth=2)
l2 = axs[0,0].plot(velocity[:,9]*1e3, velocity[:,10], 'b--', linewidth=2)
l3 = axs[0,1].plot(velocity[:,5]*1e3, velocity[:,6], 'r', linewidth=2)
l4 = axs[0,1].plot(velocity[:,13]*1e3, velocity[:,14], 'b--', linewidth=2)
l5 = axs[1,0].plot(velocity[:,3]*1e3, velocity[:,4], 'r', linewidth=2)
l6 = axs[1,0].plot(velocity[:,11]*1e3, velocity[:,12], 'b--', linewidth=2)
l7 = axs[1,1].plot(velocity[:,7]*1e3, velocity[:,8], 'r', linewidth=2)
l8 = axs[1,1].plot(velocity[:,15]*1e3, velocity[:,16], 'b--', linewidth=2)

plt.sca(axs[0,0])
plt.xticks(np.arange(0,750,350))
plt.ylabel('$V_{xy}$ [mm/s]')
axs[0,0].text(0.05, 0.9, 'a)', transform=axs[0,0].transAxes,
fontsize=12, fontweight='bold', va='top')
plt.sca(axs[1,0])
plt.xticks(np.arange(0,750,350))
plt.xlabel('t [$\mu$s]')
plt.ylabel('$V_z$ [mm/s]')
axs[1,0].text(0.05, 0.9, 'b)', transform=axs[1,0].transAxes,
fontsize=12, fontweight='bold', va='top')
plt.sca(axs[0,1])
plt.xticks(np.arange(0,750,350))
axs[0,1].text(0.05, 0.9, 'c)', transform=axs[0,1].transAxes,
fontsize=12, fontweight='bold', va='top')
axs[0,1].annotate('S0 mode', xy=(150, 0.1), xytext=(500, 0.1), color='black',
             arrowprops=dict(facecolor='black', shrink=5),
             )
axs[1,1].annotate('reflections\nfrom the cells', xy=(690, 0.1), xytext=(-7, -0.3), color='black',
             arrowprops=dict(facecolor='black', shrink=5),
             )
plt.sca(axs[1,1])
plt.xticks(np.arange(0,750,350))
plt.xlabel('t [$\mu$s]')
line_labels = ['Present model', 'Homogenised']
plt.legend(labels=line_labels, bbox_to_anchor=(-0.25, 0.7, 0.5, 0.5))
axs[1,1].text(0.05, 0.9, 'd)', transform=axs[1,1].transAxes,
fontsize=12, fontweight='bold', va='top')
axs[1,1].annotate('A0 mode', xy=(350, 0.3), xytext=(20, 0.1), color='black',
             arrowprops=dict(facecolor='black', shrink=5),
             )

plt.subplots_adjust(left=0.15, bottom=0.10, right=0.90, top=0.95, wspace=0.2, hspace=0.30)
plt.savefig("E:/model_hc/reports/figures/eps/velocity.eps", format="eps")
plt.show()
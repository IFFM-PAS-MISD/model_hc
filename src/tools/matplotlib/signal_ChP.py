import os
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


os.chdir("E:/model_hc/src/tools/matplotlib/")
os.getcwd()

chirp = np.loadtxt(fname="E:/model_hc/data/processed/num/chirp_0_20.txt")
pulse = np.loadtxt(fname="E:/model_hc/data/processed/num/pulse20.txt")

t1 = chirp[:, 0]
t2 = pulse[:, 0]
y1 = chirp[:, 1]
y2 = pulse[:, 1]

fig, (ax1, ax2) = plt.subplots(2, 1, figsize=cm2inch(18.4, 16))

l1 = ax1.plot(t1*1e6, y1, linewidth=2)[0]
l2 = ax2.plot(t2*1e6, y2, linewidth=2)[0]
ax1.set_xlabel(r't [$\mu$s]')
ax1.set_ylabel(r'$\Psi_A$ [V]')
ax2.set_xlabel(r't [$\mu$s]')
ax2.set_ylabel(r'$\Psi_A$ [V]')

ax1.text(0.05, 0.95, 'a)', transform=ax1.transAxes,
fontsize=12, fontweight='bold', va='top')
ax2.text(0.05, 0.95, 'b)', transform=ax2.transAxes,
fontsize=12, fontweight='bold', va='top')
plt.subplots_adjust(left=0.12, right=0.90, bottom=0.10, top=0.95, hspace=0.25, wspace=0.20)

plt.savefig("E:/model_hc/reports/figures/eps/signal.eps", format="eps")
plt.show()

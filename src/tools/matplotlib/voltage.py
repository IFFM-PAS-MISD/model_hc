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


data_num_474 = np.loadtxt(fname="E:/model_hc/data/processed/num/voltage_num_474.txt")
data_num_475 = np.loadtxt(fname="E:/model_hc/data/processed/num/voltage_num_475.txt")

t_num = data_num_474[:, 0]

fig = plt.figure(figsize=cm2inch(18.4,8))
ax = fig.gca()
l1 = ax.plot(t_num*1e6, data_num_474[:,1], 'r',linewidth=2)[0]
l2 = ax.plot(t_num*1e6, data_num_475[:,1], 'b--',linewidth=2)[0]
plt.xlabel('t [$\mu$s]')
plt.ylabel('$\Psi_A$ [V]')
plt.xticks(np.arange(0,750,350))
#plt.yticks(np.arange(-0.06,0.07,0.03))

line_labels = ['Present model', 'Homogenised']
fig.legend(handles=[l1, l2], labels=line_labels, bbox_to_anchor=(0.4, 0.45, 0.5, 0.5))
# ax_2.setp(l_2[1:], linewidth=1)
# plt.setp(lines[2], linewidth=1)

# plt.xlabel('t [$\mu$s]')
# plt.ylabel('$\Phi$ [V]')
# labs = ['experimental', 'full', 'homogenized']
# legend = ax.legend(labels=labs,
#                   loc='upper right')
plt.subplots_adjust(left=0.15, bottom=0.15, right=0.90, top=0.95, wspace=0.2, hspace=0.40)
plt.savefig("E:/model_hc/reports/figures/eps/voltage.eps", format="eps")
plt.show()

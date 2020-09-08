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


def rshclm(col, mat, size_x, size_y):
    return np.reshape(mat[:, col], (size_y, size_x))


i = 475
data_475 = np.loadtxt(fname=f"E:/model_hc/data/processed/num/V_{i}.txt")
i = 474
data_474 = np.loadtxt(fname=f"E:/model_hc/data/processed/num/V_{i}.txt")
print("files loaded successful")
x_475_size = np.size(np.unique(data_475[:, 0]))
y_475_size = np.size(np.unique(data_475[:, 1]))
x_475 = rshclm(0, data_475, x_475_size, y_475_size)
y_475 = rshclm(1, data_475, x_475_size, y_475_size)

x_474_size = np.size(np.unique(data_474[:, 0]))
y_474_size = np.size(np.unique(data_474[:, 1]))
x_474 = rshclm(0, data_474, x_474_size, y_474_size)
y_474 = rshclm(1, data_474, x_474_size, y_474_size)

fig, axs = plt.subplots(3, 2, figsize=cm2inch(18.4, 18.4))
v_max = 1.0e-5
c_map = 'plasma'
images = [axs[0, 0].pcolor(x_475 * 1e3, y_475 * 1e3, rshclm(2, data_475, x_475_size, y_475_size), cmap=c_map, vmin=0,
                           vmax=v_max),
          axs[0, 1].pcolor(x_474 * 1e3, y_474 * 1e3, rshclm(2, data_474, x_474_size, y_474_size), cmap=c_map, vmin=0,
                           vmax=v_max),
          axs[1, 0].pcolor(x_475 * 1e3, y_475 * 1e3, rshclm(3, data_475, x_475_size, y_475_size), cmap=c_map, vmin=0,
                           vmax=v_max),
          axs[1, 1].pcolor(x_474 * 1e3, y_474 * 1e3, rshclm(3, data_474, x_474_size, y_474_size), cmap=c_map, vmin=0,
                           vmax=v_max),
          axs[2, 0].pcolor(x_475 * 1e3, y_475 * 1e3, rshclm(4, data_475, x_475_size, y_475_size), cmap=c_map, vmin=0,
                           vmax=v_max),
          axs[2, 1].pcolor(x_474 * 1e3, y_474 * 1e3, rshclm(4, data_474, x_474_size, y_474_size), cmap=c_map, vmin=0,
                           vmax=v_max)]

for i in range(2):
    for j in range(3):
        axs[j,i].set_xticks([-200, 0, 200])
        axs[j,i].set_yticks([-100, 0, 100])

fig.colorbar(images[0], ax=axs, orientation='horizontal', fraction=0.05, ticks=(0, v_max), format='%.0e')

axs[0,0].set_title('Homogenised')
axs[0,1].set_title('Present model')
axs[0,0].set_ylabel(r't = 105$\mu$s')
axs[1,0].set_ylabel(r't = 130$\mu$s')
axs[2,0].set_ylabel(r't = 160$\mu$s')

axs[0,0].annotate('actuator', xy=(-85, 0), xytext=(50, -100), color='white',
             arrowprops=dict(facecolor='white', shrink=1),
             )
axs[0,1].annotate('sensor', xy=(85, 0), xytext=(100, 90), color='white',
             arrowprops=dict(facecolor='white', shrink=1),
             )
axs[1,1].annotate('wave reflections\n within the cells', xy=(50, 110), xytext=(0, -90),color='white',
             arrowprops=dict(facecolor='white', shrink=1),
             )
plt.subplots_adjust(bottom=0.19, right=0.95, top=0.95, hspace=0.20, wspace=0.20)
plt.savefig("E:/model_hc/reports/figures/eps/wavefield_1.eps", format="eps")
plt.show()

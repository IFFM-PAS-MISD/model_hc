function [Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,Jacob_P22inv] = ...
    Jacob_inv_2D(Jacob_P11,Jacob_P12,Jacob_P21,Jacob_P22)

det_J = round((Jacob_P11.*Jacob_P22-Jacob_P12.*Jacob_P21)*1e8)*1e-8;
Jacob_P11inv = round(1./det_J.*Jacob_P22*1e8)*1e-8;
Jacob_P12inv = -round(1./det_J.*Jacob_P12*1e8)*1e-8;
Jacob_P21inv = -round(1./det_J.*Jacob_P21*1e8)*1e-8;
Jacob_P22inv = round(1./det_J.*Jacob_P11*1e8)*1e-8;
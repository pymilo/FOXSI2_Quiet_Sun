PRO foxsi2_nontherm_limit
; You need to run: foxsi,2014

default, Ecutoff, 5

energy_range = [5, 15]
energy_dim = 50
energy_arr = findgen(energy_dim) * (energy_range[1] - energy_range[0])/energy_dim + energy_range[0]
energy_edges = get_edges(energy_arr, /edges_2)
energy_means = get_edges(energy_arr, /mean)

eff_area = get_foxsi_effarea(energy_arr=energy_means)

A_range = [1, 10]
A_dim = 2
A = findgen(A_dim) * (A_range[1] - A_range[0])/A_dim + A_range[0]

gam_range = [2, 4]
gam_dim = 3
gam = findgen(gam_dim) * (gam_range[1] - gam_range[0])/gam_dim + gam_range[0]

photon_flux_array = fltarr(A_dim, gam_dim)

FOR i = 0, A_dim-1 DO BEGIN
    FOR j = 0, gam_dim-1 DO BEGIN
        params = [A[i], gam[j], Ecutoff]
        photon_flux_array[i,j] = nontherm_e(params)
    endfor
endfor

stop

END

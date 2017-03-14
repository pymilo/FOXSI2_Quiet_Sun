PRO foxsi2_nontherm_limit
; You need to run: foxsi,2014

default, Ecutoff, 5
levels = 12
cgLoadCT, 33, NColors=12, Bottom=3

energy_range = [5, 15]
energy_dim = 50
energy_arr = findgen(energy_dim) * (energy_range[1] - energy_range[0])/energy_dim + energy_range[0]
energy_edges = get_edges(energy_arr, /edges_2)
energy_means = get_edges(energy_arr, /mean)

eff_area = get_foxsi_effarea(energy_arr=energy_means)

A_range = [10, 1e8]
A_dim = 50
A = findgen(A_dim) * (A_range[1] - A_range[0])/A_dim + A_range[0]

gam_range = [2, 7]
gam_dim = 50
gam = findgen(gam_dim) * (gam_range[1] - gam_range[0])/gam_dim + gam_range[0]

photon_flux_array = fltarr(A_dim, gam_dim)

FOR i = 0, A_dim-1 DO BEGIN
    FOR j = 0, gam_dim-1 DO BEGIN
        params = [A[i], gam[j], energy_means]
        photon_flux_array[i,j] = nontherm_e(params)
    endfor
endfor

Contour, photon_flux_array, gam, A,/Fill, xtitle='Gamma', ytitle='A', C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
       NLevels=levels, Color=cgColor('black')
Contour, photon_flux_array, gam, A, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
Contour, photon_flux_array, gam, A, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('grey'), thick = 2, /fill
Contour, photon_flux_array, gam, A, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('black'), thick = 2
Contour, photon_flux_array, gam, A, /Overplot, levels=[0.01, 0.1,1,10,100], /Follow, Color=cgColor('black'), thick = 2


stop

END

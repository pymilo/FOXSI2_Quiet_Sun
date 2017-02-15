PRO foxsi2_emandt_limit, count_rate_limit = count_rate_limit

;must run foxsi,2014 before running this

integration_time = 50

default, count_rate_limit, 4.6
default, angular_size, 10
; Set up the data and colors for a filled contour plot.
levels = 12
cgLoadCT, 33, NColors=12, Bottom=3

energy_range = [5, 15]
energy_dim = 50
energy_arr = findgen(energy_dim) * (energy_range[1] - energy_range[0])/energy_dim + energy_range[0]
energy_edges = get_edges(energy_arr, /edges_2)
energy_means = get_edges(energy_arr, /mean)

eff_area = get_foxsi_effarea(energy_arr=energy_means)

log_em_range = [38, 50]
log_em_dim = 50
log_em = findgen(log_em_dim) * (log_em_range[1] - log_em_range[0])/log_em_dim + log_em_range[0]

t_range = [5, 20]
;t_range = [3, 18]
t_dim = 20
t = findgen(t_dim) * (t_range[1] - t_range[0])/t_dim + t_range[0]

flux_array = fltarr(log_em_dim, t_dim)
thermal_energy = flux_array

FOR i = 0, log_em_dim-1 DO BEGIN
    FOR j = 0, t_dim-1 DO BEGIN
        params = [(10d ^ log_em[i]) * 1d-49, t[j] / 11.6, 1]
        thermal_spectrum = f_vth(energy_edges, params) * eff_area.eff_area_cm2
        flux_array[i, j] = int_tabulated(energy_means, thermal_spectrum) * integration_time
        thermal_energy[i,j] = therm_e([params[0:1], angular_size])
    endfor
endfor

photon_fluxes_dim = 20
photon_fluxes_ranges = [-7, 1]
log_photon_fluxes = findgen(photon_fluxes_dim) * (photon_fluxes_ranges[1] - photon_fluxes_ranges[0])/photon_fluxes_dim + photon_fluxes_ranges[0]
photon_fluxes = 10d^log_photon_fluxes
cts_array = log_photon_fluxes

FOR i = 0, n_elements(log_photon_fluxes)-1 DO BEGIN
    spec = replicate(photon_fluxes[i], n_elements(energy_means)) * eff_area.eff_area_cm2
    cts_array[i] = int_tabulated(energy_means, spec) * integration_time
ENDFOR

save, flux_array, log_em, t, thermal_energy, cts_array, photon_fluxes, filename = 'foxsi2_thermal_limit_flux.dat'

Contour, flux_array, log_em, t, /Fill, xtitle='Log(Emission Measure [cm!U-3!N])', ytitle='Temperature [MK]', C_Colors=Indgen(levels)+3, Background=cgColor('white'), $
       NLevels=levels, Color=cgColor('black')
Contour, flux_array, log_em, t, /Overplot, NLevels=levels, /Follow, Color=cgColor('black')
Contour, flux_array, log_em, t, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('grey'), thick = 2, /fill
Contour, flux_array, log_em, t, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('black'), thick = 2
Contour, flux_array, log_em, t, /Overplot, levels=[0.01, 0.1,1,10,100], /Follow, Color=cgColor('black'), thick = 2

stop

m = minmax(alog10(thermal_energy))
levels = findgen(ceil(m[1]) - floor(m[0])) + floor(m[0])
Contour, alog10(thermal_energy), log_em, t, levels=levels, /Follow, Color=cgColor('black'), /fill, Background=cgColor('white'), $
    xtitle='Log(Emission Measure [cm!U-3!N])', ytitle='Temperature [MK]', title="Thermal Energy [erg]"
Contour, flux_array, log_em, t, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('grey'), thick = 2, /fill
Contour, flux_array, log_em, t, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('black'), thick = 2
Contour, alog10(thermal_energy), log_em, t, levels=levels, /overplot, /Follow, Color=cgColor('black')
Contour, flux_array, log_em, t, /Overplot, levels=[count_rate_limit], /Follow, Color=cgColor('black'), thick = 2

stop

END

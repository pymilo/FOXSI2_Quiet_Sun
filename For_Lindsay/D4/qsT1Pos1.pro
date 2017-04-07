;; You need to install and run the FOXSIScienceSoft 
;; in your SSWIDL shell.
;; charge the FOXSI 2014 flight: $ foxsi,2014

loadct, 2
reverse_ct

;; Select and Plot a FOXSI Target
trange=[t1_pos1_start,t1_pos1_end]
m4 = foxsi_image_map( data_lvl2_d4, cen1_pos1, erange=[5.,10.], trange=trange, thr_n=4., /xycorr )
plot_map, m4, /limb, lcol=255, col=255, charsi=1.2, title=m4.id
draw_fov,det=4,target=1,shift=CEN1_POS1-CEN1_POS2

;; Select circular area of interest
area_center = [50.,-250.]
area_radius = [200.]
data = area_cut( data_lvl2_d4, area_center, area_radius, /xycorr)
data = time_cut( data, trange[0], trange[1], energy=[5.,10.] )
m = foxsi_image_map(data, cen1_pos1, erange=[5.,10.], trange=trange, thr_n=4., /xycorr )
plot_map, m, /limb, lcol=255, col=255, charsi=1.2, title=m4.id
draw_fov,det=4,target=1,shift=CEN1_POS1-CEN1_POS2
tvcircle,area_radius,area_center[0],area_center[1],/data

datat = time_cut( data_lvl2_d4, trange[0], trange[1], energy=[5.,10.] )
n_all = n_elements( datat )
n_good = n_elements( datat[ where( datat.error_flag eq 0 ) ] )
good_fraction = double(n_good) / n_all
print, 'Good Fraction = ',good_fraction
print, 'Counts = ', n_elements( data[ where( data.error_flag eq 0 ) ] )


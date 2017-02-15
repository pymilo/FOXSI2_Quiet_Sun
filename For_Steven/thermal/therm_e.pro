FUNCTION therm_e, params
; Goal : Gives thermal energy in ergs
;	INPUT: 3 elements Array
; 		params(0) = Emission Measure (in 10^49 cm^2)
;		params(1) = Temperature (in keV)
;		params(2) = Angular Size (in arcsec)

	default, f, 1d ; filling factor
	default, kb, 1.38064852d-16 ; Boltzmann const in erg K^-1

	EM =  double(params(0)) * 1d49 ; convertion to cm^2
	T = double(params(1)) * 1.16452d * 1d7 ; Convertion factor from keV to K
	V = (double(params(2)) * 7.25d7)^(3d) ; cm^3

	Uth = 3d * kb * T * sqrt(EM * f * V)
	;print, Uth
	RETURN, Uth
END

; First value should be 4.0757281e+23
;V = (ang_size * 7.25d7)^3 ; cm^3 if ang_size in arcsec
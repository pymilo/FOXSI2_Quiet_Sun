FUNCTION nontherm_e, params
; Goal : Gives non-thermal energy in erg/s
;	INPUT: 3 elements Array
; 		params(0) = A (dimensions)
;		params(1) = gamma (dimensions)
;		params(2) = Ec (dimensions) break energy

	A = params(0)
	gamm = params(1)
	Ec = params(2)

	I = A*Ec^(-gamm)

RETURN, I	

END
	SUBROUTINE GET_RAD_DECAY_ENERGY(E_RAD_DECAY,ND)
	USE NUC_ISO_MOD
	IMPLICIT NONE
!
	INTEGER ND
	REAL*8 E_RAD_DECAY(ND)
!
	E_RAD_DECAY(1:ND)=RADIOACTIVE_DECAY_ENERGY(1:ND)
!
	RETURN
	END

	SUBROUTINE SET_DC_LTE(XzVLTE,DXzV,EDGE,NXzV,T,TMIN,ND)
	IMPLICIT NONE
!
	INTEGER NXzV
	INTEGER ND
	REAL*8 XzVLTE(NXzV,ND)
	REAL*8 DXzV(ND)
	REAL*8 T(ND)
	REAL*8 EDGE(NXzV)
	REAL*8 TMIN
!
! Constants for opacity etc. These are set in CMFGEN.
!
        COMMON/CONSTANTS/ CHIBF,CHIFF,HDKT,TWOHCSQ
        REAL*8 CHIBF,CHIFF,HDKT,TWOHCSQ
	INTEGER I,J
!
	DO I=1,ND
	  DXzV(I)=1.0D0
	  IF(T(I) .GT. TMIN)THEN
	    XzVLTE(:,I)=1.0D0
	  ELSE
	    DO J=1,NXzV
	      XzVLTE(J,I)=EXP(HDKT*EDGE(J)*(1.0D0/TMIN-1.0D0/T(I)))
	    END DO
	  END IF
	END DO
!
	RETURN
	END

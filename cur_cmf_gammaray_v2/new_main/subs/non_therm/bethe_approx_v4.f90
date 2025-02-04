	SUBROUTINE BETHE_APPROX_V4(Q,NL,NUP,XKT,dXKT,NKT,ID,DPTH_INDX)
	USE MOD_CMFGEN
	IMPLICIT NONE
!
! Altered 10-Feb-2012: Improved computation of gbar. Expression now works for
!                        very low energies, andhigh energies.
!
	INTEGER ID
	INTEGER DPTH_INDX
	INTEGER NKT
	INTEGER NL,NUP
	REAL*8 Q(NKT)
	REAL*8 XKT(NKT)
	REAL*8 dXKT(NKT)
!
	LOGICAL FAST_METHOD
!
	REAL*8, PARAMETER :: PI=3.141592653589793238462643D0
	REAL*8, PARAMETER :: A0 = 0.529189379D-8    		!Bohr radius in cm
	REAL*8, PARAMETER :: Hz_TO_EV=4.1356691D0
	REAL*8, PARAMETER :: COL_CONST=13.6D0*8.0D0*PI*PI*A0*A0/1.732D0
	REAL*8, PARAMETER :: COEF0=-0.0745397d0
	REAL*8, PARAMETER :: COEF1=0.232715d0
	REAL*8, PARAMETER :: COEF2=-0.00647558d0
	REAL*8, PARAMETER :: CONNECT_POINT=1.2212243D0
!
	REAL*8 GBAR
	REAL*8 X
	REAL*8 T1,T2
	REAL*8 dE
	REAL*8 dE_eV
!
	INTEGER IKT
!
	Q(:)=0.0D0
	dE=ATM(ID)%EDGEXzV_F(NL)-ATM(ID)%EDGEXzV_F(NUP)
	IF(dE .LE. 0)RETURN
	dE_eV=Hz_to_eV*dE
!	T2=3.28978D0/dE
!       3.28978 ~ 13.6/Hz_to_eV
!
	IF(ATM(ID)%AXzV_F(NUP,NL) .GT. 1.0D+03 .OR. ATM(ID)%NT_OMEGA(NL,NUP) .EQ. 0.0D0)THEN
	  T1=3.28978D0*COL_CONST*ATM(ID)%AXzV_F(NL,NUP)*ATM(ID)%XzV_F(NL,DPTH_INDX)/dE*ATM(ID)%CROSEC_NTFAC
	  DO IKT=1,NKT
	    GBAR=0.0D0
	    IF(XKT(IKT) .GE. dE_eV)THEN
	      X = sqrt(xkt(ikt)/dE_eV-1.0d0)
	      IF(( NINT(ATM(ID)%ZXzV) .NE. 1) .AND. (X .LE. CONNECT_POINT))THEN
	        GBAR = 0.2D0
	      ELSE IF(X .LE. 0.80D0)THEN
	        GBAR = 0.074*X*(1.0D0+X)
	      ELSE IF(X .LE. 6)THEN
	        GBAR = COEF0 + COEF1*X + COEF2*X*X
	      ELSE
	        GBAR = +0.105D0+LOG(X)/1.8138D0
	      END IF
	      IF(GBAR .GE. 0.0d0)THEN
	        Q(IKT)=T1*GBAR*dXKT(IKT)/XKT(IKT)
	      ENDIF
	    END IF
	  END DO
	ELSE IF(ATM(ID)%NT_OMEGA(NL,NUP) .NE. 0.0D0)THEN
	  T1=PI*A0*A0*13.6d0
	  T1=T1*ATM(ID)%NT_OMEGA(NL,NUP)/ATM(ID)%GXzV_F(NL)*ATM(ID)%XzV_F(NL,DPTH_INDX)
	  DO IKT=1,NKT
	    IF(XKT(IKT) .GE. dE_eV)THEN
	      Q(IKT)=T1*dXKT(IKT)/XKT(IKT)
	    END IF
	  END DO
	ELSE
!
	END IF
!
	RETURN
	END      

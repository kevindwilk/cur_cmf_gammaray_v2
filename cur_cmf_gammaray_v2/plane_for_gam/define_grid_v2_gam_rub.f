!
      SUBROUTINE DEFINE_GRID_V2_GAM(R_EXT,V_EXT,VDOP_VEC,VDOP_FRAC,ND_EXT,R,P,ND,NC,NP)
      USE MOD_SPACE_GRID_V2
      USE GAM_MU_MOD
      IMPLICIT NONE
!
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
!
! Determine radial grid from given input parameters
! Written   11-94 DLM
! Altered 2/21/96 DLM Updated to F90 standard
! Altered 6/12/97 DLM Changed name from rpz.f
! Altered 26/Nov/98 DJH: Changed to V2
!                        Altered to allow an extended R_GRID (R_EXT).
!--------------------------------------------------------------------
!
! Grid size variables: passed from calling routine
!
      INTEGER NP
      INTEGER ND
      INTEGER NC
!
      INTEGER ND_EXT
      REAL*8 R_EXT(ND_EXT)
      REAL*8 V_EXT(ND_EXT)
      REAL*8 VDOP_VEC(ND_EXT)
      REAL*8 VDOP_FRAC
!
! Grid variables
!
      REAL*8 R(ND)
      REAL*8 V(ND)
      REAL*8 P(NP)
!
! Local variables
!
      REAL*8 MU(NP)
      REAL*8 TEMP_VEC(NP)
!
      INTEGER ID,IP
      INTEGER I,J
      INTEGER NRAY
      INTEGER IOS
      INTEGER LUER, ERROR_LU
      LOGICAL NEW_GRID
      EXTERNAL ERROR_LU
!
	INTEGER KEVIN
	INTEGER DI
!=======================================================================
!	V_EXT=0.0D0
!
! If necessary, calculate characteristic rays for moving atmospheres
!
!------------------------------------------------------------------------
!
      LUER=ERROR_LU()
      IF(ALLOCATED(R_EXT_SAV) .AND. ND_EXT .EQ. ND_EXT_SAV)THEN
	NEW_GRID=.FALSE.
	DO I=1,ND_EXT
	  IF(R_EXT(I) .NE. R_EXT_SAV(I))THEN
	    NEW_GRID=.TRUE.
	    EXIT
	  END IF
	END DO
      ELSE 
	NEW_GRID=.TRUE.
      END IF
!
      IF(NEW_GRID)THEN
        WRITE(LUER,*)'   Calculating characteristic rays.....'
        CALL CHARACTERISTICS_V2(R_EXT,P,V_EXT,VDOP_VEC,VDOP_FRAC,ND_EXT,NC,NP)
      END IF
!--------------------------------------------------------------------
!
      IF(NEW_GRID .AND. ALLOCATED(TAU))THEN
	DEALLOCATE (TAU, DTAU)
	DO IP=1,NP
          DEALLOCATE (RAY(IP)%I_P, RAY(IP)%I_M, RAY(IP)%LNK)
          DEALLOCATE (RAY(IP)%I_P_PREV, RAY(IP)%I_M_PREV)
          DEALLOCATE (RAY(IP)%I_P_SAVE, RAY(IP)%I_M_SAVE)
	END DO
      END IF
!
      IF(NEW_GRID)THEN
        J=0
	DO IP=1,NP
          NRAY=RAY(IP)%NZ
          J=MAX(J,NRAY)
	  ALLOCATE (RAY(IP)%I_P(NRAY))
          ALLOCATE (RAY(IP)%I_M(NRAY))
	  ALLOCATE (RAY(IP)%I_P_PREV(NRAY))
          ALLOCATE (RAY(IP)%I_M_PREV(NRAY))
	  ALLOCATE (RAY(IP)%I_P_SAVE(NRAY))
          ALLOCATE (RAY(IP)%I_M_SAVE(NRAY))
          ALLOCATE (RAY(IP)%LNK(ND)); RAY(IP)%LNK(:)=0
        END DO
        ALLOCATE (TAU(J))
        ALLOCATE (DTAU(J))
      END IF
!
! Determine the links betweem the extended-fine grid and the original R grid.
!
	DO IP=1,NP
	  RAY(IP)%LNK(1:ND)=0
	  ID=1
	  DO J=1,RAY(IP)%NZ
	    IF(RAY(IP)%R_RAY(J) .EQ. R(ID))THEN
	      RAY(IP)%LNK(ID)=J
	      WRITE(160,*)IP,J,RAY(IP)%LNK(ID)
	      ID=ID+1
	    END IF
	  END DO
	END DO
!
! Check all lnks allocated
!
	DO IP=1,NP
	  DO ID=1,MIN(ND,ND-(IP-NC-1))
	    IF(RAY(IP)%LNK(ID) .EQ. 0)THEN
	      WRITE(LUER,*)'Error in DEFNE_GRID_V2'
	      WRITE(LUER,*)'LNK not defined: IP=',IP,'ID=',ID
	      STOP
	    END IF
	  END DO
	END DO
!
	IF( ALLOCATED(JQW_P) .AND. (ND .NE. ND_SAV .OR. NP .NE. NP_SAV) )THEN
          DEALLOCATE(JQW_P, HQW_P, KQW_P, NQW_P)
          DEALLOCATE(JQW_M, HQW_M, KQW_M, NQW_M)
          DEALLOCATE(I_P_GRID, I_M_GRID)
	END IF
!
	IF(.NOT. ALLOCATED(JQW_P))THEN
	  ALLOCATE (JQW_P(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (HQW_P(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (KQW_P(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (NQW_P(ND,NP),STAT=IOS)
!
          IF(IOS .EQ. 0)ALLOCATE (JQW_M(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (HQW_M(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (KQW_M(ND,NP),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (NQW_M(ND,NP),STAT=IOS)
!
          IF(IOS .EQ. 0)ALLOCATE (I_P_GRID(ND),STAT=IOS)
          IF(IOS .EQ. 0)ALLOCATE (I_M_GRID(ND),STAT=IOS)
	  IF(IOS .NE. 0)THEN
	    WRITE(LUER,*)'Error in DEFINE_GRID_V2'
	    WRITE(LUER,*)'Unable to allocate JQW_P etc'
	    WRITE(LUER,*)'Status =',IOS
	    STOP
	  END IF
	END IF
!
! Calculate J, H, K and N integration weights for mu+ and mu-
!
	DO ID=1,ND
	  J=NP+1-ID
	  DO IP=1,J
            MU(IP)=RAY(IP)%MU_P(RAY(IP)%LNK(ID))
	  END DO
	  CALL J_WEIGHT(J,MU,TEMP_VEC); JQW_P(ID,1:J)=TEMP_VEC(1:J)
	  CALL H_WEIGHT(J,MU,TEMP_VEC); HQW_P(ID,1:J)=TEMP_VEC(1:J)
	  CALL K_WEIGHT(J,MU,TEMP_VEC); KQW_P(ID,1:J)=TEMP_VEC(1:J)
	  CALL N_WEIGHT(J,MU,TEMP_VEC); NQW_P(ID,1:J)=TEMP_VEC(1:J)
	END DO
!
	DO ID=1,ND
	  J=NP+1-ID
	  DO IP=1,J
            MU(IP)=RAY(IP)%MU_M(RAY(IP)%LNK(ID))
	  END DO
	  CALL J_WEIGHT(J,MU,TEMP_VEC); JQW_M(ID,1:J)=TEMP_VEC(1:J)
	  CALL H_WEIGHT(J,MU,TEMP_VEC); HQW_M(ID,1:J)=TEMP_VEC(1:J)
	  CALL K_WEIGHT(J,MU,TEMP_VEC); KQW_M(ID,1:J)=TEMP_VEC(1:J)
	  CALL N_WEIGHT(J,MU,TEMP_VEC); NQW_M(ID,1:J)=TEMP_VEC(1:J)
	END DO
!
! Quadrature weights for mu_m are negative.  Change them to positive.
!
        DO IP=1,NP
          DO J=1,ND
            JQW_M(J,IP)=-JQW_M(J,IP)
            HQW_M(J,IP)=-HQW_M(J,IP)
            KQW_M(J,IP)=-KQW_M(J,IP)
            NQW_M(J,IP)=-NQW_M(J,IP)
          END DO
        END DO
!
        IF(NEW_GRID)THEN
          IF(ALLOCATED(R_EXT_SAV))DEALLOCATE(R_EXT_SAV)
          ALLOCATE(R_EXT_SAV(ND_EXT))
	  R_EXT_SAV(:)=R_EXT
	  ND_EXT_SAV=ND_EXT
          ND_SAV=ND
          NP_SAV=NP
	END IF
!
	WRITE(6,*)"Did this make cupcakes?"
	WRITE(6,*)"Making mu grid for Kevin"
	ALLOCATE(R_MU(ND))
	OPEN(UNIT=402,FILE='angles.dat',STATUS='UNKNOWN',ACTION='WRITE',IOSTAT=IOS)
	IF(IOS .NE. 0)STOP
	DO DI=1,ND
	  R_MU(DI)%MU_VECTOR=0.0D0
	  J=NP-DI+1
!	  WRITE(402,'(2(A4,I4))')"DI:",DI,"NC:",NC
	  DO IP=1,J
!	    WRITE(402,'(3(A4,I4),A12,I4)')"DI:",DI,"IP:",IP,"NC:",NC,"RAY(IP)%NZ",RAY(IP)%NZ
	    R_MU(DI)%MU_VECTOR(IP)=RAY(IP)%MU_P(DI)
!	    WRITE(402,*)R_MU(DI)%MU_VECTOR(IP)!,RAY(IP)%MU_P(DI)
	  END DO
!	  WRITE(402,*)"*************************"
!	  WRITE(402,*)R_MU(DI)%MU_VECTOR(1:J)
!	  WRITE(402,*)"*************************"
	  I=NP-DI+1
	  DO IP=J-1,1,-1 !this will step down since MU_M starts at -1
	    I=I+1
	    R_MU(DI)%MU_VECTOR(I)=RAY(IP)%MU_M(DI)
!	    WRITE(402,*)R_MU(DI)%MU_VECTOR(I)
	  END DO
	  R_MU(DI)%MU_PTS=2*(NP-DI+1)-1
	END DO
	WRITE(6,*)"Finished loops for mu grid for Kevin"
	OPEN(UNIT=400,FILE='anglesP.dat',STATUS='UNKNOWN',ACTION='WRITE',IOSTAT=IOS)
	IF(IOS .NE. 0)STOP
	OPEN(UNIT=401,FILE='anglesM.dat',STATUS='UNKNOWN',ACTION='WRITE',IOSTAT=IOS)
	IF(IOS .NE. 0)STOP
	DO DI=1,ND
	  I=2*(NP-DI+1)-1
	  WRITE(402,'(A4,I5)')"DI:",DI
	  WRITE(402,*)R_MU(DI)%MU_VECTOR(1:I)
	  WRITE(402,*)"********************************************"
	END DO
	CLOSE(402)
	DO J=1,NP
	WRITE(400,'(2(A5,I5))')"J=",J,"NZ=",RAY(J)%NZ
	WRITE(401,'(2(A5,I5))')"J=",J,"NZ=",RAY(J)%NZ
	WRITE(400,*) "Writing out RAY(J)%MU_P"
	WRITE(400,*)RAY(J)%MU_P
	WRITE(400,*)"***********************************"
	WRITE(401,*) "Writing out RAY(J)%MU_M"
	WRITE(401,*)RAY(J)%MU_M
	WRITE(401,*)"***********************************"
	END DO
	CLOSE(400)
	CLOSE(401)
	WRITE(6,*)"Exiting routine to make angle grid"
      RETURN
      END

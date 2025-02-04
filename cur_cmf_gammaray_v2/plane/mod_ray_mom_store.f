	MODULE MOD_RAY_MOM_STORE
	IMPLICIT NONE
!
	INTEGER ND_STORE
	REAL*8, ALLOCATABLE :: R_STORE(:)
	REAL*8, ALLOCATABLE :: RMID_STORE(:) 
	REAL*8, ALLOCATABLE :: EXT_RMID_STORE(:) 
	REAL*8, ALLOCATABLE :: JNU_STORE(:)
	REAL*8, ALLOCATABLE :: HNU_STORE(:)
	REAL*8, ALLOCATABLE :: NNU_STORE(:)
	REAL*8, ALLOCATABLE :: KNU_STORE(:)
	REAL*8, ALLOCATABLE :: GAM_REL_STORE(:)
!
! General description of radiation field at boundaries.
!
	REAL*8 JPLUS_IB,JMIN_IB
	REAL*8 HPLUS_IB,HMIN_IB
	REAL*8 KPLUS_IB,KMIN_IB
	REAL*8 NPLUS_IB,NMIN_IB
	REAL*8 JPLUS_OB,JMIN_OB
	REAL*8 HPLUS_OB,HMIN_OB
	REAL*8 KPLUS_OB,KMIN_OB
	REAL*8 NPLUS_OB,NMIN_OB
!
	REAL*8 HNU_AT_OB, NNU_AT_OB
	REAL*8 HNU_AT_IB, NNU_AT_IB
	REAL*8 HNU_AT_OB_PREV, NNU_AT_OB_PREV
	REAL*8 HNU_AT_IB_PREV, NNU_AT_IB_PREV
!
	REAL*8 HBC,HBC_PREV,HBC_SAVE
	REAL*8 NBC,NBC_PREV,NBC_SAVE
	REAL*8 IN_HBC,IN_HBC_PREV,IN_HBC_SAVE
!
	REAL*8, ALLOCATABLE :: RMID(:)
	REAL*8, ALLOCATABLE :: H_ON_J(:)
	REAL*8, ALLOCATABLE :: N_ON_J(:)
	REAL*8, ALLOCATABLE :: K_ON_J(:)
	REAL*8, ALLOCATABLE :: KMID_ON_J(:)
	REAL*8, ALLOCATABLE :: NMID_ON_J(:)
	REAL*8, ALLOCATABLE :: NMID_ON_HMID(:)
	REAL*8, ALLOCATABLE :: dlnGRSQJdlnR(:)
!
	REAL*8, ALLOCATABLE :: H_ON_J_PREV(:)
	REAL*8, ALLOCATABLE :: N_ON_J_PREV(:)
	REAL*8, ALLOCATABLE :: K_ON_J_PREV(:)
	REAL*8, ALLOCATABLE :: KMID_ON_J_PREV(:)
	REAL*8, ALLOCATABLE :: NMID_ON_J_PREV(:)
	REAL*8, ALLOCATABLE :: NMID_ON_HMID_PREV(:)
!
	REAL*8, ALLOCATABLE :: H_ON_J_SAVE(:)
	REAL*8, ALLOCATABLE :: N_ON_J_SAVE(:)
	REAL*8, ALLOCATABLE :: K_ON_J_SAVE(:)
	REAL*8, ALLOCATABLE :: KMID_ON_J_SAVE(:)
	REAL*8, ALLOCATABLE :: NMID_ON_J_SAVE(:)
	REAL*8, ALLOCATABLE :: NMID_ON_HMID_SAVE(:)
!
	LOGICAL HN_DEF_ON_NODES
!
	END MODULE MOD_RAY_MOM_STORE

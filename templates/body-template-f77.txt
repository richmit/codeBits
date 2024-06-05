PROGRAM progam_name
  IMPLICIT NONE

  ! A comment
  WRITE (*,*) "Hello, World!" ! Another comment

  CONTAINS

    !-------------------------------------------------------------------
    FUNCTION func_name(a)
      IMPLICIT NONE
      REAL, INTENT(IN) :: a
      REAL func_name
    END FUNCTION func_name
    
    !-------------------------------------------------------------------
    SUBROUTINE sub_name(a, b, c)
      IMPLICIT NONE
      REAL, INTENT(IN)    :: a
      REAL, INTENT(OUT)   :: b
      REAL, INTENT(INOUT) :: c
    END SUBROUTINE sub_name

END PROGRAM program_name

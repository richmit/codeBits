PROGRAM progamName
  IMPLICIT NONE

  ! A comment
  WRITE (*,*) "Hello, World!" ! Another comment

CONTAINS

  !---------------------------------------------------------------------------------------------------------------------------------
  FUNCTION funcName(a)
    IMPLICIT NONE
    REAL, INTENT(IN) :: a
    REAL funcName
  END FUNCTION funcName

  !---------------------------------------------------------------------------------------------------------------------------------
  SUBROUTINE subName(a, b, c)
    IMPLICIT NONE
    REAL, INTENT(IN)    :: a
    REAL, INTENT(OUT)   :: b
    REAL, INTENT(INOUT) :: c
  END SUBROUTINE subName

END PROGRAM programName

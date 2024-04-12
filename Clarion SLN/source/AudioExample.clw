   PROGRAM


StringTheory:TemplateVersion equate('3.67')
jFiles:TemplateVersion equate('3.06')
Reflection:TemplateVersion equate('1.27')
ResizeAndSplit:TemplateVersion equate('5.10')

   INCLUDE('ABERROR.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ERRORS.CLW'),ONCE
   INCLUDE('KEYCODES.CLW'),ONCE
   INCLUDE('ABFUZZY.INC'),ONCE
  include('StringTheory.Inc'),ONCE
   include('jFiles.inc'),ONCE
  include('Reflection.Inc'),ONCE
  include('ResizeAndSplit.Inc'),ONCE
    Include('dwrTrace.inc'),Once

   MAP
     MODULE('AUDIOEXAMPLE_BC.CLW')
DctInit     PROCEDURE                                      ! Initializes the dictionary definition module
DctKill     PROCEDURE                                      ! Kills the dictionary definition module
     END
!--- Application Global and Exported Procedure Definitions --------------------------------------------
     MODULE('AUDIOEXAMPLE001.CLW')
Main                   PROCEDURE   !
     END
     INCLUDE('OCX.CLW')
   END
   INCLUDE('OCXEVENT.CLW')

  include('StringTheory.Inc'),ONCE
AudioDevices         QUEUE,PRE(),NAME('AudioDevices')
DevideGUID             STRING(255),NAME('DevideGUID')
ModuleName             STRING(255),NAME('ModuleName')
Description            STRING(255),NAME('Description')
                     END
SilentRunning        BYTE(0)                               ! Set true when application is running in 'silent mode'

!region File Declaration
!endregion


FuzzyMatcher         FuzzyClass                            ! Global fuzzy matcher
GlobalErrorStatus    ErrorStatusClass,THREAD
GlobalErrors         ErrorClass                            ! Global error manager
INIMgr               INIClass                              ! Global non-volatile storage manager
GlobalRequest        BYTE(0),THREAD                        ! Set when a browse calls a form, to let it know action to perform
GlobalResponse       BYTE(0),THREAD                        ! Set to the response from the form
VCRRequest           LONG(0),THREAD                        ! Set to the request from the VCR buttons

Dictionary           CLASS,THREAD
Construct              PROCEDURE
Destruct               PROCEDURE
                     END


  CODE
  GlobalErrors.Init(GlobalErrorStatus)
  FuzzyMatcher.Init                                        ! Initilaize the browse 'fuzzy matcher'
  FuzzyMatcher.SetOption(MatchOption:NoCase, 1)            ! Configure case matching
  FuzzyMatcher.SetOption(MatchOption:WordOnly, 0)          ! Configure 'word only' matching
  INIMgr.Init('.\AudioExample.INI', NVD_INI)               ! Configure INIManager to use INI file
  DctInit()
  Main
  INIMgr.Update
  INIMgr.Kill                                              ! Destroy INI manager
  FuzzyMatcher.Kill                                        ! Destroy fuzzy matcher


Dictionary.Construct PROCEDURE

  CODE
  IF THREAD()<>1
     DctInit()
  END


Dictionary.Destruct PROCEDURE

  CODE
  DctKill()



   MEMBER('AudioExample.clw')                              ! This is a MEMBER module


   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABUTIL.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('AUDIOEXAMPLE001.INC'),ONCE        !Local module procedure declarations
MainOLEEventHandler    PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG
MainOLEPropChange      PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
MainOLEPropEdit        PROCEDURE(SIGNED OLEControlFEQ,STRING EditedProperty),LONG
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

AudioFile            CSTRING(255)                          ! 
Window               WINDOW('Audio Example'),AT(,,454,177),FONT('Segoe UI',9),RESIZE,ICON(ICON:Clarion),GRAY,MAX, |
  SYSTEM,IMM
                       BUTTON('Close'),AT(421,157),USE(?Close)
                       OLE,AT(2,51,450,103),USE(?OLE)
                       END
                       PROMPT('Audio File:'),AT(2,7,33,10),USE(?AudioFile:Prompt),TRN
                       ENTRY(@s255),AT(39,6,290,10),USE(AudioFile)
                       BUTTON('...'),AT(333,5,12,12),USE(?LookupFile)
                       LIST,AT(55,20,134,10),USE(?ListAudioDevices),DROP(10),FORMAT('1020L(2)M@s255@#3#'),FROM(AudioDevices)
                       PROMPT('Audio Devices:'),AT(2,20,49,10),USE(?AudioDevicesPrompt),TRN
                       BUTTON('Play'),AT(2,34,32,14),USE(?PlayBtn)
                       BUTTON('Stop'),AT(38,34),USE(?StopBtn)
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
! ----- csResize --------------------------------------------------------------------------
csResize             Class(csResizeClass)
    ! derived method declarations
Fetch                  PROCEDURE (STRING Sect,STRING Ent,*? Val),VIRTUAL
Update                 PROCEDURE (STRING Sect,STRING Ent,STRING Val),VIRTUAL
Init                   PROCEDURE (),VIRTUAL
                     End  ! csResize
! ----- end csResize -----------------------------------------------------------------------
FileLookup3          SelectFileClass

  CODE
  GlobalResponse = ThisWindow.Run()                        ! Opens the window and starts an Accept Loop

!---------------------------------------------------------------------------
DefineListboxStyle ROUTINE
!|
!| This routine create all the styles to be shared in this window
!| It`s called after the window open
!|
!---------------------------------------------------------------------------

ThisWindow.Init PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  GlobalErrors.SetProcedureName('Main')
  SELF.Request = GlobalRequest                             ! Store the incoming request
  ReturnValue = PARENT.Init()
  IF ReturnValue THEN RETURN ReturnValue.
  SELF.FirstField = ?Close
  SELF.VCRRequest &= VCRRequest
  SELF.Errors &= GlobalErrors                              ! Set this windows ErrorManager to the global ErrorManager
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
  Do DefineListboxStyle
    ?OLE{PROP:Create} = 'ClaAudio'  
  OCXRegisterEventProc(?OLE,MainOLEEventHandler)
  OCXRegisterPropChange(?OLE,MainOLEPropChange)
  OCXRegisterPropEdit(?OLE,MainOLEPropEdit)
  
  
  csResize.Init('Main',Window,1)
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  FileLookup3.Init
  FileLookup3.ClearOnCancel = True
  FileLookup3.Flags=BOR(FileLookup3.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup3.SetMask('Audio Files','*.wav;*.mp3')         ! Set the file mask
  csResize.Open()
  SELF.SetAlerts()
    ?OLE{'GetOutputDevices()'}  
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  GlobalErrors.SetProcedureName
  RETURN ReturnValue


ThisWindow.TakeAccepted PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receive all EVENT:Accepted's
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeAccepted()
    CASE ACCEPTED()
    OF ?LookupFile
      ThisWindow.Update()
      AudioFile = FileLookup3.Ask(1)
      DISPLAY
      ?OLE{'LoadFile(' & AudioFile & ')'}
    OF ?ListAudioDevices
      Get(AudioDevices,Choice(?ListAudioDevices)) 
      ?OLE{'SetDeviceGuid(' & Clip(AudioDevices.DevideGUID) & ')'}     
    OF ?PlayBtn
      ThisWindow.Update()
      ?OLE{'Play()'}    
    OF ?StopBtn
      ThisWindow.Update()
      ?OLE{'Stop()'}         
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  csResize.TakeEvent()
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!----------------------------------------------------
csResize.Fetch   PROCEDURE (STRING Sect,STRING Ent,*? Val)
  CODE
  INIMgr.Fetch(Sect,Ent,Val)
  PARENT.Fetch (Sect,Ent,Val)
!----------------------------------------------------
csResize.Update   PROCEDURE (STRING Sect,STRING Ent,STRING Val)
  CODE
  INIMgr.Update(Sect,Ent,Val)
  PARENT.Update (Sect,Ent,Val)
!----------------------------------------------------
csResize.Init   PROCEDURE ()
  CODE
  PARENT.Init ()
  Self.CornerStyle = Ras:CornerDots
  SELF.GrabCornerLines() !
  SELF.SetStrategy(?Close,100,100,0,0)
  SELF.SetStrategy(?OLE,0,0,100,100)
!---------------------------------------------------
MainOLEEventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
MyTrace         dwrTrace
json            JSONClass
st              StringTheory
  CODE
    !MyTrace.Trace(OLEEvent)
    Case OLEEvent 
        Of 301
        !MyTrace.Trace('Event 301')
        If OcxGetParamCount(ref)
            !OleSt.Trace('MainOLEEventHandler - OLEEvent[' & OLEEvent & ']')
            !MyTrace.Trace(OcxGetParam(ref, 1) & ' ' & OcxGetParam(ref, 2))
            MyTrace.Trace(OcxGetParam(ref, 1))
            st.SetValue(OcxGetParam(ref, 1))
            if st.Length() > 1
                Free(AudioDevices)
                json.start()
                json.SetTagCase(jf:CaseAsIs)
                json.Load(AudioDevices,st)
            End
            !OleSt.Trace(OcxGetParam(ref, 2))
            
            !NMEAString = OcxGetParam(ref, 1) !Glo:NmeaSentence
            !GpsJSON = OcxGetParam(ref, 2)
            !NMEAString = OcxGetParam(ref, 1) !Glo:NmeaSentence
            !Glo:NmeaJSON = OcxGetParam(ref, 2)
            !Post(EVENT:TestEvent)
            !Post(Event:NmeaReceived)
        End
        Of 302
            !If OcxGetParamCount(ref)
            !    DotNETLog = OcxGetParam(ref, 1)
           !     Post(Event:UpdateStatus)
           ! End
    End  
  RETURN(True)
!---------------------------------------------------
MainOLEPropChange PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
  CODE
!---------------------------------------------------
MainOLEPropEdit FUNCTION(SIGNED OLEControlFEQ,STRING EditedProperty)
  CODE
  RETURN(0)

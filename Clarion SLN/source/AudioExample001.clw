

   MEMBER('AudioExample.clw')                              ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
   INCLUDE('ABTOOLBA.INC'),ONCE
   INCLUDE('ABWINDOW.INC'),ONCE

                     MAP
                       INCLUDE('AUDIOEXAMPLE001.INC'),ONCE        !Local module procedure declarations
MainOLEEventHandler    PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG
                     END


!!! <summary>
!!! Generated from procedure template - Window
!!! </summary>
Main PROCEDURE 

ColorGrp             GROUP,PRE(ColG)                       ! 
Red                  BYTE                                  ! 
Green                BYTE                                  ! 
Blue                 BYTE                                  ! 
Alpha                BYTE                                  ! 
                     END                                   ! 
SelectedColor        LONG,OVER(ColorGrp)                   ! 
Graph                LONG                                  ! 
VolumeMeter          LONG                                  ! 
FileFormat           STRING(50)                            ! 
AudioPosition        STRING(50)                            ! 
MyTrace         dwrTrace
!json            JSONClass
!st              StringTheory
LastDeviceGuid       STRING(50)
AudioFile            CSTRING(255)
Window               WINDOW('Audio Example'),AT(,,463,195),FONT('Segoe UI',9),RESIZE,ICON(ICON:Clarion),GRAY,MAX, |
  SYSTEM,IMM
                       BUTTON('Close'),AT(427,174),USE(?Close)
                       SHEET,AT(2,2,461,169),USE(?SHEET1)
                         TAB('General'),USE(?TAB1)
                           GROUP,AT(8,19,451,141),USE(?SettingsSheet),BOXED
                             PROMPT('Audio File:'),AT(11,29),USE(?AudioFile:Prompt),TRN
                             ENTRY(@s255),AT(65,28,187,10),USE(AudioFile)
                             BUTTON('...'),AT(256,27,12,12),USE(?LookupAudioFile)
                             PROMPT('Audio Devices:'),AT(11,43),USE(?AudioDevicesPrompt),TRN
                             LIST,AT(65,43,202,10),USE(LastDeviceGuid),DROP(10),FORMAT('1020L(2)M@s255@#3#')
                             BUTTON('Play'),AT(11,58),USE(?PlayBtn)
                             OLE,AT(11,76,441,77),USE(?OLE)
                             END
                             PROMPT('File Format:'),AT(281,29,36,10),USE(?FileFormat:Prompt),TRN
                             STRING(@s50),AT(320,29,132,10),USE(FileFormat),LEFT(2),TRN
                             STRING(@s50),AT(46,62,177),USE(AudioPosition),LEFT(2),TRN
                           END
                         END
                         TAB('Options'),USE(?TAB2)
                           OPTION('Graph:'),AT(9,21,177,48),USE(Graph),BOXED,TRN
                             RADIO('Left'),AT(22,34),USE(?Graph:Radio1),TRN,VALUE('1')
                             RADIO('Right'),AT(55,34),USE(?Graph:Radio2),TRN,VALUE('2')
                           END
                           BUTTON('Graph Background Color'),AT(88,30),USE(?GraphBackGroudColorBtn)
                           BUTTON('Graph Foreground Color'),AT(88,47,91,14),USE(?GraphForeGroudColorBtn)
                           OPTION('Volume Meter:'),AT(190,21,177,48),USE(VolumeMeter),BOXED,TRN
                             RADIO('Left'),AT(200,41),USE(?VolumeMeter:Radio1),TRN,VALUE('1')
                             RADIO('Right'),AT(233,41),USE(?VolumeMeter:Radio2),TRN,VALUE('2')
                           END
                           BUTTON('Volume Meter Color'),AT(271,39,91,14),USE(?GraphBackGroudColorBtn:2)
                         END
                       END
                     END

ThisWindow           CLASS(WindowManager)
Init                   PROCEDURE(),BYTE,PROC,DERIVED
Kill                   PROCEDURE(),BYTE,PROC,DERIVED
TakeAccepted           PROCEDURE(),BYTE,PROC,DERIVED
TakeEvent              PROCEDURE(),BYTE,PROC,DERIVED
                     END

Toolbar              ToolbarClass
Resizer              CLASS(WindowResizeClass)
Init                   PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)
                     END

! ----- myAudio2 --------------------------------------------------------------------------
myAudio2             Class(dwrAudioControl)
    ! derived method declarations
LoadFile               PROCEDURE (string pAudioFile),Proc,Virtual
                     End  ! myAudio2
! ----- end myAudio2 -----------------------------------------------------------------------
FileLookup2     SelectFileClass

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
  ! Restore preserved local variables from non-volatile store
  SELF.AddItem(Toolbar)
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
  !    0{PROP:Buffer} = 1  
  !    0{PROP:Pixels} = 1
  Do DefineListboxStyle
    !?OLE{PROP:Create} = 'ClaAudio'  
  myAudio2.CreateOLE(?OLE)
  OCXRegisterEventProc(?OLE,MainOLEEventHandler)
  Resizer.Init(AppStrategy:Spread,Resize:SetMinSize)       ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  
  
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FileLookup2.Init
  FileLookup2.ClearOnCancel = True
  FileLookup2.Flags=BOR(FileLookup2.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup2.SetMask('Audio Files','*.wav;*.mp3')         ! Set the file mask
  SELF.SetAlerts()
    !?OLE{'GetOutputDevices()'}
  !    st.SetValue(!?OLE{'GetOutputDevices()'})
  !    MyTrace.Trace('')
  !    MyTrace.Trace(st.GetValue())
  !    MyTrace.Trace('')  
  !    Free(AudioDevices)
  !    json.start()
  !    json.SetTagCase(jf:CaseAsIs)
  !    json.Load(AudioDevices,st)
  myAudio2.GetOutputDevices()
  !    If AudioFile  
  !        !?OLE{'LoadFile(' & AudioFile & ')'}
  !    End
  !    If LastDeviceGuid
  !        AudioDevices.DevideGUID = LastDeviceGuid
  !        Get(AudioDevices,AudioDevices.DevideGUID)
  !        !?OLE{'SetDeviceGuid(' & Clip(AudioDevices.DevideGUID) & ')'}
  !    End
  If AudioFile  
    myAudio2.LoadFile(AudioFile)
  End
  If LastDeviceGuid
    myAudio2.SetDeviceGuid(LastDeviceGuid)
  End
  ?LastDeviceGuid{PROP:From} = AudioDevices
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  Dispose(AudioDevices)
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  ! Save preserved local variables in non-volatile store
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
    OF ?LookupAudioFile
      ThisWindow.Update()
      ThisWindow.Update()
      AudioFile = FileLookup2.Ask(1)
      DISPLAY
      myAudio2.LoadFile(AudioFile)
    OF ?LastDeviceGuid
      myAudio2.SetDeviceGuid(LastDeviceGuid)
    OF ?PlayBtn
      ThisWindow.Update()
      ?PlayBtn{PROP:Text} = CHOOSE(?PlayBtn{PROP:Text}='Play','Stop','Play')
      Case myAudio2.GetIsPlaying()
      Of False 
        0{PROP:Timer} = 100
        myAudio2.Play()
      Of True
        0{PROP:Timer} = 0
        myAudio2.Stop()
      End
      FileFormat = myAudio2.GetFileFormat()
    OF ?GraphBackGroudColorBtn
      ThisWindow.Update()
      COLORDIALOG('Select Background Color',SelectedColor)
      !?OLE{'SetWaveGraphBackGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & Graph & ')'} 
      myAudio2.SetWaveGraphBackGroundColor(SelectedColor,Graph)
    OF ?GraphForeGroudColorBtn
      ThisWindow.Update()
      COLORDIALOG('Select Foreground Color',SelectedColor)
      !?OLE{'SetWaveGraphForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & Graph & ')'} 
      myAudio2.SetWaveGraphForeGroundColor(SelectedColor,Graph)
    OF ?GraphBackGroudColorBtn:2
      ThisWindow.Update()
      COLORDIALOG('Select Foreground Color',SelectedColor)
      !?OLE{'SetVolumeMeterForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & VolumeMeter & ')'} 
      myAudio2.SetVolumeMeterForeGroundColor(SelectedColor,VolumeMeter)
    END
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


ThisWindow.TakeEvent PROCEDURE

ReturnValue          BYTE,AUTO

Looped BYTE
  CODE
  LOOP                                                     ! This method receives all events
    IF Looped
      RETURN Level:Notify
    ELSE
      Looped = 1
    END
    Case EVENT()
    Of EVENT:Timer
        !!?OLE{'UpdatePosition()'}
        AudioPosition = myAudio2.GetPosition()
    End  
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue


Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
  SELF.SetStrategy(?Close, Resize:Reposition, Resize:LockSize) ! Override strategy for ?Close
  SELF.SetStrategy(?SHEET1, Resize:LockXPos+Resize:LockYPos, Resize:Resize) ! Override strategy for ?SHEET1
  SELF.SetStrategy(?Graph, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph
  SELF.SetStrategy(?Graph:Radio1, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph:Radio1
  SELF.SetStrategy(?Graph:Radio2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph:Radio2
  SELF.SetStrategy(?GraphBackGroudColorBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphBackGroudColorBtn
  SELF.SetStrategy(?GraphForeGroudColorBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphForeGroudColorBtn
  SELF.SetStrategy(?VolumeMeter, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter
  SELF.SetStrategy(?VolumeMeter:Radio1, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter:Radio1
  SELF.SetStrategy(?VolumeMeter:Radio2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter:Radio2
  SELF.SetStrategy(?GraphBackGroudColorBtn:2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphBackGroudColorBtn:2

MainOLEEventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
!MyTrace         dwrTrace
!json            JSONClass
!st              StringTheory
  CODE
!    Case OLEEvent 
!    Of 301
!    If OcxGetParamCount(ref)
!        AudioDevices.DevideGUID = OcxGetParam(ref, 1)
!        AudioDevices.ModuleName = OcxGetParam(ref, 2)
!        AudioDevices.Description = OcxGetParam(ref, 3)
!        Add(AudioDevices)
!    End
!    Of 302
!    End  
  Case OLEEvent 
  Of 301
    If OcxGetParamCount(ref)
        AudioDevices.DevideGUID = OcxGetParam(ref, 1)
          AudioDevices.ModuleName = OcxGetParam(ref, 2)
          AudioDevices.Description = OcxGetParam(ref, 3)
          Add(AudioDevices)
    End
  End 
  RETURN(True)
!----------------------------------------------------
myAudio2.LoadFile   PROCEDURE (string pAudioFile)
  CODE
!
  PARENT.LoadFile (pAudioFile)

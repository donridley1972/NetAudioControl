

   MEMBER('AudioExample.clw')                              ! This is a MEMBER module


   INCLUDE('ABRESIZE.INC'),ONCE
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
LastDeviceGuid       STRING(50)                            ! 
MyTrace         dwrTrace
!json            JSONClass
!st              StringTheory
Window               WINDOW('Audio Example'),AT(,,463,195),FONT('Segoe UI',9),RESIZE,ICON(ICON:Clarion),GRAY,MAX, |
  SYSTEM,IMM
                       BUTTON('Close'),AT(427,174),USE(?Close)
                       SHEET,AT(2,2,461,169),USE(?SHEET1)
                         TAB('General'),USE(?TAB1)
                           ENTRY(@s255),AT(45,18,290,10),USE(AudioFile)
                           PROMPT('Audio File:'),AT(9,19,33,10),USE(?AudioFile:Prompt),TRN
                           PROMPT('Audio Devices:'),AT(9,33,49,10),USE(?AudioDevicesPrompt),TRN
                           LIST,AT(61,33,134,10),USE(LastDeviceGuid),DROP(10),FORMAT('1020L(2)M@s255@#3#'),FROM(AudioDevices)
                           BUTTON('Play'),AT(9,46,32,14),USE(?PlayBtn)
                           BUTTON('Stop'),AT(44,46),USE(?StopBtn)
                           OLE,AT(9,63,450,103),USE(?OLE)
                           END
                           BUTTON('...'),AT(339,18,12,12),USE(?LookupFile)
                           PROMPT('File Format:'),AT(207,33,36,10),USE(?FileFormat:Prompt),TRN
                           STRING(@s50),AT(246,33,137,10),USE(FileFormat),LEFT(2),TRN
                           STRING(@s50),AT(79,49,177),USE(AudioPosition),LEFT(2),TRN
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
  ! Restore preserved local variables from non-volatile store
  AudioFile = INIMgr.TryFetch('Main_PreservedVars','AudioFile')
  LastDeviceGuid = INIMgr.TryFetch('Main_PreservedVars','LastDeviceGuid')
  CLEAR(GlobalRequest)                                     ! Clear GlobalRequest after storing locally
  CLEAR(GlobalResponse)
  SELF.AddItem(Toolbar)
  IF SELF.Request = SelectRecord
     SELF.AddItem(?Close,RequestCancelled)                 ! Add the close control to the window manger
  ELSE
     SELF.AddItem(?Close,RequestCompleted)                 ! Add the close control to the window manger
  END
  SELF.Open(Window)                                        ! Open window
    0{PROP:Buffer} = 1  
    0{PROP:Pixels} = 1
  Do DefineListboxStyle
    ?OLE{PROP:Create} = 'ClaAudio'  
  OCXRegisterEventProc(?OLE,MainOLEEventHandler)
  OCXRegisterPropChange(?OLE,MainOLEPropChange)
  OCXRegisterPropEdit(?OLE,MainOLEPropEdit)
  Resizer.Init(AppStrategy:Spread,Resize:SetMinSize)       ! Controls will spread out as the window gets bigger
  SELF.AddItem(Resizer)                                    ! Add resizer to window manager
  
  
  INIMgr.Fetch('Main',Window)                              ! Restore window settings from non-volatile store
  Resizer.Resize                                           ! Reset required after window size altered by INI manager
  FileLookup3.Init
  FileLookup3.ClearOnCancel = True
  FileLookup3.Flags=BOR(FileLookup3.Flags,FILE:LongName)   ! Allow long filenames
  FileLookup3.SetMask('Audio Files','*.wav;*.mp3')         ! Set the file mask
  SELF.SetAlerts()
    ?OLE{'GetOutputDevices()'}
  !    st.SetValue(?OLE{'GetOutputDevices()'})
  !    MyTrace.Trace('')
  !    MyTrace.Trace(st.GetValue())
  !    MyTrace.Trace('')  
  !    Free(AudioDevices)
  !    json.start()
  !    json.SetTagCase(jf:CaseAsIs)
  !    json.Load(AudioDevices,st)
    If AudioFile  
        ?OLE{'LoadFile(' & AudioFile & ')'}
    End
    If LastDeviceGuid
        AudioDevices.DevideGUID = LastDeviceGuid
        Get(AudioDevices,AudioDevices.DevideGUID)
        ?OLE{'SetDeviceGuid(' & Clip(AudioDevices.DevideGUID) & ')'}
    End
  RETURN ReturnValue


ThisWindow.Kill PROCEDURE

ReturnValue          BYTE,AUTO

  CODE
  ReturnValue = PARENT.Kill()
  IF ReturnValue THEN RETURN ReturnValue.
  IF SELF.Opened
    INIMgr.Update('Main',Window)                           ! Save window data to non-volatile store
  END
  ! Save preserved local variables in non-volatile store
  INIMgr.Update('Main_PreservedVars','AudioFile',AudioFile)
  INIMgr.Update('Main_PreservedVars','LastDeviceGuid',LastDeviceGuid)
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
    OF ?LastDeviceGuid
      Get(AudioDevices,Choice(?LastDeviceGuid)) 
      ?OLE{'SetDeviceGuid(' & Clip(AudioDevices.DevideGUID) & ')'}  
      !LastDeviceGuid = AudioDevices.DevideGUID   
    OF ?PlayBtn
      ThisWindow.Update()
      ?OLE{'Play()'}    
      
      FileFormat = ?OLE{'GetFileFormat()'}
      
      MyTrace.Trace('')
      MyTrace.Trace(FileFormat)
      MyTrace.Trace('')
      Clear(AudioPosition)
      0{PROP:Timer} = 100
    OF ?StopBtn
      ThisWindow.Update()
      ?OLE{'Stop()'}      
      
      0{PROP:Timer} = 0   
    OF ?LookupFile
      ThisWindow.Update()
      AudioFile = FileLookup3.Ask(1)
      DISPLAY
      ?OLE{'LoadFile(' & AudioFile & ')'}
      
      
    OF ?GraphBackGroudColorBtn
      ThisWindow.Update()
      COLORDIALOG('Select Background Color',SelectedColor)
      ?OLE{'SetWaveGraphBackGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & Graph & ')'} 
    OF ?GraphForeGroudColorBtn
      ThisWindow.Update()
      COLORDIALOG('Select Foreground Color',SelectedColor)
      ?OLE{'SetWaveGraphForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & Graph & ')'} 
    OF ?GraphBackGroudColorBtn:2
      ThisWindow.Update()
      COLORDIALOG('Select Foreground Color',SelectedColor)
      ?OLE{'SetVolumeMeterForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & VolumeMeter & ')'} 
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
        !?OLE{'UpdatePosition()'}
        AudioPosition = ?OLE{'GetPosition()'}
    End  
  ReturnValue = PARENT.TakeEvent()
    RETURN ReturnValue
  END
  ReturnValue = Level:Fatal
  RETURN ReturnValue

!---------------------------------------------------
MainOLEEventHandler FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
!MyTrace         dwrTrace
!json            JSONClass
!st              StringTheory
  CODE
    Case OLEEvent 
    Of 301
    If OcxGetParamCount(ref)
        AudioDevices.DevideGUID = OcxGetParam(ref, 1)
        AudioDevices.ModuleName = OcxGetParam(ref, 2)
        AudioDevices.Description = OcxGetParam(ref, 3)
        Add(AudioDevices)
    End
    Of 302
    End  
  RETURN(True)
!---------------------------------------------------
MainOLEPropChange PROCEDURE(SIGNED OLEControlFEQ,STRING ChangedProperty)
  CODE
!---------------------------------------------------
MainOLEPropEdit FUNCTION(SIGNED OLEControlFEQ,STRING EditedProperty)
  CODE
  RETURN(0)

Resizer.Init PROCEDURE(BYTE AppStrategy=AppStrategy:Resize,BYTE SetWindowMinSize=False,BYTE SetWindowMaxSize=False)


  CODE
  PARENT.Init(AppStrategy,SetWindowMinSize,SetWindowMaxSize)
  SELF.SetParentDefaults()                                 ! Calculate default control parent-child relationships based upon their positions on the window
  SELF.SetStrategy(?Close, Resize:Reposition, Resize:LockSize) ! Override strategy for ?Close
  SELF.SetStrategy(?SHEET1, Resize:LockXPos+Resize:LockYPos, Resize:Resize) ! Override strategy for ?SHEET1
  SELF.SetStrategy(?AudioFile, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?AudioFile
  SELF.SetStrategy(?AudioFile:Prompt, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?AudioFile:Prompt
  SELF.SetStrategy(?AudioDevicesPrompt, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?AudioDevicesPrompt
  SELF.SetStrategy(?PlayBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?PlayBtn
  SELF.SetStrategy(?StopBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?StopBtn
  SELF.SetStrategy(?OLE, Resize:LockXPos+Resize:LockYPos, Resize:Resize) ! Override strategy for ?OLE
  SELF.SetStrategy(?LookupFile, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?LookupFile
  SELF.SetStrategy(?FileFormat:Prompt, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?FileFormat:Prompt
  SELF.SetStrategy(?FileFormat, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?FileFormat
  SELF.SetStrategy(?AudioPosition, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?AudioPosition
  SELF.SetStrategy(?Graph, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph
  SELF.SetStrategy(?Graph:Radio1, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph:Radio1
  SELF.SetStrategy(?Graph:Radio2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?Graph:Radio2
  SELF.SetStrategy(?GraphBackGroudColorBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphBackGroudColorBtn
  SELF.SetStrategy(?GraphForeGroudColorBtn, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphForeGroudColorBtn
  SELF.SetStrategy(?VolumeMeter, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter
  SELF.SetStrategy(?VolumeMeter:Radio1, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter:Radio1
  SELF.SetStrategy(?VolumeMeter:Radio2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?VolumeMeter:Radio2
  SELF.SetStrategy(?GraphBackGroudColorBtn:2, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?GraphBackGroudColorBtn:2
  SELF.SetStrategy(?LastDeviceGuid, Resize:LockXPos+Resize:LockYPos, Resize:LockSize) ! Override strategy for ?LastDeviceGuid


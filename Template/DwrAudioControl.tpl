#TEMPLATE(dwrNetAudioControl,'.NET Audio Control'),FAMILY('ABC')
#Include('cape01.tpw')
#Include('cape02.tpw')
#INCLUDE('ABOOP.tpw')
#!------------------------------------------------------------------------------------------------------------------------
#Extension(Activate_DwrNetAudioControl,'Activate .NET Audio Control - Version:1.0'),Application
#PREPARE
#ENDPREPARE
#Sheet
    #Tab('General')
        #!#Insert(%GeneralLogoHeader)
        #Boxed(' Debugging '),section,at(,,,28)
            #Prompt('Disable All Template Features',Check),%NoDwrNetAudioControl,At(10,4)
        #EndBoxed
    #EndTab
    #TAB('Classes')
      #Insert(%GlobalDeclareClassesPR)
    #ENDTAB
#ENDSHEET	
#!-----------------------------------------------------------------------------------
#ATStart
  #IF(%NoDwrNetAudioControl=0)
    #INSERT(%ReadGlobal,2,0)
  #ENDIF
#ENDAT
#!-----------------------------------------------------------------------------------
#AT(%CustomGlobalDeclarations),where(%NoDwrNetAudioControl=0)
#PROJECT('None(claAudio.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.Asio.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.Core.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.Midi.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.Wasapi.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.WaveFormRenderer.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.WinForms.dll), CopyToOutputDirectory=Always')
#PROJECT('None(NAudio.WinMM.dll), CopyToOutputDirectory=Always')
#PROJECT('None(Newtonsoft.Json.dll), CopyToOutputDirectory=Always')
#PROJECT('None(claAudio.manifest), CopyToOutputDirectory=Always')
#ENDAT
#!
#!-----------------------------------------------------------------------------------
#AT(%AfterGlobalIncludes)
  Include('dwrAudioControl.inc'),Once
#ENDAT
#!-----------------------------------------------------------------------------------
#AT(%GlobalData)
#ENDAT
#!---------------------------------------------------
#AT(%ShipList)
  #IF(%ApplicationLocalLibrary)
  #ELSE
    #IF(%Target32)
___     claAudio.dll
___     NAudio.Asio.dll
___     NAudio.Core.dll
___     NAudio.dll
___     NAudio.Midi.dll
___     NAudio.Wasapi.dll
___     NAudio.WaveFormRenderer.dll
___     NAudio.WinForms.dll
___     NAudio.WinMM.dll
___     Newtonsoft.Json.dll
    #ENDIF
  #ENDIF
#ENDAT
#!-----------------------------------------------------------------------------------
#AtEnd
  #IF(%NoDwrNetAudioControl = 0)
    #INSERT(%EndGlobal)
  #ENDIF
#ENDAt
#!-------------------------------------------------------------------------------------------------------------------------
#CONTROL(DwrAudioOLEControl,'DWR Audio OLE/OCX'),DESCRIPTION('DWR Audio OLE/OCX'),Procedure,MULTI    #!,DESCRIPTION('DWR Audio OLE/OCX(' & INSTANCE(%ActiveTemplateInstance) & ')'),MULTI    #!,req(Activate_DwrNetAudioControl)   #!,HLP('~TPLControlOLEControl.htm'),WRAP(OLE) ,WINDOW,WRAP(OLE)
  CONTROLS
    Group,AT(,,386,141),USE(?SettingsSheet),Boxed
        PROMPT('Audio File:'),AT(,,,),USE(?AudioFile:Prompt),TRN
        ENTRY(@s255),AT(,,,10),USE(AudioFile)
        BUTTON('...'),AT(,,12,12),USE(?LookupAudioFile)
        PROMPT('Audio Devices:'),AT(,,,),USE(?AudioDevicesPrompt),TRN
        LIST,AT(,,,10),USE(LastDeviceGuid),DROP(10),FORMAT('1020L(2)M@s255@#3#')
        BUTTON('Play'),AT(,,,),USE(?PlayBtn)
        OLE,USE(?OLE)
        END
    END
  END
#Sheet
    #TAB('General')
          #BOXED('Callback Generation')
            #Prompt('Disable Template',Check),%NoDwrNetAudioControlLocal,At(10)
            #PROMPT('&Event Handler',CHECK),%GenerateEventCallback,default(1),At(10)
            #DISPLAY('Callback procedures will be generated in the procedure''s module.'),At(10)
            #DISPLAY('NOTE: Callback procedures do NOT have access to this procedure''s data!'),At(10)
            #ENABLE(%GenerateEventCallback) #! OR %GenerateChangeCallback OR %GenerateEditCallback)
              #PROMPT('&Include OCX.CLW in global MAP',CHECK),%IncludeOCXMap,DEFAULT(1),At(10)
            #ENDENABLE
          #PROMPT('I&nclude OCXEVENT.CLW in global data section',CHECK),%IncludeOCXEvent,DEFAULT(1),At(10)
          #PROMPT('OLE &BLOB Field',FIELD),%OLEBlobField
        #ENDBOXED
    #ENDTAB
    #TAB('Classes')
      #Boxed(''),section,at(,,,45)
        #Prompt('Object name:',@s255),%rasObjectName,default('myAudio' & %ActiveTemplateInstance),at(50,5,110,),promptat(10,5)
        #Prompt('Class name:',@s255),%rasClassName,default('dwrAudioControl'),at(50,20,110,),promptat(10,20)
      #EndBoxed
      #PROMPT('Declaration Class Embeds',EMBEDBUTTON(%ERSHDeclaration,%ActiveTemplateInstance)),AT(10,,180)
      #PROMPT('Class Embeds',EMBEDBUTTON(%ERSHProcedures,%ActiveTemplateInstance)),AT(10,,180)
      #PROMPT('Lookup Class:',@s20),%dwrLookupClass,DEFAULT('FileLookup' & %ActiveTemplateInstance),at(50,,110,),promptat(10,)
    #ENDTAB
#ENDSHEET
#!---------------------------------------------------
#ATSTART
#!#INSERT(%ReadGlobal,3,0)
#insert(%AtStartInitialisation)
#insert(%AddObjectPR,%rasClassName,%rasObjectName,'Local Objects')
  #DECLARE(%OLEControl)
  #DECLARE(%OLEShortName)
  #FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance) #! And %ControlType='OLE')
    #SET(%OLEControl,%Control)
  #ENDFOR
  #SET(%OLEShortName,SUB(%OLEControl,2,LEN(%OLEControl)-1))
#ENDAT
#!---------------------------------------------------
#AT(%CustomGlobalDeclarations)
  #IF(%GenerateEventCallback) #! OR %GenerateChangeCallback OR %GenerateEditCallback)
    #IF(%IncludeOCXMap)
      #ADD(%CustomGlobalMapIncludes,'OCX.CLW')
    #ENDIF
  #ENDIF
  #IF(%IncludeOCXEvent)
    #ADD(%CustomGlobalDeclarationIncludes,'OCXEVENT.CLW')
  #ENDIF
#ENDAT
#!--------------------------------------------------------------------
#AT(%GlobalData),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),PRIORITY(4000)
AudioDevices    &AudioDevicesQType
#ENDAT
#!--------------------------------------------------------------------
#AT(%ProgramSetup),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),PRIORITY(4000)
AudioDevices &= NEW AudioDevicesQType
#ENDAT
#!--------------------------------------------------------------------
#AT(%DataSection),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),PRIORITY(3000)
LastDeviceGuid       STRING(50)
AudioFile            CSTRING(255)
#ENDAT
#!--------------------------------------------------------------------
#AT(%LocalDataClasses),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
#INSERT(%GenerateClassDeclaration,%rasClassName,%rasObjectName,'Local Objects','Ridley Objects')
#ENDAT
#!--------------------------------------------------------------------
#AT(%LocalProcedures),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
#INSERT(%GenerateMethods,%rasclassname,%rasObjectName,'Local Objects','Ridley Objects')
#ENDAT
#! --------------------------------------------------------------------------
#AT(%LocalDataAfterClasses),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(5000)
%dwrLookupClass     SelectFileClass
#ENDAT
#!--------------------------------------------------------------------
#AT(%dMethodCodeSection,%ActiveTemplate & %ActiveTemplateInstance,%eMethodID),priority(5000),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),DESCRIPTION('Parent Call')
#INSERT(%ParentCall)
  #IF(not VarExists(%tmn))
    #DECLARE(%tmn)
  #ENDIF
  #SET(%tmn,%GetMethodName(%eMethodID))  #! EasyResizeAndSplit backwards compatibility
  #IF(Not (%tmn='Init' and %eMethodPrototype <> '(),VIRTUAL'))
  #EMBED(%ERSProcedures,'DwrTreeControl'),%tmn,'CODE',TREE(%rasObjectName & '|' & %tmn & ' ' & %eMethodPrototype),LEGACY
  #ENDIF
#ENDAT
#!---------------------------------------------------
#AT(%CustomModuleDeclarations),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
  #DECLARE(%TempOLEName)
  #FOR(%Control),WHERE(%ControlInstance=%ActiveTemplateInstance)
    #SET(%ValueConstruct,%Control)
  #ENDFOR
  #SET(%TempOLEName,SUB(%ValueConstruct,2,LEN(%ValueConstruct)-1))
  #IF(%GenerateEventCallback)
    #ADD(%CustomModuleMapModule,'CURRENT MODULE')
    #SET(%ValueConstruct,%Procedure & %TempOLEName & 'EventHandler')
    #ADD(%CustomModuleMapProcedure,%ValueConstruct)
    #SET(%CustomModuleMapProcedurePrototype,'PROCEDURE(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent),LONG')
  #ENDIF
#ENDAT
#!---------------------------------------------------
#AT(%AfterWindowOpening),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
#EMBED(%BeforeOLEInitialization,'Before initializing Audio OLE/OCX control'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
  #IF(%OLEBlobField)
IF %OLEBlobField{PROP:size} > 0
  #EMBED(%BeforeAssignToOLE,'Before assigning BLOB to Audio OLE/OCX Control'),WHERE(%OLEBlobField),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
  %OLEControl{PROP:Blob} = %OLEBlobField{PROP:handle}
  #EMBED(%AfterAssignToOLE,'After assigning BLOB to OLE Control'),WHERE(%OLEBlobField),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
    #SUSPEND
#?ELSE
  #EMBED(%NoBlobContents,'When the Audio OLE/OCX Blob is Empty'),WHERE(%OLEBlobField),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
    #RESUME
END
  #ENDIF
  #IF(%GenerateEventCallback)
    #SET(%ValueConstruct,%Procedure & %OLEShortName & 'EventHandler')
OCXRegisterEventProc(%OLEControl,%ValueConstruct)
  #ENDIF
#EMBED(%AfterOLEInitialization,'After initializing Audio OLE/OCX control'),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
#ENDAT
#!---------------------------------------------------
#AT(%ControlOtherEventHandling,%OLEControl),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
  #SUSPEND
#?IF EVENT()=EVENT:Accepted
  #EMBED(%BeforeBlobAssign,'Before assigning from Audio OLE/OCX control to BLOB'),WHERE(%OLEBlobField),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
    #IF(%OLEBlobField)
  %OLEBlobField{PROP:handle} = %OLEControl{PROP:Blob}
    #ENDIF
  #EMBED(%AfterBlobAssign,'After assigning from Audio OLE/OCX control to BLOB'),WHERE(%OLEBlobField),%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
#?END
  #RESUME
#ENDAT
#!---------------------------------------------------
#AT(%LocalProcedures),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0)
  #IF(%GenerateEventCallback)
    #SET(%ValueConstruct,%Procedure & %OLEShortName & 'EventHandler')
#!---------------------------------------------------
%ValueConstruct FUNCTION(*SHORT ref,SIGNED OLEControlFEQ,LONG OLEEvent)
#EMBED(%EventHandlerDeclaration,'Audio OLE/OCX Event Handler, Declaration Section'),DATA,%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
  CODE
#EMBED(%EventHandlerCode,'Audio OLE/OCX Event Handler, Code Section'),LABEL,%ActiveTemplateInstance,MAP(%ActiveTemplateInstance,%ActivetemplateInstanceDescription)
  RETURN(True)
  #ENDIF
#ENDAT
#!---------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(8080)
#FOR(%Control),WHERE(%ControlType='OLE')
#SET(%OLEControl,%Control)
#ENDFOR
%rasObjectName.CreateOLE(%OLEControl)
#ENDAT
#!---------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(9500)
%rasObjectName.GetOutputDevices()
#ENDAT
#!---------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(9950)
If AudioFile  
  #!?OLE{'LoadFile(' & AudioFile & ')'}
  %rasObjectName.LoadFile(AudioFile)
End
If LastDeviceGuid
  %rasObjectName.SetDeviceGuid(LastDeviceGuid)
End
#ENDAT
#!---------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(9980)
?LastDeviceGuid{PROP:From} = AudioDevices
#ENDAT
#! --------------------------------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Init','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(8440)
%dwrLookupClass.Init
%dwrLookupClass.ClearOnCancel = True
%dwrLookupClass.Flags=BOR(%dwrLookupClass.Flags,FILE:LongName)   ! Allow long filenames
%dwrLookupClass.SetMask('Audio Files','*.wav;*.mp3')         ! Set the file mask
#ENDAT
#! --------------------------------------------------------------------------
#AT(%ControlEventHandling,'?LookupAudioFile','Accepted'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(8500)
ThisWindow.Update()
AudioFile = %dwrLookupClass.Ask(1)
DISPLAY
%rasObjectName.LoadFile(AudioFile)
#ENDAT
#!------------------------------------------------------------------------------
#AT(%EventHandlerCode,%ActiveTemplateInstance),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(5000)
  Case OLEEvent 
  Of 301
    If OcxGetParamCount(ref)
        AudioDevices.DevideGUID = OcxGetParam(ref, 1)
        #!Get(AudioDevices,AudioDevices.DevideGUID)
        #!If Errorcode()
          AudioDevices.ModuleName = OcxGetParam(ref, 2)
          AudioDevices.Description = OcxGetParam(ref, 3)
          Add(AudioDevices)
        #!End
    End
  End 
#ENDAT
#!------------------------------------------------------------------------------
#AT(%ControlEventHandling,'?LastDeviceGuid','Accepted'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(5000)
%rasObjectName.SetDeviceGuid(LastDeviceGuid)
#ENDAT
#!------------------------------------------------------------------------------
#AT(%ControlEventHandling,'?PlayBtn','Accepted'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(8500)
?PlayBtn{PROP:Text} = CHOOSE(?PlayBtn{PROP:Text}='Play','Stop','Play')
Case %rasObjectName.GetIsPlaying()
Of False 
  0{PROP:Timer} = 100
  %rasObjectName.Play()
Of True
  0{PROP:Timer} = 0
  %rasObjectName.Stop()
End
#ENDAT
#!------------------------------------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'TakeEvent','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(3200)
#ENDAT
#!---------------------------------------------------
#AT(%WindowManagerMethodCodeSection,'Kill','(),BYTE'),WHERE(%NoDwrNetAudioControl=0 And %NoDwrNetAudioControlLocal=0),Priority(2300)
Dispose(AudioDevices)
#ENDAT
#!------------------------------------------------------------------------------
#GROUP(%ReadGlobal,%pa,%force)
  #INSERT(%SetFamily)
  #FOR(%applicationTemplate),Where(%applicationTemplate='Activate_DwrNetAudioControl(dwrNetAudioControl)')
    #FOR(%applicationTemplateInstance)
      #Context(%application,%applicationTemplateInstance)
        #insert(%ReadClassesPR,'dwrAudioControl.INC',%pa,%force)
      #EndContext
    #EndFor
  #EndFor
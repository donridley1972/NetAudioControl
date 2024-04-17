
Audio:UpdateSliderEvent     Equate(EVENT:User+9990)

ColorGrpType            GROUP,Type
Red                     BYTE
Green                   BYTE
Blue                    BYTE
Alpha                   BYTE
                        END

AudioDevicesQType       QUEUE,Type,Name('AudioDevices')
DevideGUID              STRING(50),Name('DevideGUID')
ModuleName              STRING(50),Name('ModuleName')
Description             STRING(255),Name('Description')
                        END



dwrAudioControl                 CLASS,TYPE,MODULE('dwrAudioControl.CLW'),LINK('dwrAudioControl.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)

OLEControl                      Long
AudioFile                       CSTRING(255)
LastDeviceGuid                  String(50)
AudioPosition                   String(50)
FileFormat                      String(50)
IsPlaying                       BYTE

Init                            PROCEDURE()
Kill                            PROCEDURE()

Construct                       PROCEDURE()
Destruct                        PROCEDURE()

CreateOLE                       Procedure(long pOLEControl),Proc,Virtual
GetFileFormat                   Procedure(),String,Proc,Virtual
GetIsPlaying                    Procedure(),Byte,Virtual,Proc
GetOutputDevices                Procedure(),Proc,Virtual
GetPosition                     Procedure(),String,Proc,Virtual
GetSliderPos                    Procedure(),Long,Proc,Virtual
LoadFile                        Procedure(string pAudioFile),Proc,Virtual
Play                            Procedure(),Proc,Virtual
SetAudioPosition                Procedure(long pSliderPos),Proc,Virtual
SetDeviceGuid                   Procedure(string pDeviceGuid),Proc,Virtual
SetIsPlaying                    Procedure(byte pVal),Virtual,Proc
SetWaveGraphBackGroundColor     Procedure(long pColor,long pGraphNo),Proc,Virtual
SetWaveGraphForeGroundColor     Procedure(long pColor,long pGraphNo),Proc,Virtual
SetVolumeMeterForeGroundColor   Procedure(long pColor,long pMeterNo),Proc,Virtual
Stop                            Procedure(),Proc,Virtual
                                END


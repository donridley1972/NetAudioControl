    MEMBER()

    INCLUDE('EQUATES.CLW')
    INCLUDE('dwrAudioControl.INC'),ONCE


    MAP
    END

dwrAudioControl.Construct                       PROCEDURE()
    CODE

    RETURN


dwrAudioControl.Destruct                        PROCEDURE()
    CODE

    RETURN

dwrAudioControl.Init                            PROCEDURE()
    CODE

    RETURN

dwrAudioControl.Kill                            PROCEDURE()
    CODE
    self.OLEControl{'Kill()'}
    RETURN

dwrAudioControl.CreateOLE                       Procedure(long pOLEControl) !,Proc,Virtual
    CODE
    self.OLEControl = pOLEControl
    self.OLEControl{PROP:Create} = 'ClaAudio'

dwrAudioControl.GetFileFormat                   Procedure()     !,String,Proc,Virtual
    CODE
    return self.OLEControl{'GetFileFormat()'}   !self.FileFormat = 

dwrAudioControl.GetIsPlaying                    Procedure() !,Byte,Virtual,Proc
    CODE
    return self.IsPlaying

dwrAudioControl.GetOutputDevices                Procedure() !,Proc,Virtual
    CODE
    self.OLEControl{'GetOutputDevices()'}

dwrAudioControl.GetPosition                     Procedure() !,String,Proc,Virtual
    CODE
    return self.OLEControl{'GetPosition()'}

dwrAudioControl.GetSliderPos                    Procedure() !,Long,Proc,Virtual
    CODE
    return self.OLEControl{'GetSliderPos()'}

dwrAudioControl.LoadFile                        Procedure(string pAudioFile)    !,Proc,Virtual
    CODE
    self.AudioFile = pAudioFile
    self.OLEControl{'LoadFile(' & self.AudioFile & ')'}

dwrAudioControl.Play                            Procedure() !,Proc,Virtual
    CODE
    self.SetIsPlaying(True)
    self.OLEControl{'Play()'}

dwrAudioControl.SetAudioPosition                Procedure(long pSliderPos)  !,Proc,Virtual
    CODE
    self.OLEControl{'SetAudioPosition(' & pSliderPos & ')'}

dwrAudioControl.SetDeviceGuid                   Procedure(string pDeviceGuid)   !,Proc,Virtual
    code
    self.OLEControl{'SetDeviceGuid(' & Clip(pDeviceGuid) & ')'}

dwrAudioControl.SetIsPlaying                    Procedure(byte pVal)    !,Virtual,Proc
    CODE
    self.IsPlaying = pVal

dwrAudioControl.SetWaveGraphBackGroundColor     Procedure(long pColor,long pGraphNo) !,Proc,Vitrual
ColorGrp        LIKE(ColorGrpType)
ColorLng        Long,OVER(ColorGrp)
    CODE
    ColorLng = pColor
    self.OLEControl{'SetWaveGraphBackGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & pGraphNo & ')'} 

dwrAudioControl.SetWaveGraphForeGroundColor     Procedure(long pColor,long pGraphNo)    !,Proc,Virtual
ColorGrp        LIKE(ColorGrpType)
ColorLng        Long,OVER(ColorGrp)
    CODE
    ColorLng = pColor
    self.OLEControl{'SetWaveGraphForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & pGraphNo & ')'}

dwrAudioControl.SetVolumeMeterForeGroundColor   Procedure(long pColor,long pMeterNo)    !,Proc,Virtual
ColorGrp        LIKE(ColorGrpType)
ColorLng        Long,OVER(ColorGrp)
    CODE
    ColorLng = pColor
    self.OLEControl{'SetVolumeMeterForeGroundColor(' & ColorGrp.Red & ',' & ColorGrp.Green & ',' & ColorGrp.Blue & ',' & pMeterNo & ')'}

dwrAudioControl.Stop                            Procedure() !,Proc,Virtual
    CODE
    self.SetIsPlaying(False)
    self.OLEControl{'Stop()'}

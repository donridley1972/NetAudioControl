using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Microsoft.Win32;

namespace claAudio
{
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IClaAudioEvents
    {
        [DispId(301)]
        void SendOutputDevice(string pGuid, string pModule, string pDescription);

        [DispId(302)]
        void SliderUpdate(int pTick);
    }
}
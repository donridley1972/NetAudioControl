    MEMBER()

    INCLUDE('EQUATES.CLW')
    INCLUDE('dwrTrace.INC'),ONCE
    INCLUDE('StringTheory.inc'),ONCE



    MAP
        Module('Win32')
            trace_FormatMessage(ulong dwFlags, ulong lpSource, ulong dwMessageId, ulong dwLanguageId, *cstring lpBuffer,ulong nSize, ulong Arguments), ulong, raw, pascal, name('FormatMessageA')
            trace_GetLastError(),long,PASCAL,name('GetLastError')
            trace_OutputDebugString(*cstring msg), raw, pascal, name('OutputDebugStringA')
        End
    END

!----------------------------------------
dwrTrace.Construct        PROCEDURE()
!----------------------------------------
    CODE


    RETURN


!---------------------------------------
dwrTrace.Destruct PROCEDURE()
!---------------------------------------
    CODE

    RETURN


!-----------------------------------
dwrTrace.Init     PROCEDURE()
!-----------------------------------

    CODE

    RETURN

!-----------------------------------
dwrTrace.Kill     PROCEDURE()
!-----------------------------------

    CODE

    RETURN

dwrTrace.FormatMessage           Procedure(long pError) !,String,Virtual,Proc
winErrMessage       cstring(255)
errMessage          string(255)
numChars            ulong
    CODE
    numChars = trace_FormatMessage(TRACE:APIFORMAT_MESSAGE_FROM_SYSTEM + TRACE:APIFORMAT_MESSAGE_IGNORE_INSERTS, 0, pError, 0, winErrMessage, 255, 0)
    errMessage = winErrMessage
    Return(errMessage)

dwrTrace.GetLastError            Procedure()    !,String,Proc,Virtual
st          StringTheory
    CODE
    st.SetValue(self.FormatMessage(trace_GetLastError()),True)
    st.Remove('<13><10>')
    return st.GetValue()

dwrTrace.Trace                   Procedure(string pVal) !,Proc,Virtual
DebugStr         &CSTRING
    CODE
    DebugStr &= New CSTRING(Size(pVal)+20)
    PushErrors()
    !if not omitted(pVal)
        DebugStr = Clip(pVal) & '<13><10>'
        trace_OutputDebugString(DebugStr)
    !ELSE
    !    DebugStr = '<32><13,10>'
    !    csOutputDebugString(DebugStr)
    !end
    PopErrors()
    Dispose(DebugStr)

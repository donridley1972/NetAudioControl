
! equate for passing the the FormatMessage() function
TRACE:APIORMAT_MESSAGE_ALLOCATE_BUFFER       equate(000100h)
TRACE:APIFORMAT_MESSAGE_IGNORE_INSERTS       equate(000200h)
TRACE:APIFORMAT_MESSAGE_FROM_STRING          equate(000400h)
TRACE:APIFORMAT_MESSAGE_FROM_HMODULE         equate(000800h)
TRACE:APIFORMAT_MESSAGE_FROM_SYSTEM          equate(001000h)
TRACE:APIFORMAT_MESSAGE_ARGUMENT_ARRAY       equate(002000h)
TRACE:APIFORMAT_MESSAGE_MAX_WIDTH_MASK       equate(0000FFh)


dwrTrace                CLASS,TYPE,MODULE('dwrTrace.CLW'),LINK('dwrTrace.CLW',_ABCLinkMode_),DLL(_ABCDllMode_)

Init                    PROCEDURE()
Kill                    PROCEDURE()

Construct               PROCEDURE()
Destruct                PROCEDURE()

FormatMessage           Procedure(long pError),String,Virtual,Proc
GetLastError            Procedure(),String,Proc,Virtual
Trace                   Procedure(string pVal),Proc,Virtual
                        END

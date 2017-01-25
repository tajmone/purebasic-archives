FASM
----

> **NOTE 1**: Currently, the FASM language definition (`fasm.js`) is just a copy of `x86asm.js` (**highlight.js**’s gerneric language definition for Intel x86 Assembly), so it doesn’t render FASM syntax 100% correctly. In due time, the language definition will be tweaked to become FASM-specific and fully compliant. I’ve chosen to early-adopt a renamed version of `x86asm.js` file to avoid having to change — in the future — all language class attributes in source documents.

> **NOTE 2**: The current theme uses **xterm**’s color palette. I wanted to provide an old-school look to FASM syntax. But the theme palette will change when the language definition shall be completed.

``` {.fasm}
; Beer - example of tiny (one section) Win32 program

format PE GUI 4.0

include 'win32a.inc'

; no section defined - fasm will automatically create .flat section for both
; code and data, and set entry point at the beginning of this section

    invoke  MessageBoxA,0,_message,_caption,MB_ICONQUESTION+MB_YESNO
    cmp eax,IDYES
    jne exit

    invoke  mciSendString,_cmd_open,0,0,0
    invoke  mciSendString,_cmd_eject,0,0,0
    invoke  mciSendString,_cmd_close,0,0,0

exit:
    invoke  ExitProcess,0

_message db 'Do you need additional place for the beer?',0
_caption db 'Desktop configuration',0

_cmd_open db 'open cdaudio',0
_cmd_eject db 'set cdaudio door open',0
_cmd_close db 'close cdaudio',0

; import data in the same section

data import

 library kernel32,'KERNEL32.DLL',\
     user32,'USER32.DLL',\
     winmm,'WINMM.DLL'

 import kernel32,\
    ExitProcess,'ExitProcess'

 import user32,\
    MessageBoxA,'MessageBoxA'

 import winmm,\
    mciSendString,'mciSendStringA'

end data
```

(example taken from **FASM** for Windows distribution package, examples folder, `BEER.ASM`)

;Include Modern UI

  !include "MUI2.nsh"


; The name of the installer
Name "PolyPop WebSocket"

; The file to write
OutFile "PolyPop WebSocket Installer.exe"

; The default installation directory
InstallDir $Profile\PolyPop\UIX\WebSocket\

; Set the icon of the installer
Icon "icon.ico"

; Request application privileges for Windows
RequestExecutionLevel user

; macro stuff
  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

  !insertmacro MUI_LANGUAGE "English"

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $Profile\PolyPop\UIX\WebSocket-dev\
  
  File /r "$Profile\PolyPop\UIX\WebSocket\*.lua"
  File /r "$Profile\PolyPop\UIX\WebSocket\*.text"
  File /r "$Profile\PolyPop\UIX\WebSocket\*.uix"
  File /r "$Profile\PolyPop\UIX\WebSocket\*.dds"
  File /r "$Profile\PolyPop\UIX\WebSocket\*.md"
  
  
SectionEnd

; idk how to write this stuff. I'm hoping NSIS knows what to delete.
Section "Uninstall"

  Delete "$INSTDIR\*"

  RMDir "$INSTDIR"

SectionEnd

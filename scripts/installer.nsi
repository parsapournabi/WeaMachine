!include "MUI2.nsh"
!include "LogicLib.nsh"
!include "nsDialogs.nsh"


; ============================================================
; Required build argument
; ============================================================

!ifndef DEPLOY_DIR
    !define DEPLOY_DIR "WeaMachine"
    ; !error "DEPLOY_DIR is required. Example: makensis /DDEPLOY_DIR=\"C:\path\to\WeaMachine\" installer.nsi"
!endif


; ============================================================
; Application
; ============================================================

!define APP_NAME        "WeaMachine"
!define APP_EXE         "WeaMachine.exe"
!define APP_VERSION     "2.3.1"

Name "${APP_NAME}"
OutFile "${APP_NAME}-windows-64.exe"

InstallDir "$PROGRAMFILES64\${APP_NAME}"

RequestExecutionLevel admin


; ============================================================
; Icons
; ============================================================

; Icon of the installer EXE
!define MUI_ICON "Wearily-Logo-Installer-Icon.ico"

; Icon embedded into generated Uninstall.exe
!define MUI_UNICON "Wearily-Logo-Installer-Icon.ico"


; ============================================================
; UI
; ============================================================

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY

; Custom shortcut checkbox
Page custom ShortcutPageCreate ShortcutPageLeave

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


; ============================================================
; Uninstaller UI
; ============================================================

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES


; ============================================================
; Language
; ============================================================

!insertmacro MUI_LANGUAGE "English"


; ============================================================
; Variables
; ============================================================

Var DesktopShortcut
Var ShortcutCheckbox


; ============================================================
; Shortcut page
; ============================================================

Function ShortcutPageCreate

    nsDialogs::Create 1018
    Pop $0

    ${If} $0 == error
        Abort
    ${EndIf}

    ${NSD_CreateCheckbox} 0 0 100% 12u \
        "Create a desktop shortcut"

    Pop $ShortcutCheckbox

    ; Checked by default
    ${NSD_Check} $ShortcutCheckbox

    nsDialogs::Show

FunctionEnd


Function ShortcutPageLeave

    ${NSD_GetState} $ShortcutCheckbox $DesktopShortcut

FunctionEnd


; ============================================================
; Installation
; ============================================================

Section "WeaMachine"

    SetOutPath "$INSTDIR"

    ; Copy everything from DEPLOY_DIR
    File /r "${DEPLOY_DIR}\*.*"


    ; --------------------------------------------------------
    ; Start Menu
    ; --------------------------------------------------------

    CreateDirectory "$SMPROGRAMS\${APP_NAME}"

    CreateShortcut \
        "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" \
        "$INSTDIR\${APP_EXE}"


    ; --------------------------------------------------------
    ; Desktop Shortcut
    ; --------------------------------------------------------

    ${If} $DesktopShortcut == ${BST_CHECKED}

        CreateShortcut \
            "$DESKTOP\${APP_NAME}.lnk" \
            "$INSTDIR\${APP_EXE}"

    ${EndIf}


    ; --------------------------------------------------------
    ; Uninstaller
    ; --------------------------------------------------------

    WriteUninstaller "$INSTDIR\Uninstall.exe"


    ; --------------------------------------------------------
    ; Add/Remove Programs
    ; --------------------------------------------------------

    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "DisplayName" \
        "${APP_NAME}"

    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "DisplayVersion" \
        "${APP_VERSION}"

    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "InstallLocation" \
        "$INSTDIR"

    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "UninstallString" \
        '"$INSTDIR\Uninstall.exe"'

    ; Application icon shown in Installed Apps /
    ; Programs and Features
    WriteRegStr HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "DisplayIcon" \
        "$INSTDIR\${APP_EXE}"

SectionEnd


; ============================================================
; Uninstall
; ============================================================

Section "Uninstall"

    Delete "$DESKTOP\${APP_NAME}.lnk"

    Delete "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk"
    RMDir "$SMPROGRAMS\${APP_NAME}"

    DeleteRegKey HKLM \
        "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"

    RMDir /r "$INSTDIR"

SectionEnd

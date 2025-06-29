; -- CS2ConfigWriter.iss --

; Define variables:

#define MyDistributionFilesDir "s:\cs2_cfg_writer"
#define MyInstallFilesDir "install_files"     
#define MyIniFileName "CS2ConfigWriter.ini"
#define MyHintsFileName "command_hints.ini"
#define MyCommandsFileName "commands.ini"
#define MyOutputDir "x:\Exe"
#define MyAppName "CS2ConfigWriterApp"
#define MyAppVersion "v1.0.0"
#define MyAppVersionFileName "1_0_0"
#define MyAppBinName "cs2_cfg_writer_app.exe"
#define MyResourcesDir "resources"
#define MyAppMainIcon "cs2_config_writer.ico"

[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
; WizardStyle=modern
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputDir={#MyOutputDir}
OutputBaseFilename={#MyAppName}-{#MyAppVersionFileName}-setup
LicenseFile={#MyDistributionFilesDir}\LICENSE
;UninstallDisplayIcon={app}
Compression=lzma2
SolidCompression=yes
;PrivilegesRequired=admin
SetupIconFile={#MyDistributionFilesDir}\{#MyResourcesDir}\icons\{#MyAppMainIcon}
UninstallDisplayIcon={#MyDistributionFilesDir}\{#MyResourcesDir}\icons\{#MyAppMainIcon}

[Files]
Source: "{#MyOutputDir}\{#MyAppBinName}"; DestDir: "{app}"
Source: "{#MyDistributionFilesDir}\{#MyInstallFilesDir}\{#MyIniFileName}"; DestDir: "{userappdata}\{#MyAppName}"
Source: "{#MyDistributionFilesDir}\{#MyInstallFilesDir}\{#MyHintsFileName}"; DestDir: "{userappdata}\{#MyAppName}"
Source: "{#MyDistributionFilesDir}\{#MyInstallFilesDir}\{#MyCommandsFileName}"; DestDir: "{userappdata}\{#MyAppName}"
Source: "{#MyDistributionFilesDir}\README.md"; DestDir: "{app}"; Flags: isreadme

[Tasks]
Name: startmenu; Description: "Create a Start Menu folder";

;[Icons]
;Name: "{group}\CS2ConfigWriter"; Filename: "{app}\CS2ConfigWriterApp.exe"

[Dirs]
Name: "{userappdata}\{#MyAppName}"

;[Registry]
;Root: HKLM; Subkey: "SOFTWARE\{#MyAppName}"; ValueType: string; ValueName: "Path"; ValueData: "{app}\{#MyAppBinName}"; Flags: uninsdeletekey
;Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: none; ValueName: "{#MyAppName}"; Flags: dontcreatekey uninsdeletekey 

;[INI]
;Filename: {app}\{#MyIniFileName}; Section: "Settings"; Flags: uninsdeletesection createkeyifdoesntexist
;Filename: {app}\{#MyIniFileName}; Section: "Settings"; Key: "AutoExpandTreeView"; String: "1"
;Filename: {app}\{#MyIniFileName}; Section: "Settings"; Key: "LastFileName"; String: ""
;Filename: {app}\{#MyIniFileName}; Section: "Settings"; Key: "AutoSaveOnClose"; String: "1"

[RUN]
;Filename: "{app}\{#MyAppBinName}"
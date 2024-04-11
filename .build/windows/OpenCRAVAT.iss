; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define AppName "OpenCRAVAT"
#ifndef Version
#define Version "2.2.8"
#endif
#define AppPublisher "KarchinLab"
#define AppURL "https://github.com/KarchinLab/open-cravat"

[Setup]
AppName={#AppName}
AppVersion={#Version}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
DefaultDirName={commonpf64}\{#AppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
DefaultGroupName={#AppName}
ChangesEnvironment=true

[Files]
Source: "C:\Program Files\OpenCRAVAT\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs;

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\bin\OpenCRAVAT.bat"; IconFilename: "{app}\logo.ico"
Name: "{userdesktop}\{#AppName}"; Filename: "{app}\bin\OpenCRAVAT.bat"; IconFilename: "{app}\logo.ico"; Tasks: desktopicon

[Code]
const
  oldUninstallerPath = 'C:\Program Files (x86)\open-cravat\unins000.exe';
	ModPathName = 'modifypath';
	ModPathType = 'user';
var
  CancelWithoutPrompt: boolean;

function ModPathDir(): TArrayOfString;
begin
	setArrayLength(Result, 1)
	Result[0] := ExpandConstant('{app}\bin');
end;

#include "modpath.iss"

function RemoveOldOC(): Boolean;
var
  ResultCode: Integer;
begin
  Log(oldUninstallerPath);
  if Exec(ExpandConstant(oldUninstallerPath), '', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
  begin
    Log('PASS uninstall');
    Result := true;
  end
  else
    begin
    Log('FAIL uninstall');
    Result := false;
    end;
  end;

procedure curStepChanged(CurStep: TSetupStep);
var
  ResultCode: integer;
  taskname:	String;
begin
  taskname := ModPathName;
  if curStep = ssInstall then
  begin
    Log('ssInstall');
    if FileExists(oldUninstallerPath) = True then
      begin
      if MsgBox('OpenCRAVAT Setup:' #13#13 'A previous version of OpenCRAVAT is installed. It must be uninstalled to continue.' #13#13 'Uninstall old version?', mbConfirmation, MB_YESNO) = idYes then
        begin
        RemoveOldOC()
        end
      else
        begin
        MsgBox('Installation cancelled', mbInformation, MB_OK);
        CancelWithoutPrompt := true;
        WizardForm.Close;
        end
      end
  end
  else if curStep = ssPostInstall then
    begin
		ModPath();
    end;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CurPageID=wpInstalling then
    Confirm := not CancelWithoutPrompt;
end;
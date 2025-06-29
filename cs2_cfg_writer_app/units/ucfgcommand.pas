unit uCfgCommand;

{$mode ObjFPC}{$H+}

interface

{$INCLUDE global_directives.inc}

uses
  Classes, SysUtils, fgl;

type

  { TCfgCommand }

  TCfgCommand = class
  private
    FDefault: string;
    FDescription: string;
    FName: string;
  published
    property Name: string read FName;
    property Default: string read FDefault;
    property Description: string read FDescription;
  end;

  { TCfgCommands }

  TCfgCommands = class(specialize TFPGObjectList<TCfgCommand>)
  public
    function CommandByName(const AName: string): TCfgCommand;
  end;

var
  CfgCommands: TCfgCommands;

procedure LoadCommands;

implementation

uses
  IniFiles, uGlobalConstants;

procedure LoadCommands;
var
  CfgCommandsFileName: string;
  CfgCommandsFile: TIniFile;
  i, y: integer;
  CfgCommand: TCfgCommand;
  Sections, SectionKeys: TStringList;
begin
  if CfgCommands <> nil then
    Exit;

  CfgCommandsFileName := ''
    + IncludeTrailingPathDelimiter(SysUtils.GetEnvironmentVariable('appdata'))
    + IncludeTrailingPathDelimiter(ApplicationName)
    + COMMANDS_FILE_NAME
    ;
  if not FileExists(CfgCommandsFileName) then
    raise Exception.Create('Došlo k chybě! Nepodařili se načíst commandy!');

  FreeAndNil(CfgCommands);
  CfgCommands := TCfgCommands.Create(True);
  try
    CfgCommandsFile := TIniFile.Create(
        CfgCommandsFileName
        , TEncoding.UTF8
        , True
        , [ifoStripComments, ifoStripInvalid, ifoEscapeLineFeeds, ifoStripQuotes, ifoFormatSettingsActive]
        );
    try
      Sections := TStringList.Create;
      try
        CfgCommandsFile.ReadSections(Sections);
        for i := 0 to Sections.Count - 1 do
        begin
          SectionKeys := TStringList.Create;
          try
            CfgCommand := TCfgCommand.Create;
            try
              CfgCommand.FName := Sections[i];
              CfgCommandsFile.ReadSection(Sections[i], SectionKeys);
              for y := 0 to SectionKeys.Count - 1 do
              begin
                if CompareText(SectionKeys[y], COMMANDS_DEFAULT) = 0 then
                  CfgCommand.FDefault := CfgCommandsFile.ReadString(Sections[i], SectionKeys[y], '')
                else if CompareText(SectionKeys[y], COMMANDS_DESCRIPTION) = 0 then
                  CfgCommand.FDescription := CfgCommandsFile.ReadString(Sections[i], SectionKeys[y], '')
                ;
              end;
              CfgCommands.Add(CfgCommand);
            except
              FreeAndNil(CfgCommand);
            end;
          finally
            FreeAndNil(SectionKeys);
          end;
        end;
      finally
        FreeAndNil(Sections);
      end;
    finally
      FreeAndNil(CfgCommandsFile);
    end;
  finally
  end;
end;

{ TCfgCommands }

function TCfgCommands.CommandByName(const AName: string): TCfgCommand;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if CompareText(Self[i].Name, AName) = 0 then
    begin
      Result := Self[i];
      Exit;
    end;
  end;
end;

end.


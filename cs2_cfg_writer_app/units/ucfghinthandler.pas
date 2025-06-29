unit uCfgHintHandler;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TCfgHint }

  TCfgHint = class
  private
    FCommandName: string;
    FCommandDescription: string;
    FCommandHint: string;
  public
    property CommandName: string read FCommandName write FCommandName;
    property CommandDescription: string read FCommandDescription write FCommandDescription;
    property CommandHint: string read FCommandHint write FCommandHint;
  end;

  { TCfgHintList }

  TCfgHintList = class(TList)
  private
    function GetItem(Index: integer): TCfgHint;
  public
    destructor Destroy; override;
    procedure Clear; override;
  public
    property Items[Index: integer]: TCfgHint read GetItem; default;
  end;

  { TCfgHintHandler }

  TCfgHintHandler = class
  private
    FCfgHintList: TCfgHintList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Refresh;
    function Description(const ACommandName: string): string;
    function Hint(const ACommandName: string): string;
    property CfgHintList: TCfgHintList read FCfgHintList;
  end;

implementation

uses
  IniFiles, uGlobalConstants, uSettingsWriter;

{ TCfgHintHandler }

constructor TCfgHintHandler.Create;
begin
  inherited;
  FCfgHintList := TCfgHintList.Create;
  Self.Refresh;
end;

destructor TCfgHintHandler.Destroy;
begin
  FreeAndNil(FCfgHintList);
  inherited Destroy;
end;

procedure TCfgHintHandler.Refresh;
var
  CfgHint: TCfgHint;
  IniFile: TIniFile;
  Sections, SectionKeys: TStringList;
  i, y: integer;
begin
  FCfgHintList.Clear;
  try
    IniFile := TIniFile.Create(
      IncludeTrailingPathDelimiter(SysUtils.GetEnvironmentVariable('appdata'))
        + IncludeTrailingPathDelimiter(ApplicationName)
        + Settings.Value[SETT_COMMAND_HINT_FILE_NAME].AsString
      , TEncoding.UTF8
      , True
      , [ifoStripComments, ifoStripInvalid, ifoEscapeLineFeeds, ifoStripQuotes, ifoFormatSettingsActive]
      );
    try
      Sections := TStringList.Create;
      try
        IniFile.ReadSections(Sections);
        for i := 0 to Sections.Count - 1 do
        begin
          SectionKeys := TStringList.Create;
          try
            CfgHint := TCfgHint.Create;
            try
              CfgHint.CommandName := Sections[i];
              IniFile.ReadSection(Sections[i], SectionKeys);
              for y := 0 to SectionKeys.Count - 1 do
              begin
                if CompareText(SectionKeys[y], COMMAND_HINTS_DESCRIPTION) = 0 then
                  CfgHint.CommandDescription := IniFile.ReadString(Sections[i], SectionKeys[y], '')
                else if CompareText(SectionKeys[y], COMMAND_HINTS_HINT) = 0 then
                  CfgHint.CommandHint := IniFile.ReadString(Sections[i], SectionKeys[y], '')
                ;
              end;
              FCfgHintList.Add(CfgHint);
            except
              FreeAndNil(CfgHint);
            end;
          finally
            FreeAndNil(SectionKeys);
          end;
        end;
      finally
        FreeAndNil(Sections);
      end;
    finally
      FreeAndNil(IniFile);
    end;
  except
    on E: Exception do
      Exception.Create(Format('Došlo k chybě při načítání hintů! Chyba: "%s", "%s".', [E.ClassName, E.Message]));
  end;
end;

function TCfgHintHandler.Description(const ACommandName: string): string;
var
  i: integer;
begin
  Result := '';
  try
    for i := 0 to FCfgHintList.Count - 1 do
    begin
      if SameText(FCfgHintList.Items[i].CommandName, ACommandName) then
      begin
        Result := FCfgHintList.Items[i].CommandDescription;
        Exit;
      end;
    end;
  except
    Result := '';
  end;
end;

function TCfgHintHandler.Hint(const ACommandName: string): string;
var
  i: integer;
begin
  Result := '';
  try
    for i := 0 to FCfgHintList.Count - 1 do
    begin
      if SameText(FCfgHintList.Items[i].CommandName, ACommandName) then
      begin
        Result := FCfgHintList.Items[i].CommandHint;
        Exit;
      end;
    end;
  except
    Result := '';
  end;
end;

{ TCfgHintList }

function TCfgHintList.GetItem(Index: integer): TCfgHint;
begin
  Result := nil;
  if (Index >= 0) and (Index < Self.Count) then
    Result := TCfgHint(inherited Items[Index]);
end;

destructor TCfgHintList.Destroy;
begin
  Self.Clear;
  inherited Destroy;
end;

procedure TCfgHintList.Clear;
var
  i: integer;
begin
  for i := Self.Count - 1 downto 0 do
    Self.Items[i].Free;
  inherited Clear;
end;

end.


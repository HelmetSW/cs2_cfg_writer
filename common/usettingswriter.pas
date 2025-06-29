unit uSettingsWriter;

{$mode objfpc}{$H+}

interface

uses
  Classes
  , SysUtils
  , IniFiles
  // , Graphics
  ;

type

  { TSettingsValues }

  TSettingsValues = class
  private
    FIniFile: TIniFile;
    FGlobalSectionName: string;
    FKeyName: string;
  private
    function GetAsBoolean: boolean;
    function GetAsDateTime: TDateTime;
    function GetAsInteger: integer;
    function GetAsString: string;
    function GetAsFloat: double;
    function GetAsBinaryStream: TStream;
    // function GetAsFont: TFont;
    procedure SetAsBoolean(AValue: boolean);
    procedure SetAsDateTime(AValue: TDateTime);
    procedure SetAsFloat(AValue: double);
    procedure SetAsInteger(AValue: integer);
    procedure SetAsString(AValue: string);
    procedure SetAsBinaryStream(AValue: TStream);
    // procedure SetAsFont(AValue: TFont);
  public
    constructor Create(const AGlobalSectionName, AIniFileName, AKeyName: string);
    destructor Destroy; override;
    property AsString: string read GetAsString write SetAsString;
    property AsInteger: integer read GetAsInteger write SetAsInteger;
    property AsBoolean: boolean read GetAsBoolean write SetAsBoolean;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsFloat: double read GetAsFloat write SetAsFloat;
    property AsBinaryStream: TStream read GetAsBinaryStream write SetAsBinaryStream;
    // property AsFont: TFont read GetAsFont write SetAsFont;
  end;

  TSettings = class
  private
    FValues: TSettingsValues;
    FGlobalSectionName: string;
    FIniFileName: string;
    function GetValue(KeyName: string): TSettingsValues;
  public
    constructor Create(const AGlobalSectionName, AIniFileName: string);
    destructor Destroy; override;
    property Value[KeyName: string]: TSettingsValues read GetValue;
  end;

var
  Settings: TSettings;

implementation

{ TSettings }

function TSettings.GetValue(KeyName: string): TSettingsValues;
begin
  FreeAndNil(FValues);
  Result := TSettingsValues.Create(FGlobalSectionName, FIniFileName, KeyName);
end;

constructor TSettings.Create(const AGlobalSectionName, AIniFileName: string);
begin
  inherited Create;
  FGlobalSectionName := AGlobalSectionName;
  FIniFileName := AIniFileName;
end;

destructor TSettings.Destroy;
begin
  FreeAndNil(FValues);
  inherited Destroy;
end;

{ TSettingsValues }

function TSettingsValues.GetAsBinaryStream: TStream;
begin
  Result := nil;
  FIniFile.ReadBinaryStream(FGlobalSectionName, FKeyName, Result);
end;

function TSettingsValues.GetAsBoolean: boolean;
begin
  Result := FIniFile.ReadBool(FGlobalSectionName, FKeyName, False);
end;

function TSettingsValues.GetAsDateTime: TDateTime;
begin
  Result := FIniFile.ReadDateTime(FGlobalSectionName, FKeyName, 0);
end;

function TSettingsValues.GetAsFloat: double;
begin
  Result := FIniFile.ReadFloat(FGlobalSectionName, FKeyName, 0);
end;

function TSettingsValues.GetAsInteger: integer;
begin
  Result := FIniFile.ReadInteger(FGlobalSectionName, FKeyName, 0);
end;

function TSettingsValues.GetAsString: string;
begin
  Result := FIniFile.ReadString(FGlobalSectionName, FKeyName, '');
end;

procedure TSettingsValues.SetAsBinaryStream(AValue: TStream);
begin
  FIniFile.ReadBinaryStream(FGlobalSectionName, FKeyName, AValue);
end;

procedure TSettingsValues.SetAsBoolean(AValue: boolean);
begin
  FIniFile.WriteBool(FGlobalSectionName, FKeyName, AValue);
end;

procedure TSettingsValues.SetAsDateTime(AValue: TDateTime);
begin
  FIniFile.WriteDateTime(FGlobalSectionName, FKeyName, AValue);
end;

procedure TSettingsValues.SetAsFloat(AValue: double);
begin
  FIniFile.WriteFloat(FGlobalSectionName, FKeyName, AValue);
end;

procedure TSettingsValues.SetAsInteger(AValue: integer);
begin
  FIniFile.WriteInteger(FGlobalSectionName, FKeyName, AValue);
end;

procedure TSettingsValues.SetAsString(AValue: string);
begin
  FIniFile.WriteString(FGlobalSectionName, FKeyName, AValue);
end;

constructor TSettingsValues.Create(const AGlobalSectionName, AIniFileName, AKeyName: string);
begin
  inherited Create;
  FGlobalSectionName := AGlobalSectionName;
  FKeyName := AKeyName;
  FIniFile := TIniFile.Create(AIniFileName
    , TEncoding.UTF8
    , True
    , [
       ifoStripComments
       , ifoStripInvalid
       , ifoEscapeLineFeeds
       , ifoStripQuotes
       , ifoFormatSettingsActive
      ]
    );
  FIniFile.WriteBOM := True;
end;

destructor TSettingsValues.Destroy;
begin
  FreeAndNil(FIniFile);
  inherited Destroy;
end;

end.


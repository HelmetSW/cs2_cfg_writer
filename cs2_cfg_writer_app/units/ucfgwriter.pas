{------------------------------------------------------------------------------

Priklad cesty k souboru autoexec.cfg:
c:\Program Files (x86)\Steam\steamapps\common\Counter-Strike Global Offensive\game\csgo\cfg\

Zapis a cteni ze souboru xxxxx.cfg.

zaklad je nazev klice a za mezerou hodnota klice
nepodporuje groupy
(nema rovnitko jako .ini souboru)

zatím vždy ukládáme s "" okolo hodnoty - TODO: parametrizovat

-------------------------------------------------------------------------------}
unit uCfgWriter;

{$mode ObjFPC}{$H+}

{.$DEFINE DEBUG}

interface

uses
  Classes, SysUtils;

type

  { TCfgFileValues }

  TCfgFileValues = class(TStringList)
  end;

  { TCfgFileKey }

  TCfgFileKey = class
  private
    FName: string;
    FValues: TCfgFileValues;
    FDescription: string;
    function GetIsComment: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property Name: string read FName write FName;
    property Values: TCfgFileValues read FValues write FValues;
    property Description: string read FDescription;
    property IsComment: boolean read GetIsComment;
  end;

  { TCfgFileKeyList }

  TCfgFileKeyList = class(TList)
  private
    function GetItem(Index: integer): TCfgFileKey;
  public
    destructor Destroy; override;
    procedure AssignEx(ASource: TCfgFileKeyList);
    function GetIndex(const AKey: string): integer;
    procedure Clear; override;
    procedure AddItem(const AKey, AValue: string);
    procedure AddValue(const AIndex: integer; const AValue: string);
    procedure UpdateValue(const AIndex, AValueIndex: integer; AValue: string);
    procedure DeleteValue(const AIndex, AValueIndex: integer);
    property Items[Index: integer]: TCfgFileKey read GetItem; default;
  end;

  { TCfgWriter }

  TCfgWriter = class
  public
    class function IsComment(const AString: string): boolean;
    class procedure LoadFromFile(const AFileName: string; ACfgFileKeyList: TCfgFileKeyList);
    class procedure SaveToFile(const AFileName: string; ACfgFileKeyList: TCfgFileKeyList);
  end;

implementation

uses
  uCfgHintHandler;

const
  COMMENT = '//';
  SEPARATOR = ' ';
  QUOTES = '"';

{ TCfgWriter }

class function TCfgWriter.IsComment(const AString: string): boolean;
begin
  Result := True
    and (Length(AString) > 0)
    and (Copy(AString, 1, 2) = COMMENT)
    ;
end;

class procedure TCfgWriter.LoadFromFile(const AFileName: string; ACfgFileKeyList: TCfgFileKeyList);

  procedure CreateAndAddKey(ACfgFileKeyList: TCfgFileKeyList; const AName: string; const AValues: string; const ADescription: string);
  var
    CfgFileKey: TCfgFileKey;
    Values: TStringArray;
    s, Value: string;
  begin
    CfgFileKey := TCfgFileKey.Create;
    try
      CfgFileKey.Name := AName;
      if TCfgWriter.IsComment(AName) then
      begin
       CfgFileKey.Values.Text := AValues;
      end
      else
      begin
        Values := AValues.Split(SEPARATOR, QUOTES);
        for Value in Values do
        begin
          s := Trim(StringReplace(Value, QUOTES, '', [rfReplaceAll]));
          if s <> '' then
            CfgFileKey.Values.Add(s);
        end;
      end;
      CfgFileKey.FDescription := ADescription;
      ACfgFileKeyList.Add(CfgFileKey);
    except
      FreeAndNil(CfgFileKey);
    end;
  end;

var
  FileContent: TStringList;
  i, SeparIndex: integer;
  Line, KeyName, KeyValues: string;
  CfgHintHandler: TCfgHintHandler;
begin
  ACfgFileKeyList.Clear;
  FileContent := TStringList.Create;
  try
    FileContent.LoadFromFile(AFileName);
    CfgHintHandler := TCfgHintHandler.Create;
    try
      for i := 0 to Pred(FileContent.Count) do
      begin
        Line := Trim(FileContent[i]);
        SeparIndex := Pos(SEPARATOR, Line);
        KeyName := Copy(Line, 1, SeparIndex - 1);
        KeyValues := Trim(Copy(Line, SeparIndex, Length(Line)));
        if KeyName <> '' then
          CreateAndAddKey(ACfgFileKeyList, KeyName, KeyValues, CfgHintHandler.Description(KeyName));
      end;
    finally
      FreeAndNil(CfgHintHandler);
    end;
  finally
    FreeAndNil(FileContent);
  end;
end;

class procedure TCfgWriter.SaveToFile(const AFileName: string; ACfgFileKeyList: TCfgFileKeyList);
var
  i, j: integer;
  FileContent: TStringList;
  Values: string;
begin
  FileContent := TStringList.Create;
  try
    for i := 0 to Pred(ACfgFileKeyList.Count) do
    begin
      Values := '';
      for j := 0 to ACfgFileKeyList.Items[i].Values.Count - 1 do
      begin
        if TCfgWriter.IsComment(ACfgFileKeyList.Items[i].Name) then
        begin
          Values := Values + ACfgFileKeyList.Items[i].Values[j];
        end
        else
        begin
          if Values <> '' then
            Values := Values + SEPARATOR + ACfgFileKeyList.Items[i].Values[j].QuotedString(QUOTES)
          else
            Values := ACfgFileKeyList.Items[i].Values[j].QuotedString(QUOTES);
        end;
      end;
      FileContent.Add(ACfgFileKeyList.Items[i].Name + SEPARATOR + Values);
    end;
    FileContent.SaveToFile(AFileName);
  finally
    FreeAndNil(FileContent);
  end;
end;

{ TCfgFileKey }

function TCfgFileKey.GetIsComment: boolean;
begin
  Result := TCfgWriter.IsComment(Self.Name);
end;

constructor TCfgFileKey.Create;
begin
  FValues := TCfgFileValues.Create;
end;

destructor TCfgFileKey.Destroy;
begin
  FreeAndNil(FValues);
  inherited Destroy;
end;

{ TCfgFileKeyList }

function TCfgFileKeyList.GetItem(Index: integer): TCfgFileKey;
begin
  Result := nil;
  if (Index >= 0) and (Index < Count) then
    Result := TCfgFileKey(inherited Items[Index]);
end;

destructor TCfgFileKeyList.Destroy;
begin
  Self.Clear;
  inherited Destroy;
end;

procedure TCfgFileKeyList.AssignEx(ASource: TCfgFileKeyList);
var
  i, v: integer;
  CfgFileKey: TCfgFileKey;
  Name, Value, Description: string;
begin
  if ASource = nil then
    Exit;
  for i := 0 to ASource.Count - 1 do
  begin
    Name := ASource.Items[i].Name;
    Description := ASource.Items[i].Description;
    CfgFileKey := TCfgFileKey.Create;
    try
      CfgFileKey.Name := Name;
      CfgFileKey.FDescription := Description;
      for v := 0 to ASource.Items[i].Values.Count - 1 do
      begin
        Value := ASource.Items[i].Values[v];
        CfgFileKey.Values.Add(Value);
      end;
      Self.Add(CfgFileKey);
    except
      FreeAndNil(CfgFileKey);
    end;
  end;
end;

function TCfgFileKeyList.GetIndex(const AKey: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to Self.Count - 1 do
  begin
    if CompareText(Self[i].Name, AKey) = 0 then
    begin
      Result := IndexOf(Self[i]);
      Exit;
    end;
  end;
end;

procedure TCfgFileKeyList.Clear;
var
  i: integer;
begin
  for i := Self.Count - 1 downto 0 do
    Self.Items[i].Free;
  inherited Clear;
end;

procedure TCfgFileKeyList.AddItem(const AKey, AValue: string);
var
  CfgFileKey: TCfgFileKey;
begin
  CfgFileKey := TCfgFileKey.Create;
  try
    CfgFileKey.Name := AKey;
    if AValue <> '' then
      CfgFileKey.Values.Add(AValue);
    Self.Add(CfgFileKey);
  except
    FreeAndNil(CfgFileKey);
  end;
end;

procedure TCfgFileKeyList.AddValue(const AIndex: integer; const AValue: string);
begin
  if (AIndex < 0) and (AIndex > Count) then
    Exit;

  if Trim(AValue) = '' then
    Exit;

  Self.Items[AIndex].Values.Add(AValue);
end;

procedure TCfgFileKeyList.UpdateValue(const AIndex, AValueIndex: integer; AValue: string);
begin
  if (AIndex < 0) and (AIndex > Self.Count) then
    Exit;

  if (AValueIndex < 0) and (AValueIndex > Self.Items[AIndex].Values.Count) then
    Exit;

  Self.Items[AIndex].Values[AValueIndex] := AValue;
end;

procedure TCfgFileKeyList.DeleteValue(const AIndex, AValueIndex: integer);
begin
  if (AIndex < 0) and (AIndex > Self.Count) then
    Exit;

  if (AValueIndex < 0) and (AValueIndex > Self.Items[AIndex].Values.Count) then
    Exit;

  Self.Items[AIndex].Values.Delete(AValueIndex);
end;

end.


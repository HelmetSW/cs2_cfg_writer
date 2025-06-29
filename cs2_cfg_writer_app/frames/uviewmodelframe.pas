unit uViewmodelFrame;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Spin, StdCtrls, uCfgWriter;

type

  { TFrameViewmodel }

  TFrameViewmodel = class(TFrame)
    cbViewmodelPresetpos: TComboBox;
    edtFOV: TSpinEdit;
    edtViewmodelX: TFloatSpinEdit;
    edtViewmodelY: TFloatSpinEdit;
    edtViewmodelZ: TFloatSpinEdit;
    gbViewModel: TGroupBox;
    lblFOV: TLabel;
    lblViewmodelPresetpos: TLabel;
    lblViewmodelX: TLabel;
    lblViewmodelY: TLabel;
    lblViewmodelZ: TLabel;
  protected
    procedure SetupHints;
    procedure ModifyKeyValue(ACfgFileKeyList: TCfgFileKeyList; const AKey, AValue: string);
    function GetKeyValue(ACfgFileKeyList: TCfgFileKeyList; const AKey: string): string;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure DataToFrame(ACfgFileKeyList: TCfgFileKeyList);
    procedure FrameToData(ACfgFileKeyList: TCfgFileKeyList);
  end;

implementation

uses
  uGlobalConstants, uCfgHintHandler;

const
  FOV_DEF_VAL = 54;
  VIEWMODEL_OFFSET_X_DEF_VAL = 2.5;
  VIEWMODEL_OFFSET_Y_DEF_VAL = -2;
  VIEWMODEL_OFFSET_Z_DEF_VAL = -2;
  VIEWMODEL_PRESETPOS_DEF_VAL = 1;

{$R *.lfm}

{ TFrameViewmodel }

procedure TFrameViewmodel.SetupHints;
var
  CfgHintHandler: TCfgHintHandler;
begin
  CfgHintHandler := TCfgHintHandler.Create;
  try
    CfgHintHandler.Refresh;
    lblFOV.Hint := CfgHintHandler.Hint(CFG_FOV);
    lblViewmodelX.Hint := CfgHintHandler.Hint(CFG_VIEWMODEL_OFFSET_X);
    lblViewmodelY.Hint := CfgHintHandler.Hint(CFG_VIEWMODEL_OFFSET_Y);
    lblViewmodelZ.Hint := CfgHintHandler.Hint(CFG_VIEWMODEL_OFFSET_Z);
    lblViewmodelPresetpos.Hint := CfgHintHandler.Hint(CFG_VIEWMODEL_PRESETPOS);
    edtFOV.Hint := lblFOV.Hint;
    edtViewmodelX.Hint := lblViewmodelX.Hint;
    edtViewmodelY.Hint := lblViewmodelY.Hint;
    edtViewmodelZ.Hint := lblViewmodelZ.Hint;
    cbViewmodelPresetpos.Hint := lblViewmodelPresetpos.Hint;
  finally
    FreeAndNil(CfgHintHandler);
  end;
end;

procedure TFrameViewmodel.ModifyKeyValue(ACfgFileKeyList: TCfgFileKeyList; const AKey, AValue: string);
var
  Index: integer;
begin
  Index := ACfgFileKeyList.GetIndex(AKey);
  if Index < 0 then
    ACfgFileKeyList.AddItem(AKey, AValue)
  else
    ACfgFileKeyList.UpdateValue(index, 0, AValue);
end;

function TFrameViewmodel.GetKeyValue(ACfgFileKeyList: TCfgFileKeyList; const AKey: string): string;
var
  Index: integer;
begin
  Result := '';
  Index := ACfgFileKeyList.GetIndex(AKey);
  if Index > -1 then
    Result := ACfgFileKeyList.Items[Index].Values[0];
end;

constructor TFrameViewmodel.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  SetupHints;
end;

procedure TFrameViewmodel.DataToFrame(ACfgFileKeyList: TCfgFileKeyList);
begin
  if ACfgFileKeyList = nil then
    Exit;
  {
  edtFOV.Value := FOV_DEF_VAL;
  edtViewmodelX.Value := VIEWMODEL_OFFSET_X_DEF_VAL;
  edtViewmodelY.Value := VIEWMODEL_OFFSET_Y_DEF_VAL;
  edtViewmodelZ.Value := VIEWMODEL_OFFSET_Z_DEF_VAL;
  cbViewmodelPresetpos.ItemIndex := VIEWMODEL_PRESETPOS_DEF_VAL;
  }
  edtFOV.Value := StrToIntDef(GetKeyValue(ACfgFileKeyList, CFG_FOV), FOV_DEF_VAL);
  edtViewmodelX.Value := StrToFloatDef(GetKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_X), VIEWMODEL_OFFSET_X_DEF_VAL);
  edtViewmodelY.Value := StrToFloatDef(GetKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_Y), VIEWMODEL_OFFSET_Y_DEF_VAL);
  edtViewmodelZ.Value := StrToFloatDef(GetKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_Z), VIEWMODEL_OFFSET_Z_DEF_VAL);
  cbViewmodelPresetpos.ItemIndex := StrToIntDef(GetKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_PRESETPOS), VIEWMODEL_PRESETPOS_DEF_VAL) - 1;
end;

procedure TFrameViewmodel.FrameToData(ACfgFileKeyList: TCfgFileKeyList);
begin
  if ACfgFileKeyList = nil then
    Exit;

  ModifyKeyValue(ACfgFileKeyList, CFG_FOV, FloatToStr(edtFOV.Value));
  ModifyKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_X, FloatToStr(edtViewmodelX.Value));
  ModifyKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_Y, FloatToStr(edtViewmodelY.Value));
  ModifyKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_OFFSET_Z, FloatToStr(edtViewmodelZ.Value));
  ModifyKeyValue(ACfgFileKeyList, CFG_VIEWMODEL_PRESETPOS, IntToStr(cbViewmodelPresetpos.ItemIndex + 1));
end;



end.


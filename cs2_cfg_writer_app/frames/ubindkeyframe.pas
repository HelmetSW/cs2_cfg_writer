unit uBindKeyFrame;

{$mode ObjFPC}{$H+}

interface

uses
  uCfgCommand, uCfgWriter,
  Classes, SysUtils, Forms, Controls, StdCtrls, ActnList, ExtCtrls, Dialogs;

type

  { TFrameBindKey }

  TFrameBindKey = class(TFrame)
    actAdd: TAction;
    actScanKey: TAction;
    ActsList: TActionList;
    BtnScanKey: TButton;
    btnAdd: TButton;
    lblUserDefinedBinds: TLabel;
    lblCommands: TLabel;
    ListBox1: TListBox;
    ListBoxCommands: TListBox;
    procedure actScanKeyExecute(Sender: TObject);
  private
    procedure FillListBoxWithCommands(AListBox: TListBox);
  public
    constructor Create(TheOwner: TComponent); override;
    procedure DataToFrame(ACfgFileKeyList: TCfgFileKeyList);
    procedure FrameToData(ACfgFileKeyList: TCfgFileKeyList);
  end;

implementation

{$R *.lfm}

{ TFrameBindKey }

procedure TFrameBindKey.actScanKeyExecute(Sender: TObject);
var
  ch : char;
begin
  //ch := ReadKey;
end;

procedure TFrameBindKey.FillListBoxWithCommands(AListBox: TListBox);
var
  CfgCommand: TCfgCommand;
begin
  for CfgCommand in CfgCommands do
    AListBox.Items.AddObject(CfgCommand.Name, CfgCommand);
end;

constructor TFrameBindKey.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  //
end;

procedure TFrameBindKey.DataToFrame(ACfgFileKeyList: TCfgFileKeyList);
begin
  if ACfgFileKeyList = nil then
    Exit;

  FillListBoxWithCommands(ListBoxCommands);
end;

procedure TFrameBindKey.FrameToData(ACfgFileKeyList: TCfgFileKeyList);
begin
  if ACfgFileKeyList = nil then
    Exit;

end;

end.


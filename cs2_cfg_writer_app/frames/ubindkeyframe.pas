unit uBindKeyFrame;

{$mode ObjFPC}{$H+}

interface

{$INCLUDE global_directives.inc}

uses
  uCommandListFrame,
  Classes, SysUtils, Forms, Controls, StdCtrls, ActnList, ExtCtrls, Dialogs;

type

  { TFrameBindKey }

  TFrameBindKey = class(TFrame)
    actAdd: TAction;
    actSelectKey: TAction;
    ActsList: TActionList;
    BtnScanKey: TButton;
    btnAdd: TButton;
    FrmCommandList: TFrameCommandList;
    lblUserDefinedBinds: TLabel;
    lblCommands: TLabel;
    ListBoxNewBinds: TListBox;
    procedure actAddExecute(Sender: TObject);
    procedure actSelectKeyExecute(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
  end;

implementation

{$R *.lfm}

{ TFrameBindKey }

procedure TFrameBindKey.actSelectKeyExecute(Sender: TObject);
//var
  //ch : char;
begin
  //ch := ReadKey;
end;

procedure TFrameBindKey.actAddExecute(Sender: TObject);
var
  lSelectedCfgCommand: string;
begin
  lSelectedCfgCommand := FrmCommandList.SelectedCfgCommand;
  if lSelectedCfgCommand <> '' then
    ListBoxNewBinds.Items.Add(lSelectedCfgCommand);
end;

constructor TFrameBindKey.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  //
end;

end.


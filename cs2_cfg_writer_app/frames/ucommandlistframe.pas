unit uCommandListFrame;

{$mode ObjFPC}{$H+}

interface

{$INCLUDE global_directives.inc}

uses
  Classes, SysUtils, Forms, Controls, ActnList, StdCtrls, ExtCtrls;

type

  { TFrameCommandList }

  TFrameCommandList = class(TFrame)
    actSelect: TAction;
    ListBoxCommands: TListBox;
    PanelBottom: TPanel;
  private
    FSelectedCfgCommand: string;
    function GetSelectedCfgCommand: string;
  protected
    procedure FillListBox;
  public
    constructor Create(TheOwner: TComponent); override;
    property SelectedCfgCommand: string read GetSelectedCfgCommand;
  end;

implementation

uses
  uCfgCommand
  ;

{$R *.lfm}

{ TFrameCommandList }

function TFrameCommandList.GetSelectedCfgCommand: string;
begin
  Result := ListBoxCommands.Items[ListBoxCommands.ItemIndex];
end;

procedure TFrameCommandList.FillListBox;
var
  CfgCommand: TCfgCommand;
begin
  for CfgCommand in CfgCommands do
    ListBoxCommands.Items.AddObject(CfgCommand.Name, CfgCommand);
end;

constructor TFrameCommandList.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FillListBox;
end;

end.


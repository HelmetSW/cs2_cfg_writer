unit uViewmodelForm;

{$mode ObjFPC}{$H+}

interface

{$INCLUDE global_directives.inc}

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ActnList, ComCtrls, uViewmodelFrame, uCfgWriter;

type

  { TFormViewmodel }

  TFormViewmodel = class(TForm)
    actClose: TAction;
    actSave: TAction;
    ActsList: TActionList;
    btnClose: TButton;
    btnOk: TButton;
    FrmViewmodel: TFrameViewmodel;
    PanelBottom: TPanel;
    PanelClient: TPanel;
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCfgFileKeyList: TCfgFileKeyList;
  public
    class function Execute(ACfgFileKeyList: TCfgFileKeyList): boolean;
    property CfgFileKeyList: TCfgFileKeyList read FCfgFileKeyList write FCfgFileKeyList;
  end;

implementation

{$R *.lfm}

{ TFormViewmodel }

procedure TFormViewmodel.actSaveExecute(Sender: TObject);
begin
  FrmViewmodel.FrameToData(CfgFileKeyList);
  ModalResult := mrOk;
end;

procedure TFormViewmodel.FormShow(Sender: TObject);
begin
  FrmViewmodel.DataToFrame(CfgFileKeyList);
end;

procedure TFormViewmodel.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrClose;
end;

class function TFormViewmodel.Execute(ACfgFileKeyList: TCfgFileKeyList): boolean;
var
  FormViewmodel: TFormViewmodel;
begin
  FormViewmodel := TFormViewmodel.Create(nil);
  try
    FormViewmodel.CfgFileKeyList := ACfgFileKeyList;
    Result := (FormViewmodel.ShowModal = mrOk);
  finally
    FreeAndNil(FormViewmodel);
  end;
end;

end.


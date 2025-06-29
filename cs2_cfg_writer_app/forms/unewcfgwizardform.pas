unit uNewCfgWizardForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ActnList, uViewmodelFrame, uBindKeyFrame, uCfgWriter;

type

  { TFormNewCfgWizard }

  TFormNewCfgWizard = class(TForm)
    actClose: TAction;
    actOk: TAction;
    ActsList: TActionList;
    btnClose: TButton;
    btnOk: TButton;
    FrmBindKey: TFrameBindKey;
    FrmViewmodel: TFrameViewmodel;
    PanelHeader: TPanel;
    PanelBottom: TPanel;
    PanelViewmodel: TPanel;
    procedure actCloseExecute(Sender: TObject);
    procedure actOkExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FCfgFileKeyList: TCfgFileKeyList;
  public
    class function Execute(ACfgFileKeyList: TCfgFileKeyList): boolean;
    property CfgFileKeyList: TCfgFileKeyList read FCfgFileKeyList write FCfgFileKeyList;
  end;

implementation

{$R *.lfm}

{ TFormNewCfgWizard }

procedure TFormNewCfgWizard.actCloseExecute(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TFormNewCfgWizard.actOkExecute(Sender: TObject);
begin
  FrmViewmodel.FrameToData(CfgFileKeyList);
  ModalResult := mrOk;
end;

procedure TFormNewCfgWizard.FormShow(Sender: TObject);
begin
  FrmViewmodel.DataToFrame(CfgFileKeyList);
  FrmBindKey.DataToFrame(CfgFileKeyList);
end;

class function TFormNewCfgWizard.Execute(ACfgFileKeyList: TCfgFileKeyList): boolean;
var
  FormNewCfgWizard: TFormNewCfgWizard;
begin
  FormNewCfgWizard := TFormNewCfgWizard.Create(nil);
  try
    FormNewCfgWizard.CfgFileKeyList := ACfgFileKeyList;
    Result := (FormNewCfgWizard.ShowModal = mrOk);
  finally
    FreeAndNil(FormNewCfgWizard);
  end;
end;

end.


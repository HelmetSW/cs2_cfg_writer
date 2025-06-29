unit uSettingsForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, ActnList;

type

  { TSettingsForm }

  TSettingsForm = class(TForm)
    actSelectTreeViewFont: TAction;
    actSave: TAction;
    ActionList1: TActionList;
    btnSave: TButton;
    btnClose: TButton;
    btnTreeViewFont: TButton;
    cbAutoExpandTree: TCheckBox;
    cbRememberLastFileName: TCheckBox;
    cbSaveOnClose: TCheckBox;
    FontDlg: TFontDialog;
    PageControlMain: TPageControl;
    PanelBottom: TPanel;
    tsVisuals: TTabSheet;
    tsGeneral: TTabSheet;
    procedure actSaveExecute(Sender: TObject);
    procedure actSelectTreeViewFontExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FFTreeViewFontSize: integer;
    procedure Clear;
  public
    procedure Load;
    procedure Save;
  end;

implementation

uses
  uGlobalConstants, uSettingsWriter;

{$R *.lfm}

{ TSettingsForm }

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  Clear;
  Load;
end;

procedure TSettingsForm.Clear;
begin
  FFTreeViewFontSize := 0;
end;

procedure TSettingsForm.actSaveExecute(Sender: TObject);
begin
  Save;
end;

procedure TSettingsForm.actSelectTreeViewFontExecute(Sender: TObject);
begin
  if FFTreeViewFontSize  > 0 then
    FontDlg.Font.Size := FFTreeViewFontSize;

  if FontDlg.Execute then
    FFTreeViewFontSize := FontDlg.Font.Size;
end;

procedure TSettingsForm.Load;
begin
  cbAutoExpandTree.Checked := Settings.Value[SETT_AUTO_EXPAND_TREE_VIEW].AsBoolean;
  cbRememberLastFileName.Checked := Settings.Value[SETT_REMEMBER_LAST_FILE_NAME].AsBoolean;
  cbSaveOnClose.Checked := Settings.Value[SETT_AUTO_SAVE_ON_CLOSE].AsBoolean;
  FFTreeViewFontSize := Settings.Value[SETT_TREE_VIEW_FONT_SIZE].AsInteger;
end;

procedure TSettingsForm.Save;
begin
  Settings.Value[SETT_AUTO_EXPAND_TREE_VIEW].AsBoolean := cbAutoExpandTree.Checked;
  Settings.Value[SETT_REMEMBER_LAST_FILE_NAME].AsBoolean := cbRememberLastFileName.Checked;
  Settings.Value[SETT_AUTO_SAVE_ON_CLOSE].AsBoolean := cbSaveOnClose.Checked;
  Settings.Value[SETT_TREE_VIEW_FONT_SIZE].AsInteger := FFTreeViewFontSize;
end;

end.


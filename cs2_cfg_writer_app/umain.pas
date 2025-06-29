unit uMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus,
  ActnList, ComCtrls, StdCtrls, uCfgWriter, uCfgCommand;

type

  { TFormMain }

  TFormMain = class(TForm)
    actAddNewKey: TAction;
    actDeleteItem: TAction;
    actAddNewValue: TAction;
    actCloseFile: TAction;
    actExit: TAction;
    actEditViewmodel: TAction;
    actNewCfgWizard: TAction;
    actOpenNotePad: TAction;
    actOpenSettingsForm: TAction;
    actNewFile: TAction;
    actSaveFileAs: TAction;
    actSaveFile: TAction;
    actOpenFile: TAction;
    ActList: TActionList;
    btnAddNew: TButton;
    btnDelete: TButton;
    btnAddValue: TButton;
    edtCommandName: TEdit;
    FlowPanelEdits: TFlowPanel;
    MainMenu: TMainMenu;
    mmiNewCfgWizard: TMenuItem;
    mmiEditViewmodel: TMenuItem;
    mmiOpenNotePad: TMenuItem;
    mmiExit: TMenuItem;
    pmiDeleteItem: TMenuItem;
    pmiAddNewValue: TMenuItem;
    pmiAddNewKey: TMenuItem;
    mmiCloseFile: TMenuItem;
    mmiOpenSettingsForm: TMenuItem;
    mmiNewFile: TMenuItem;
    mmiSaveFileAs: TMenuItem;
    mmiSettings: TMenuItem;
    mmiSaveFile: TMenuItem;
    mmiOpenFile: TMenuItem;
    mmiFile: TMenuItem;
    OpenDlg: TOpenDialog;
    PanelBottom: TPanel;
    PanelTreeView: TPanel;
    PanelEdits: TPanel;
    PanelContainer: TPanel;
    PopupMenuTreeView: TPopupMenu;
    SaveDlg: TSaveDialog;
    Splitter1: TSplitter;
    StatusBarMain: TStatusBar;
    TreeCfgFileView: TTreeView;
    procedure actAddNewKeyExecute(Sender: TObject);
    procedure actAddNewValueExecute(Sender: TObject);
    procedure actDeleteItemExecute(Sender: TObject);
    procedure actCloseFileExecute(Sender: TObject);
    procedure actEditViewmodelExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actNewCfgWizardExecute(Sender: TObject);
    procedure actNewFileExecute(Sender: TObject);
    procedure actOpenNotePadExecute(Sender: TObject);
    procedure actOpenSettingsFormExecute(Sender: TObject);
    procedure actSaveFileAsExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure TreeCfgFileViewDblClick(Sender: TObject);
    procedure TreeCfgFileViewSelectionChanged(Sender: TObject);
  private
    FFileName: string;
    FCfgFileKeyList: TCfgFileKeyList;
    procedure SetFileName(AValue: string);
    procedure Reload;
    procedure Clear(const AReload: boolean);
  protected
    property FileName: string read FFileName write SetFileName;
  end;

var
  FormMain: TFormMain;

implementation

uses
  windows,
  uNewCfgWizardForm,
  uGlobalConstants, uSettingsForm, uSettingsWriter, uViewmodelForm;

type
  TNodeData = class
  private
    FIndex: integer;
    FIsKey: boolean;
  public
    property Index: integer read FIndex write FIndex;
    property IsKey: boolean read FIsKey write FIsKey;
  end;

const
  MSG_SAVE_TO_FILE_ERROR = 'Došlo k chybě při ukládání souboru!'#13#10'%s';
  MSG_SAVE_BEFORE_ACTION = 'Chcete možné změny v tomto souboru napřed uložit?';

{$R *.lfm}

{ TFormMain }

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FFileName := '';
  FCfgFileKeyList := TCfgFileKeyList.Create;
  LoadCommands;
  Settings := TSettings.Create(
    'Settings'
    , IncludeTrailingPathDelimiter(SysUtils.GetEnvironmentVariable('appdata'))
      + IncludeTrailingPathDelimiter(ApplicationName)
      + SETT_SETTINGS_FILE_NAME
    );
end;

procedure TFormMain.actSaveFileExecute(Sender: TObject);
begin
  if (FileName = '') then
  begin
    if (TreeCfgFileView.Items.Count > 0) then
      actSaveFileAs.Execute;
  end
  else
  begin
    try
      TCfgWriter.SaveToFile(FileName, FCfgFileKeyList);
    except
      on E: Exception do
        MessageDlg('Error', Format(MSG_SAVE_TO_FILE_ERROR, [E.Message]), mtError, [mbOk], '');
    end;
  end;
end;

procedure TFormMain.actAddNewKeyExecute(Sender: TObject);
var
  NewKeyName: string;
begin
  NewKeyName := '';
  if InputQuery('Zadejte název příkazu', '', NewKeyName) then
  begin
    if Trim(NewKeyName) = '' then
    begin
      MessageDlg('Upozornění', 'Hodnota nesmí být prázdná!', mtWarning, [mbOK], '');
      Exit;
    end;
    FCfgFileKeyList.AddItem(NewKeyName, '');
    Reload;
  end;
end;

procedure TFormMain.actAddNewValueExecute(Sender: TObject);
var
  NewValue: string;
  Node: TTreeNode;
begin
  Node := TreeCfgFileView.Selected;

  if Node = nil then
    Exit;

  if TNodeData(Node.Data) = nil then
    Exit;

  if not TNodeData(Node.Data).IsKey then
    Exit;

  NewValue := '';
  if InputQuery('Zadejte hodnotu', '', NewValue) then
  begin
    FCfgFileKeyList.AddValue(TNodeData(Node.Data).Index, NewValue);
    Reload;
  end;
end;

procedure TFormMain.actDeleteItemExecute(Sender: TObject);
var
  Node: TTreeNode;
begin
  Node := TreeCfgFileView.Selected;
  if Node = nil then
    Exit;

  if TNodeData(Node.Data) = nil then
    Exit;

  if not TNodeData(Node.Data).IsKey then
    FCfgFileKeyList.DeleteValue(Node.Parent.Index, TNodeData(Node.Data).Index)
  else
    FCfgFileKeyList.Delete(TNodeData(Node.Data).Index);
  Reload;
end;

procedure TFormMain.actCloseFileExecute(Sender: TObject);
begin
  if Settings.Value[SETT_AUTO_SAVE_ON_CLOSE].AsBoolean then
    actSaveFile.Execute;
  FileName := '';
  FCfgFileKeyList.Clear;
  Reload;
end;

procedure TFormMain.actEditViewmodelExecute(Sender: TObject);
begin
  if TFormViewmodel.Execute(FCfgFileKeyList) then
    Reload;
end;

procedure TFormMain.actExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.actNewCfgWizardExecute(Sender: TObject);
var
  lCfgFileKeyList: TCfgFileKeyList;
begin
  if True
    and (FileName <> '')
    and (TreeCfgFileView.Items.Count > 0)
    and (MessageDlg('Dotaz', MSG_SAVE_BEFORE_ACTION, mtConfirmation, [mbYes, mbNo], '') = mrYes)
  then
    actSaveFile.Execute;

  lCfgFileKeyList := TCfgFileKeyList.Create;
  try
    if TFormNewCfgWizard.Execute(lCfgFileKeyList) then
    begin
      Self.Clear(False);
      FCfgFileKeyList.AssignEx(lCfgFileKeyList);
      actSaveFileAs.Execute;
    end;
    Reload;
  finally
    FreeAndNil(lCfgFileKeyList);
  end;
end;

procedure TFormMain.actNewFileExecute(Sender: TObject);
begin
  if FileName <> '' then
  begin
    if Settings.Value[SETT_AUTO_SAVE_ON_CLOSE].AsBoolean then
      actSaveFile.Execute
    else if MessageDlg('Dotaz', MSG_SAVE_BEFORE_ACTION, mtConfirmation, [mbYes, mbNo], '') = mrYes then
      actSaveFile.Execute;
  end;
  Self.Clear(True);
end;

procedure TFormMain.actOpenNotePadExecute(Sender: TObject);
begin
  if FileName = '' then
    Exit;
  if not FileExists(FileName) then
    Exit;
  if MessageDlg('Dotaz', MSG_SAVE_BEFORE_ACTION, mtConfirmation, [mbYes, mbNo], '') = mrYes then
    actSaveFile.Execute;
  ShellExecute(0, 'open', PChar(FileName), nil, nil, SW_SHOWNORMAL);
end;

procedure TFormMain.actOpenSettingsFormExecute(Sender: TObject);
var
  SettingsForm: TSettingsForm;
begin
  SettingsForm := TSettingsForm.Create(Self);
  try
    SettingsForm.ShowModal;
    TreeCfgFileView.Font.Size := Settings.Value[SETT_TREE_VIEW_FONT_SIZE].AsInteger;
  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TFormMain.actSaveFileAsExecute(Sender: TObject);
var
  InitDir: string;
begin
  if FileName = '' then
  begin
    InitDir := ExtractFileDir(Paramstr(0));
  end
  else
  begin
    InitDir := ExtractFileDir(FileName);
  end;

  SaveDlg.InitialDir := InitDir;
  if SaveDlg.Execute then
  begin
    FFileName := SaveDlg.FileName;
    if Settings.Value[SETT_REMEMBER_LAST_FILE_NAME].AsBoolean then
      Settings.Value[SETT_LAST_FILE_NAME].AsString := SaveDlg.FileName;
    try
      TCfgWriter.SaveToFile(FileName, FCfgFileKeyList);
    except
      on E: Exception do
        MessageDlg('Error', Format(MSG_SAVE_TO_FILE_ERROR, [E.Message]), mtError, [mbOk], '');
    end;
  end;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  TreeCfgFileView.AutoExpand := Settings.Value[SETT_AUTO_EXPAND_TREE_VIEW].AsBoolean;
  if Settings.Value[SETT_REMEMBER_LAST_FILE_NAME].AsBoolean then
    FileName := Settings.Value[SETT_LAST_FILE_NAME].AsString;
  if Settings.Value[SETT_TREE_VIEW_FONT_SIZE].AsInteger > 0 then
    TreeCfgFileView.Font.Size := Settings.Value[SETT_TREE_VIEW_FONT_SIZE].AsInteger;
end;

procedure TFormMain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if True
    and (CloseAction = caFree)
    and Settings.Value[SETT_AUTO_SAVE_ON_CLOSE].AsBoolean
  then
    actSaveFile.Execute;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Settings);
  FreeAndNil(FCfgFileKeyList);
  FreeAndNil(CfgCommands);
end;

procedure TFormMain.actOpenFileExecute(Sender: TObject);
begin
  if OpenDlg.Execute then
    FileName := OpenDlg.FileName;
end;

procedure TFormMain.TreeCfgFileViewDblClick(Sender: TObject);
var
  Node, ParentNode: TTreeNode;
  NewValue: string;
begin
  Node := TreeCfgFileView.Selected;
  if Node = nil then
    Exit;

  if TNodeData(Node.Data).IsKey then
    Exit;

  NewValue := Node.Text;
  if InputQuery('Zadejte novou hodnotu', '', NewValue) then
  begin
    ParentNode := Node.Parent;
    if ParentNode <> nil then
      try
        FCfgFileKeyList.UpdateValue(ParentNode.Index, TNodeData(Node.Data).Index, NewValue);
      except
        MessageDlg('Error', 'Neznámý název příkazu, hodnotu nelze uložit!', mtError, [mbOK], '');
      end;
    Reload;
  end;
end;

procedure TFormMain.TreeCfgFileViewSelectionChanged(Sender: TObject);
var
  Node: TTreeNode;
begin
  edtCommandName.Text := '';
  StatusBarMain.Panels[0].Text := '';
  Node := TreeCfgFileView.Selected;
  if Node = nil then
    Exit;

  if not TNodeData(Node.Data).IsKey then
    Exit;
  try
   edtCommandName.Text := FCfgFileKeyList.Items[TNodeData(Node.Data).Index].Name;
   StatusBarMain.Panels[0].Text := FCfgFileKeyList.Items[TNodeData(Node.Data).Index].Description;
  except
   edtCommandName.Text := '';
   StatusBarMain.Panels[0].Text := '';
  end;
end;

procedure TFormMain.SetFileName(AValue: string);
begin
  FFileName := AValue;

  if FileName = '' then
    Exit;

  if not FileExists(FileName) then
    Exit;

  if Settings.Value[SETT_REMEMBER_LAST_FILE_NAME].AsBoolean then
    Settings.Value[SETT_LAST_FILE_NAME].AsString := FileName;

  try
    TCfgWriter.LoadFromFile(FileName, FCfgFileKeyList);
    Reload;
  except
    on E: Exception do
      MessageDlg('Error', Format('Došlo k chybě při načítání souboru!'#13#10'%s', [E.Message]), mtError, [mbOk], '');
  end;
end;

procedure TFormMain.Reload;
var
  i, j: integer;
  KeyNode, ValueNode: TTreeNode;
begin
  TreeCfgFileView.BeginUpdate;
  try
    TreeCfgFileView.Items.Clear;
    for i := 0 to Pred(FCfgFileKeyList.Count) do
    begin
      KeyNode := TreeCfgFileView.Items.Add(nil, FCfgFileKeyList.Items[i].Name);
      KeyNode.Data := TNodeData.Create;
      TNodeData(KeyNode.Data).Index := i;
      TNodeData(KeyNode.Data).IsKey := True;
      if FCfgFileKeyList.Items[i].IsComment then
        KeyNode.Visible := False;
      for j := 0 to Pred(FCfgFileKeyList.Items[i].Values.Count) do
      begin
        ValueNode := TreeCfgFileView.Items.AddChild(KeyNode, FCfgFileKeyList.Items[i].Values.Strings[j]);
        ValueNode.Data := TNodeData.Create;
        TNodeData(ValueNode.Data).Index := j;
        TNodeData(ValueNode.Data).IsKey := False;
      end;
    end;
  finally
    TreeCfgFileView.EndUpdate;
  end;
end;

procedure TFormMain.Clear(const AReload: boolean);
begin
  FileName := '';
  FCfgFileKeyList.Clear;
  if AReload then
    Reload;
end;

end.


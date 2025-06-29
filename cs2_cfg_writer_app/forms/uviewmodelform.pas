unit uViewmodelForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ActnList, Spin, ComCtrls, uViewmodelFrame, uCfgWriter;

type

  { TFormViewmodel }

  TFormViewmodel = class(TForm)
    actClose: TAction;
    actSave: TAction;
    ActsList: TActionList;
    btnClose: TButton;
    btnOk: TButton;
    FrmViewmodel: TFrameViewmodel;
    ImgPreview: TImage;
    PanelPreview: TPanel;
    PanelControls: TPanel;
    PanelBottom: TPanel;
    PanelClient: TPanel;
    Splitter1: TSplitter;
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditOnChange(Sender: TObject);
  private
    FCfgFileKeyList: TCfgFileKeyList;
  protected
    procedure DrawPreview;
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
  DrawPreview;
  FrmViewmodel.DataToFrame(CfgFileKeyList);
end;

procedure TFormViewmodel.EditOnChange(Sender: TObject);
begin
  DrawPreview;
end;

procedure TFormViewmodel.DrawPreview;

  procedure EraseCanvas(const AColor: TColor);
  begin
    ImgPreview.Canvas.Brush.Color := AColor;
    ImgPreview.Canvas.FillRect(0, 0, ImgPreview.ClientWidth, ImgPreview.ClientHeight);
  end;

  procedure DrawLine(const x, y: integer; const AColor: TColor);
  begin
    ImgPreview.Canvas.Pen.Color := AColor;
    ImgPreview.Canvas.Pen.Width := 2;
    ImgPreview.Canvas.LineTo(x, y);
  end;

  procedure DrawCross(PntCenter: TPoint; const crossDelka, crossSirka: integer; const AColor: TColor);
  begin
    ImgPreview.Canvas.MoveTo(0, PntCenter.Y);
    DrawLine(crossSirka, PntCenter.Y, AColor);
    ImgPreview.Canvas.MoveTo(PntCenter.X, 0);
    DrawLine(PntCenter.X, crossDelka, AColor);
  end;

  procedure DrawCrossOffset(PntCenter: TPoint; const offset_x, offset_y: Double; const crossDelka, crossSirka: integer);
  var
    PntCenterOffSet: TPoint;
    ioffset_x, ioffset_y: integer;
  begin
    ioffset_x := Round(offset_x * 10);
    ioffset_y := Round(offset_y * 10);
    // TODO: špatně počítá pro záporné hodnoty!
    // pro záporné číslo by měl jít kříž dolu a naopak!
    PntCenterOffSet := TPoint.Create(PntCenter.X + ioffset_x, PntCenter.Y + ioffset_y);
    DrawCross(PntCenterOffSet, crossDelka, crossSirka, clRed);
  end;

var
  PntCenter: TPoint;
begin
  PntCenter := TPoint.Create(ImgPreview.ClientWidth div 2, ImgPreview.ClientHeight div 2);
  EraseCanvas(clWhite);
  DrawCross(PntCenter, ImgPreview.ClientWidth, ImgPreview.ClientHeight, clGray);
  DrawCrossOffset(PntCenter, FrmViewmodel.edtViewmodelX.Value, FrmViewmodel.edtViewmodelZ.Value, ImgPreview.ClientWidth, ImgPreview.ClientHeight);
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


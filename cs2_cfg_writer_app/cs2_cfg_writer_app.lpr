program cs2_cfg_writer_app;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces
  , Forms
  , uMain
  , uSettingsWriter
  , uGlobalConstants
  , uCfgWriter
  , uSettingsForm
  , uCfgHintHandler
  , uViewmodelForm
  , uViewmodelFrame
  , uNewCfgWizardForm
  , uBindKeyFrame
  , uCfgCommand
  ;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'CS2ConfigWriterApp';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.


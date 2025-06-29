unit uGlobalConstants;

{$mode ObjFPC}{$H+}

interface

const
  // soubor CS2ConfigWriter.ini, vše v sekci [Settings]
  SETT_AUTO_EXPAND_TREE_VIEW = 'AutoExpandTreeView';
  SETT_REMEMBER_LAST_FILE_NAME = 'RememberLastFileName';
  SETT_LAST_FILE_NAME = 'LastFileName';
  SETT_AUTO_SAVE_ON_CLOSE = 'AutoSaveOnClose';
  SETT_TREE_VIEW_FONT_SIZE = 'TreeViewFontSize';
  SETT_COMMAND_HINT_FILE_NAME = 'CommandHintFileName';
  SETT_SETTINGS_FILE_NAME = 'CS2ConfigWriter.ini';

const
  // soubory
  COMMANDS_FILE_NAME = 'commands.ini';

const
  // soubor command_hints.ini, názvy klíčů
  COMMAND_HINTS_DESCRIPTION = 'description';
  COMMAND_HINTS_HINT = 'hint';

const
  // soubor commands.ini, názvy klíčů
  COMMANDS_DEFAULT = 'default';
  COMMANDS_DESCRIPTION = 'description';

const
  // soubory s příponou .cfg, příkazy a názvy které používáme
  // CFG_DEFAULT_FILE_NAME = 'autoexec.cfg';
  CFG_FOV = 'viewmodel_fov';
  CFG_VIEWMODEL_OFFSET_X = 'viewmodel_offset_x';
  CFG_VIEWMODEL_OFFSET_Y = 'viewmodel_offset_y';
  CFG_VIEWMODEL_OFFSET_Z = 'viewmodel_offset_z';
  CFG_VIEWMODEL_PRESETPOS = 'viewmodel_presetpos';
  CFG_BIND = 'bind';

implementation

end.


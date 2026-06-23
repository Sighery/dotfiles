{ inputs, ... }:

{
  programs.keepassxc = {
    enable = true;

    settings = {
      Browser = {
        Enabled = false;
        CustomProxyLocation = "";
      };

      General = {
        ConfigVersion = 2;

        # Ctrl + Alt + V
        GlobalAutoTypeKey = 86;
        GlobalAutoTypeModifiers = 201326592;

        AutoTypeHideExpiredEntry = true;

        BackupBeforeSave = true;
        BackupFilePathPattern = "{DB_FILENAME}.{TIME}.kdbx";
      };

      GUI = {
        ShowExpiredEntriesOnDatabaseUnlock = false;

        TrayIconAppearance = "monochrome-light";
      };
    } // inputs.dotfiles-secrets.extraKeepassxcSettings;
  };
}

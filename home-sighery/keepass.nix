{ inputs, ... }:

{
  programs.keepassxc = {
    enable = true;

    settings = {
      Browser.Enabled = false;

      General = {
        # Ctrl + Alt + V
        GlobalAutoTypeKey = 86;
        GlobalAutoTypeModifiers = 201326592;
        AutoTypeHideExpiredEntry = true;
      };

      GUI = {
        ShowExpiredEntriesOnDatabaseUnlock = false;
      };
    } // inputs.dotfiles-secrets.extraKeepassxcSettings;
  };
}

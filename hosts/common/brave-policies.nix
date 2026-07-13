{ config, lib, ... }:

let
  tampermonkeyId = "dhdgffkkebhmkfjojejmpbldmpobfkfo";
  personalTampermonkey = {
    hash = "1:46e827794a7fa698004f13edbd250f561d478869326260a5349bd4e23d4bcdae";
    url = "https://github.com/Sighery/dotfiles/raw/refs/heads/main/hosts/common/tampermonkey/tampermonkey-personal.json";
    haltOnError = false;
    installAsSystemScripts = false;
  };
  workTampermonkey = {
    hash = "1:352a54c6b7a925ac58ef10ba3a0bc805e0439d9972726f0e863ca3f2826b82bb";
    url = "https://github.com/Sighery/dotfiles/raw/refs/heads/main/hosts/common/tampermonkey/tampermonkey-work.json";
    haltOnError = true;
    installAsSystemScripts = false;
  };
in
{
  # Brave managed configuration
  environment.etc."/brave/policies/managed/AntiSlop.json".text = builtins.toJSON {
    BraveRewardsDisabled = true;
    BraveWalletDisabled = true;
    BraveAIChatEnabled = false;
    BraveNewsDisabled = true;
    BraveP3AEnabled = false;
    BraveStatsPingEnabled = false;
    BraveWebDiscoveryEnabled = false;
    AIModeSettings = 1;
    GenAILocalFoundationalModelSettings = 0;
    AutofillPredictionSettings = 2;
    CreateThemesSettings = 2;
    DevToolsGenAiSettings = 1;
    FindsSettings = 2;
    GeminiActOnWebSettings = 1;
    GeminiSettings = 1;
    GenAIInlineImageSettings = 2;
    GenAIPhotoEditingSettings = 2;
    GenAISmartGroupingSettings = 2;
    GenAIVcBackgroundSettings = 2;
    GenAiChromeOsSmartActionsSettings = 2;
    GenAiDefaultSettings = 2;
    AutofillCreditCardEnabled = false;
  };

  environment.etc."/brave/policies/managed/SearchEngine.json".text = builtins.toJSON {
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderSearchURL = "{google:baseURL}search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:searchClient}{google:sourceId}ie={inputEncoding}";
  };

  # allowed_permissions: https://developer.chrome.com/docs/extensions/reference/permissions-list
  environment.etc."/brave/policies/managed/Extensions.json".text = builtins.toJSON {
    ExtensionSettings = {
      "${tampermonkeyId}" = {
        toolbar_pin = "default_pinned";
        allowed_permissions = [
          "userScripts"
        ];
      };
    };
  };

  # TODO: Write some common structure indicating personal vs work equipment
  environment.etc."/brave/policies/managed/Tampermonkey.json".text = builtins.toJSON {
    "3rdparty" = {
      extensions = {
        "${tampermonkeyId}" = {
          jsonImport =
            lib.optional (config.networking.hostName != "sonar") personalTampermonkey
            ++ lib.optional (config.networking.hostName == "sonar") workTampermonkey;
        };
      };
    };
  };
}

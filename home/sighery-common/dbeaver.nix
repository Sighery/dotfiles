{ ... }:

{
  programs.dbeaver = {
    # Enable to set settings, but don't install
    enable = true;
    package = null;

    settings = {
      "org.jkiss.dbeaver.core" = {
        "ui.auto.update.check" = "false";
        "ui.show.tip.of.the.day.on.startup" = "false";
        "tipOfTheDayInitializer.notFirstRun" = "true";
        "sql.format.keywordCase" = "UPPER";
      };

      "org.jkiss.dbeaver.ui.statistics" = {
        "feature.tracking.enabled" = "false";
        "feature.tracking.skipConfirmation" = "true";
      };
    };
  };
}

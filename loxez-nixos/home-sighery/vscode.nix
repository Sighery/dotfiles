{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
        bbenoist.nix
        dbaeumer.vscode-eslint
        eamodio.gitlens
        golang.go
        hashicorp.terraform
        ms-azuretools.vscode-docker
        ms-python.python
        ms-vsliveshare.vsliveshare
        serayuzgur.crates
        vadimcn.vscode-lldb
        bungcip.better-toml
        stkb.rewrap
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        james-yu.latex-workshop
      ])
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "atom-keybindings";
          publisher = "ms-vscode";
          version = "3.3.0";
          sha256 = "vzOb/DUV44JMzcuQJgtDB6fOpTKzq298WSSxVKlYE4o=";
        }
      ];

    profiles.default.keybindings = [
      {
        key = "ctrl+shift+l";
        command = "workbench.action.editor.changeLanguageMode";
        when = "textInputFocus";
      }
      {
        key = "ctrl+k m";
        command = "-workbench.action.editor.changeLanguageMode";
        when = "textInputFocus";
      }
      {
        key = "ctrl+m";
        command = "-editor.action.toggleTabFocusMode";
      }
      {
        key = "ctrl+\\";
        command = "workbench.action.toggleSidebarVisibility";
        when = "viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "ctrl+alt+-";
        command = "-workbench.action.navigateBack";
      }
      {
        key = "alt+left";
        command = "workbench.action.navigateBack";
      }
      {
        key = "ctrl+shift+-";
        command = "-workbench.action.navigateForward";
      }
      {
        key = "alt+right";
        command = "workbench.action.navigateForward";
      }
      {
        key = "ctrl+alt+-";
        command = "-workbench.action.quickInputBack";
        when = "inQuickOpen";
      }
      {
        key = "alt+left";
        command = "workbench.action.quickInputBack";
        when = "inQuickOpen";
      }
    ];

    profiles.default.userSettings = {
      "update.mode" = "manual";
      "python.experiments.enabled" = false;
      "liveshare.diagnosticMode" = true;
      "liveshare.diagnosticLogging" = true;
      "atomKeymap.promptV3Features" = true;
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.guides.bracketPairs" = "active";
      "editor.formatOnPaste" = true;
      "editor.minimap.enabled" = false;
      "telemetry.telemetryLevel" = "off";
      "files.autoSave" = "afterDelay";
      "editor.fontFamily" = "'monospace', monospace, 'Droid Sans Mono', 'Droid Sans Fallback'";
      "editor.insertSpaces" = false;
      "window.menuBarVisibility" = "hidden";
      "window.enableMenuBarMnemonics" = false;
      "workbench.sideBar.location" = "right";
      "workbench.activityBar.location" = "hidden";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.startupEditor" = "none";
      "editor.renderWhitespace" = "boundary";
      "files.insertFinalNewline" = true;
      "workbench.colorTheme" = "Default Dark Modern";
      "editor.tokenColorCustomizations" = {
        "[Material Theme Palenight High Contrast]" = {
          "textMateRules" = [
            {
              "scope" = [
                "keyword.control.flow.block-scalar.literal.yaml"
                "keyword.control.flow.block-scalar.folded.yaml"
              ];
              "settings" = {
                "fontStyle" = "";
              };
            }
          ];
        };
      };
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "python.formatting.provider" = "black";
      "python.sortImports.args" = [
        "--profile"
        "black"
      ];
      "source.organizeImports" = true;
      "python.linting.enabled" = true;
      "python.linting.pylintEnabled" = true;
      "python.linting.mypyEnabled" = true;
      "python.dataScience.askForKernelRestart" = true;
      "editor.formatOnSave" = true;
      "rewrap.autoWrap.enable" = true;
      "rust.clippy_preferences" = "on";
      "gitlens.codeLens.enabled" = false;
      "gitlens.advanced.telemetry.enabled" = false;
      "gitlens.codeLens.authors.enabled" = false;
      "gitlens.showWelcomeOnInstall" = false;
      "gitlens.showWhatsNewAfterUpgrades" = false;
      "explorer.confirmDelete" = false;
      "go.useLanguageServer" = true;
      "explorer.confirmDragAndDrop" = false;
      "redhat.telemetry.enabled" = false;
      "yaml.schemaStore.enable" = true;
      "crates.upToDateDecorator" = "";
      "rust-analyzer.inlayHints.typeHints" = false;
      "rust-analyzer.inlayHints.parameterHints" = false;
      "files.exclude" = {
        "**/.git" = false;
      };
      "files.associations" = {
        "docker-compose.yml" = "yaml";
        "docker-compose.yaml" = "yaml";
        "*.auto.tfvars" = "terraform";
        "*.tfvars" = "terraform";
        "*.h" = "c";
      };
      "workbench.colorCustomizations" = {
        "editorRuler.foreground" = "#FF4081";
      };
      "editor.rulers" = [
        {
          "column" = 78;
          "color" = "#FF4081";
        }
        {
          "column" = 70;
          "color" = "#FFA700";
        }
      ];
      "terraform.languageServer" = {
        "external" = true;
        "args" = [ "serve" ];
      };
      "terraform-ls.experimentalFeatures" = {
        "validateOnSave" = true;
      };
      "[markdown]" = {
        "editor.quickSuggestions" = {
          "comments" = "off";
          "strings" = "off";
          "other" = "off";
        };
        "files.trimTrailingWhitespace" = false;
      };
      "[terraform]" = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
        "editor.defaultFormatter" = "hashicorp.terraform";
        "editor.formatOnSave" = false;
      };
      "[yaml]" = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
      };
      "black-formatter.path" = [ "venv/bin/black" ];
      "[c]" = {
        "editor.rulers" = [
          {
            "column" = 98;
            "color" = "#FF4081";
          }
          {
            "column" = 79;
            "color" = "#5F6368";
          }
          {
            "column" = 89;
            "color" = "#FFA700";
          }
        ];
      };
      "[python]" = {
        "editor.defaultFormatter" = "ms-python.python";
        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = false;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };
        "editor.rulers" = [
          {
            "column" = 87;
            "color" = "#FF4081";
          }
          {
            "column" = 71;
            "color" = "#5F6368";
          }
          {
            "column" = 79;
            "color" = "#FFA700";
          }
        ];
      };
      "[rust]" = {
        "editor.defaultFormatter" = "rust-lang.rust-analyzer";
        "editor.rulers" = [
          {
            "column" = 98;
            "color" = "#FF4081";
          }
          {
            "column" = 79;
            "color" = "#5F6368";
          }
          {
            "column" = 89;
            "color" = "#FFA700";
          }
        ];
      };
      "[javascript]" = {
        "editor.rulers" = [
          {
            "column" = 98;
            "color" = "#FF4081";
          }
          {
            "column" = 71;
            "color" = "#5F6368";
          }
          {
            "column" = 79;
            "color" = "#FFA700";
          }
        ];
      };
    };
  };
}

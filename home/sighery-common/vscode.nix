{ config, lib, pkgs, ... }:

let
  antislop-settings = lib.importJSON "${pkgs.vscode-antislop-settings}/settings.json";
in
{
  programs.vscodium = {
    enable = true;

    mutableExtensionsDir = false;
    profiles.default.enableExtensionUpdateCheck = false;

    profiles.default.extensions =
      with pkgs.vscode-extensions; [
        bbenoist.nix
        dbaeumer.vscode-eslint
        eamodio.gitlens
        golang.go
        hashicorp.terraform
        ms-azuretools.vscode-docker
        ms-python.python
        ms-python.vscode-pylance
        ms-python.pylint
        ms-vsliveshare.vsliveshare
        serayuzgur.crates
        vadimcn.vscode-lldb
        stkb.rewrap
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        james-yu.latex-workshop
        streetsidesoftware.code-spell-checker
        vscodevim.vim
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "atom-keybindings";
          publisher = "ms-vscode";
          version = "3.3.0";
          sha256 = "vzOb/DUV44JMzcuQJgtDB6fOpTKzq298WSSxVKlYE4o=";
        }
        {
          name = "toml";
          publisher = "be5invis";
          version = "0.6.0";
          sha256 = "sha256-yk7buEyQIw6aiUizAm+sgalWxUibIuP9crhyBaOjC2E=";
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
      {
        key = "ctrl+shift+c";
        command = "copyRelativeFilePath";
        when = "editorFocus";
      }
      {
        key = "ctrl+alt+c";
        command = "copyFilePath";
        when = "editorFocus";
      }
    ];

    profiles.default.userSettings = lib.recursiveUpdate antislop-settings {
      # TODO: https://gist.github.com/rpavlik/95d6c40d8407805e2c20bdf6d9efa44e?permalink_comment_id=6379775#gistcomment-6379775
      "chat.agent.sandbox.enabled" = "on";

      # Editor
      "editor.acceptSuggestionOnCommitCharacter" = false;
      "editor.fontFamily" = "'monospace', monospace, 'Droid Sans Mono', 'Droid Sans Fallback'";
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.guides.bracketPairs" = "active";
      "editor.insertSpaces" = false;
      "editor.minimap.enabled" = false;
      "editor.multiCursorModifier" = "ctrlCmd";
      "editor.renderWhitespace" = "boundary";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "extensions.ignoreRecommendations" = true;
      "files.associations" = {
        "docker-compose.yml" = "yaml";
        "docker-compose.yaml" = "yaml";
        "*.auto.tfvars" = "terraform";
        "*.tfvars" = "terraform";
        "*.h" = "c";
      };
      "files.autoSave" = "afterDelay";
      "files.exclude" = {
        "**/.git" = false;
      };
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "security.workspace.trust.banner" = "never";
      "security.workspace.trust.startupPrompt" = "never";
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "manual";
      "window.enableMenuBarMnemonics" = false;
      "window.menuBarVisibility" = "hidden";
      "workbench.activityBar.location" = "hidden";
      "workbench.colorTheme" = "Dark Modern";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.editor.useModal" = "off";
      "workbench.secondarySideBar.defaultVisibility" = "hidden";
      "workbench.sideBar.location" = "right";
      "workbench.startupEditor" = "none";

      # Gitlens annoyances
      "gitlens.advanced.skipOnboarding" = true;
      "gitlens.advanced.telemetry.enabled" = false;
      "gitlens.ai.enabled" = false;
      "gitlens.cloudPatches.enabled" = false;
      "gitlens.codeLens.authors.enabled" = false;
      "gitlens.codeLens.enabled" = false;
      "gitlens.plusFeatures.enabled" = false;
      "gitlens.showWelcomeOnInstall" = false;
      "gitlens.showWhatsNewAfterUpgrades" = false;
      "gitlens.telemetry.enabled" = false;
      # Rebase editor
      "workbench.editorAssociations" = {
        "git-rebase-todo" = "default";
      };
      "gitlens.rebaseEditor.openOnPausedRebase" = "false";

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

      "go.showWelcome" = false;
      "go.survey.prompt" = false;
      "go.toolsManagement.autoUpdate" = false;
      "go.toolsManagement.checkForUpdates" = "off";
      "go.useLanguageServer" = true;

      "atomKeymap.promptV3Features" = true;

      "latex-workshop.latex.autoBuild.run" = "never";

      "liveshare.diagnosticMode" = true;
      "liveshare.diagnosticLogging" = true;

      "python.languageServer" = "Pylance";

      "rewrap.autoWrap.enable" = true;

      "redhat.telemetry.enabled" = false;
      "yaml.schemaStore.enable" = true;

      "vim.smartRelativeLine" = true;

      # Generic rulers
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

      # Language settings
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
      "[nix]" = {
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
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
        "editor.tabSize" = 4;
        "editor.insertSpaces" = true;
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
      "[go]" = {
        "editor.insertSpaces" = false;
        "editor.tabSize" = 4;
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
      "[html][css]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
      };
      "[javascript][typescript][typescriptreact]" = {
        "editor.insertSpaces" = true;
        "editor.tabSize" = 2;
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

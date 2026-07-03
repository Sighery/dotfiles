{ config
, lib
, pkgs
, ...
}:

{
  programs.vscodium = {
    enable = true;

    profiles.default.extensions =
      (with pkgs.vscode-extensions; [
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
        bungcip.better-toml
        stkb.rewrap
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        james-yu.latex-workshop
        streetsidesoftware.code-spell-checker
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

    profiles.default.userSettings = {
      "update.mode" = "manual";
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
      # == Gitlens annoying rebase editor ==
      "gitlens.rebaseEditor.openOnPausedRebase" = "false";
      "workbench.editorAssociations" = {
        "git-rebase-todo" = "default";
      };
      # == AI slop ==
      "chat.disableAIFeatures" = true;
      "workbench.settings.showAISearchToggle" = false;
      "accessibility.verbosity.inlineChat" = false;
      "accessibility.verbosity.panelChat" = false;
      "ansible.lightspeed.suggestions.waitWindow" = 360000;
      "chat.agent.enabled" = false;
      "chat.agent.maxRequests" = 0;
      "chat.commandCenter.enabled" = false;
      "chat.detectParticipant.enabled" = false;
      "chat.extensionTools.enabled" = false;
      "chat.focusWindowOnConfirmation" = false;
      "chat.implicitContext.enabled" = {
        "panel" = "never";
      };
      "chat.implicitContext.suggestedContext" = false;
      "chat.instructionsFilesLocations" = {
        ".github/instructions" = false;
      };
      "chat.mcp.access" = "none";
      "chat.mcp.discovery.enabled" = {
        "claude-desktop" = false;
        "windsurf" = false;
        "cursor-global" = false;
        "cursor-workspace" = false;
      };
      "chat.promptFiles" = false;
      "chat.promptFilesLocations" = {
        ".github/prompts" = false;
      };
      "chat.sendElementsToChat.attachCSS" = false;
      "chat.sendElementsToChat.attachImages" = false;
      "chat.sendElementsToChat.enabled" = false;
      "chat.setupFromDialog" = false;
      "chat.showAgentSessionsViewDescription" = false;
      "chat.tools.todos.showWidget" = false;
      "chat.useAgentsMdFile" = false;
      "chat.useFileStorage" = false;
      "dataWrangler.experiments.copilot.enabled" = false;
      "diffEditor.ignoreTrimWhitespace" = false;
      "github.copilot.editor.enableAutoCompletions" = false;
      "github.copilot.editor.enableCodeActions" = false;
      "github.copilot.enable" = false;
      "github.copilot.nextEditSuggestions.enabled" = false;
      "github.copilot.renameSuggestions.triggerAutomatically" = false;
      "githubPullRequests.codingAgent.enabled" = false;
      "githubPullRequests.experimental.chat" = false;
      "gitlab.duoChat.enabled" = false;
      "inlineChat.holdToSpeech" = false;
      "inlineChat.lineNaturalLanguageHint" = false;
      "mcp" = {
        "inputs" = [ ];
        "servers" = { };
      };
      "notebook.experimental.generate" = false;
      "python.analysis.aiCodeActions" = {
        "convertFormatString" = false;
        "convertLambdaToNamedFunction" = false;
        "generateDocstring" = false;
        "generateSymbol" = false;
        "implementAbstractClasses" = false;
      };
      "python.experiments.enabled" = false;
      "remote.SSH.experimental.chat" = false;
      "telemetry.feedback.enabled" = false;
      "terminal.integrated.initialHint" = false;
      "workbench.editor.empty.hint" = "hidden";
      # == AI slop ==
      "workbench.sideBar.location" = "right";
      "workbench.activityBar.location" = "hidden";
      "workbench.secondarySideBar.defaultVisibility" = "hidden";
      "workbench.editor.enablePreviewFromQuickOpen" = false;
      "workbench.startupEditor" = "none";
      "editor.renderWhitespace" = "boundary";
      "files.insertFinalNewline" = true;
      "workbench.colorTheme" = "Dark Modern";
      "workbench.editor.useModal" = "off";
      "latex-workshop.latex.autoBuild.run" = "never";
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
      "python.languageServer" = "Pylance";
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
      "gitlens.ai.enabled" = false;
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
      "[javascript][typescript]" = {
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

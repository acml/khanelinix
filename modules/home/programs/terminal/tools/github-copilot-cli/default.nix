{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.khanelinix.programs.terminal.tools.github-copilot-cli;

  mcpModuleEnabled = config.khanelinix.programs.terminal.tools.mcp.enable or false;
  aiTools = import (lib.getFile "modules/common/ai-tools") { inherit lib; };
  copilotConfigPath = config.programs.github-copilot-cli.configDir;
  posixTokenExports = lib.optionalString (config.khanelinix.services.sops.enable or false) ''
    if [ -f ${config.sops.secrets."github/copilot-token".path} ]; then
      COPILOT_GITHUB_TOKEN="$(cat ${config.sops.secrets."github/copilot-token".path})"
      export COPILOT_GITHUB_TOKEN
    fi
  '';
  fishTokenExports = lib.optionalString (config.khanelinix.services.sops.enable or false) /* fish */ ''
    if test -f ${config.sops.secrets."github/copilot-token".path}
      set -gx COPILOT_GITHUB_TOKEN (cat ${config.sops.secrets."github/copilot-token".path})
    end
  '';
in
{
  options.khanelinix.programs.terminal.tools.github-copilot-cli = {
    enable = mkEnableOption "GitHub Copilot CLI configuration";
  };

  config = mkIf cfg.enable {
    programs.github-copilot-cli = {
      enable = true;

      enableMcpIntegration = mkIf mcpModuleEnabled true;

      settings = {
        model = "gpt-5.4";
        effortLevel = "high";
        theme = "dark";
        banner = "once";
        renderMarkdown = true;
        autoUpdate = false;
        includeCoAuthoredBy = false;
        respectGitignore = true;
        enabledFeatureFlags = {
          QUEUED_COMMANDS = true;
        };

        trusted_folders =
          let
            documentsPath =
              if config.xdg.userDirs.enable then
                config.xdg.userDirs.documents
              else
                config.home.homeDirectory + lib.optionalString pkgs.stdenv.hostPlatform.isLinux "/Documents";

            trustedGithubProjects = [
              "home-manager"
              "khanelivim"
              "nixpkgs"
              "nixvim"
              "waybar"
            ];
          in
          [
            "${config.home.homeDirectory}/khanelinix"
          ]
          ++ map (project: "${documentsPath}/github/${project}") trustedGithubProjects;
      };
    };

    programs.bash.initExtra = posixTokenExports;
    programs.fish.shellInit = fishTokenExports;
    programs.zsh.initContent = posixTokenExports;

    home.file = {
      "${copilotConfigPath}/copilot-instructions.md".source = aiTools.githubCopilotCli.base;
    }
    //
      lib.mapAttrs'
        (name: _: {
          name = "${copilotConfigPath}/skills/${name}";
          value = {
            source = aiTools.githubCopilotCli.skills + "/${name}";
            recursive = true;
          };
        })
        (lib.filterAttrs (_: type: type == "directory") (builtins.readDir aiTools.githubCopilotCli.skills))
    // lib.mapAttrs' (name: text: {
      name = "${copilotConfigPath}/skills/${name}/SKILL.md";
      value.text = text;
    }) aiTools.githubCopilotCli.commandSkills
    // lib.mapAttrs' (name: text: {
      name = "${copilotConfigPath}/agents/${name}.agent.md";
      value.text = text;
    }) aiTools.githubCopilotCli.agents;

    sops.secrets = lib.mkIf (config.khanelinix.services.sops.enable or false) {
      "github/copilot-token" = {
        sopsFile = lib.getFile "secrets/khaneliman/default.yaml";
        path = "${config.home.homeDirectory}/.config/copilot/token";
      };
    };
  };
}

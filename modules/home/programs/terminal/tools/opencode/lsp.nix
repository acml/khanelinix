# OpenCode LSP (Language Server Protocol) configuration module
# Defines language servers for different programming languages
{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    programs.opencode.settings.lsp = {
      nixd = {
        command = [ (lib.getExe pkgs.nixd) ];
        extensions = [ ".nix" ];
        initialization = {
          formatting = {
            command = [ (lib.getExe pkgs.nixfmt) ];
          };
          options = {
            nixos = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/khanelinix\").nixosConfigurations.khanelinix.options";
            };
            home-manager = {
              expr = "(builtins.getFlake \"${config.home.homeDirectory}/khanelinix\").homeConfigurations.\"khaneliman@khanelinix\".options";
            };
          };
        };
      };

      emmylua-ls = {
        command = [ (lib.getExe pkgs.emmylua-ls) ];
        extensions = [ ".lua" ];
        initialization = {
          Lua = {
            diagnostics = {
              globals = [
                "vim"
                "Sbar"
                "spoon"
              ];
            };
            workspace = {
              library = [
                "/nix/store/*/share/lua/5.1"
                "/etc/profiles/per-user/${config.khanelinix.user.name}/share/lua/5.1"
              ];
            };
          };
        };
      };

      basedpyright = {
        command = [
          (lib.getExe' pkgs.basedpyright "basedpyright-langserver")
          "--stdio"
        ];
        extensions = [
          ".py"
          ".pyi"
          ".pyw"
        ];
      };

      ruff = {
        command = [
          (lib.getExe pkgs.ruff)
          "server"
        ];
        extensions = [
          ".py"
          ".pyi"
          ".pyw"
        ];
      };

      bashls = {
        command = [
          (lib.getExe pkgs.bash-language-server)
          "start"
        ];
        extensions = [
          ".sh"
          ".bash"
        ];
      };

      clangd = {
        command = [
          (lib.getExe' pkgs.clang-tools "clangd")
          "--background-index"
          "--clang-tidy"
          "--header-insertion=iwyu"
          "--completion-style=detailed"
          "--function-arg-placeholders"
          "--fallback-style=llvm"
        ];
        extensions = [
          ".c"
          ".cpp"
          ".cc"
          ".cxx"
          ".c++"
          ".h"
          ".hpp"
          ".hh"
          ".hxx"
          ".h++"
        ];
      };

      fish-lsp = {
        command = [ (lib.getExe pkgs.fish-lsp) ];
        extensions = [ ".fish" ];
      };

      typescript = {
        command = [
          (lib.getExe pkgs.typescript-language-server)
          "--stdio"
        ];
        extensions = [
          ".ts"
          ".tsx"
          ".js"
          ".jsx"
          ".mjs"
          ".cjs"
          ".mts"
          ".cts"
        ];
      };

      gopls = {
        command = [ (lib.getExe pkgs.gopls) ];
        extensions = [
          ".go"
          ".mod"
          ".sum"
        ];
      };

      rust-analyzer = {
        command = [ (lib.getExe pkgs.rust-analyzer) ];
        extensions = [ ".rs" ];
      };

      csharp = {
        command = [ (lib.getExe pkgs.roslyn-ls) ];
        extensions = [
          ".cs"
          ".csx"
          ".cake"
        ];
      };

      yamlls = {
        command = [
          (lib.getExe pkgs.yaml-language-server)
          "--stdio"
        ];
        extensions = [
          ".yaml"
          ".yml"
        ];
      };

      jsonls = {
        command = [
          (lib.getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server")
          "--stdio"
        ];
        extensions = [
          ".json"
          ".jsonc"
        ];
      };

      taplo = {
        command = [
          (lib.getExe pkgs.taplo)
          "lsp"
          "stdio"
        ];
        extensions = [ ".toml" ];
      };

      marksman = {
        command = [ (lib.getExe pkgs.marksman) ];
        extensions = [
          ".md"
          ".mdx"
        ];
      };
    };
  };
}

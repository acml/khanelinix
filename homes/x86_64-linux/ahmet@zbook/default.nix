{
  config,
  lib,
  pkgs,

  ...
}:
let
  inherit (lib.khanelinix) enabled disabled;
in
{
  khanelinix = {
    user = {
      enable = true;
      name = "ahmet";
      email = "ozgezer@gmail.com";
      fullName = "Ahmet Cemal Özgezer";
    };

    environments = {
      home-network = enabled;
    };

    programs = {
      graphical = {
        browsers = {
          firefox = {
            gpuAcceleration = true;
            hardwareDecoding = true;
            settings = {
              # "dom.ipc.processCount.webIsolated" = 9;
              # "dom.maxHardwareConcurrency" = 16;
              "media.av1.enabled" = false;
              # "media.ffvpx.enabled" = false;
              # "media.hardware-video-decoding.force-enabled" = true;
              "media.hardwaremediakeys.enabled" = true;
            };
          };
        };

        desktop-environment.gnome = {
          enable = true;
          shell.favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "org.gnome.Console.desktop"
            "firefox-devedition.desktop"
            "steam.desktop"
            "org.vinegarhq.Sober.desktop"
          ];
        };
      };

      terminal = {
        # No need for all these on his computer
        editors.emacs.enable = true;
        editors.neovim.enable = true;
        emulators = {
          alacritty.enable = false;
          kitty.enable = false;
          wezterm.enable = false;
        };

        media = {
          ncmpcpp = disabled;
        };

        shell.nushell.enable = false;

        tools = {
          # No need for all these on his computer
          carapace.enable = false;
          jujutsu.enable = false;
          topgrade.enable = false;

          git.enable = true;

          run-as-service = enabled;
          ssh = enabled;
        };
      };
    };

    services = {
      # sops = {
      #   enable = true;
      #   defaultSopsFile = lib.getFile "secrets/khanelinix/khaneliman/default.yaml";
      #   sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      # };
    };

    system = {
      xdg = enabled;
    };

    roles = {
      desktop = enabled;
      #gamer = enabled;
    };

    suites = {
      business = {
        # NOTE: Enabled through desktop role
        enable = lib.mkForce false;
      };

      development = {
        enable = true;
        gameEnable = false;
        nixEnable = true;
      };

      networking = enabled;
    };

    theme = {
      catppuccin = enabled;
      stylix = enabled;
    };
  };

  home.packages = [
    # khanelinix.git-dt
    # (pkgs.buildFHSEnv {
    #   name = "cppfhs";
    #   runScript = "bash";
    #   targetPkgs =
    #     pkgs: with pkgs; [
    #       automake
    #       bash-completion
    #       bc
    #       bison
    #       doas
    #       gcc12
    #       gnumake
    #       cmake
    #       glibc_multi
    #       flex
    #       gettext
    #       kmod
    #       less
    #       libtool
    #       meson
    #       ncurses
    #       openssl
    #       p7zip
    #       pkg-config
    #       squashfsTools
    #       sudo
    #       ubootTools
    #       unzip
    #       xxd
    #       xz
    #       zlib
    #     ];
    # })
  ];

  programs = {
    git = {
      lfs.enable = true;
      lfs.package = pkgs.git-lfs;
    };
    nh.flake = lib.mkForce "${config.home.homeDirectory}/.config/khanelinix";
    ssh.extraConfig = ''
      Include config.d/*
    '';
  };
  home.stateVersion = "26.05";
}

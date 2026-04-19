{
  config,
  lib,
  pkgs,

  ...
}:
let
  inherit (lib.khanelinix) enabled disabled;
  wallpaperCfg = config.khanelinix.theme.wallpaper;
  wallpaperPath = name: lib.khanelinix.theme.wallpaperPath { inherit config pkgs name; };
  wallpaperPaths = names: lib.khanelinix.theme.wallpaperPaths { inherit config pkgs names; };
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
        bars = {
          ashell = {
            fullSizeOutputs = [ "eDP-1" ];
            condensedOutputs = [
              "DP-7"
              "DP-8"
              "DP-9"
            ];
          };
          waybar = {
            enableDebug = false;
            # enableInspect = true;
            fullSizeOutputs = [ "eDP-1" ];
            condensedOutputs = [
              "DP-7"
              "DP-8"
              "DP-9"
            ];
          };
        };

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

        # desktop-environment.gnome = {
        #   enable = true;
        #   shell.favorite-apps = [
        #     "org.gnome.Nautilus.desktop"
        #     "org.gnome.Console.desktop"
        #     "firefox-devedition.desktop"
        #     "steam.desktop"
        #     "org.vinegarhq.Sober.desktop"
        #   ];
        # };

        wms = {
          hyprland = {
            enable = true;
            enableDebug = false;

            settings = {
              input = {
                kb_layout = "us";
                kb_variant = "colemak";
                kb_options = "ctrl:swapcaps";
              };

              monitorv2 = [
                {
                  output = "DP-9";
                  mode = "1920x1080@60";
                  position = "1920x0";
                  scale = 1;
                  bitdepth = 10;
                }
                {
                  output = "eDP-1";
                  mode = "1920x1080@60";
                  position = "1920x1080";
                  scale = 1;
                  bitdepth = 10;
                }
                {
                  output = "DP-8";
                  mode = "1680x1050@60";
                  position = "3840x30";
                  scale = 1;
                  bitdepth = 10;
                }
                {
                  output = "DP-7";
                  mode = "1920x1080@60";
                  position = "0x0";
                  scale = 1;
                  bitdepth = 10;
                }
              ];

              exec-once = [
                "hyprctl setcursor ${config.khanelinix.theme.gtk.cursor.name} ${toString config.khanelinix.theme.gtk.cursor.size}"
              ];

              workspace = [
                "1, monitor:DP-9, persistent:true, default:true"
                "2, monitor:eDP-1, persistent:true, default:true"
                "3, monitor:DP-8, persistent:true, default:true"
                "4, monitor:DP-7, persistent:true, default:true"
                "5, monitor:eDP-1, persistent:true"
                "6, monitor:eDP-1, persistent:true"
                "7, monitor:eDP-1, persistent:true"
                "8, monitor:eDP-1, persistent:true"
                "9, monitor:eDP-1, persistent:true"
              ];
            };
          };

          niri = {
            enable = true;

            settings = {
              outputs = {
                "DP-9" = {
                  name = "DP-9";
                  mode = {
                    width = 1920;
                    height = 1080;
                    refresh = 60.0;
                  };
                  position = {
                    x = 1920;
                    y = 0;
                  };
                  scale = 1.0;
                };

                "eDP-1" = {
                  name = "eDP-1";
                  mode = {
                    width = 1920;
                    height = 1080;
                    refresh = 60.0;
                  };
                  position = {
                    x = 1920;
                    y = 1080;
                  };
                  scale = 1.0;
                  focus-at-startup = true;
                };

                "DP-8" = {
                  name = "DP-8";
                  mode = {
                    width = 1680;
                    height = 1050;
                    refresh = 60.0;
                  };
                  position = {
                    x = 3840;
                    y = 30;
                  };
                  scale = 1.0;
                };

                "DP-7" = {
                  name = "DP-7";
                  mode = {
                    width = 1920;
                    height = 1080;
                    refresh = 60.0;
                  };
                  position = {
                    x = 0;
                    y = 0;
                  };
                  scale = 1.0;
                };
              };

              workspaces = {
                "1" = {
                  open-on-output = "DP-9";
                };
              }
              // lib.genAttrs (map toString (lib.range 2 9)) (_: {
                open-on-output = "eDP-1";
              });

              xwayland-satellite = {
                enable = true;
                path = lib.getExe pkgs.xwayland-satellite;
              };
            };
          };

          sway = {
            enable = true;

            settings = {
              output = {
                "DP-9" = {
                  resolution = "1920x1080";
                  position = "1920,0";
                  scale = "1";
                };
                "eDP-1" = {
                  resolution = "1920x1080";
                  position = "1920,1080";
                };
                "DP-8" = {
                  resolution = "1680x1050";
                  position = "3840,30";
                  scale = "1";
                };
                "DP-7" = {
                  resolution = "1920x1080";
                  position = "0,0";
                  scale = "1";
                };
              };

              workspaceOutputAssign = [
                {
                  workspace = "1";
                  output = "DP-9";
                }
                {
                  workspace = "2";
                  output = "eDP-1";
                }
                {
                  workspace = "3";
                  output = "DP-8";
                }
                {
                  workspace = "4";
                  output = "DP-7";
                }
                {
                  workspace = "5";
                  output = "eDP-1";
                }
                {
                  workspace = "6";
                  output = "eDP-1";
                }
                {
                  workspace = "7";
                  output = "eDP-1";
                }
                {
                  workspace = "8";
                  output = "eDP-1";
                }
              ];
            };
          };
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
      hyprpaper = {
        monitors = [
          {
            name = "DP-9";
            wallpaper = wallpaperPath wallpaperCfg.primary;
          }
          {
            name = "eDP-1";
            wallpaper = wallpaperPath wallpaperCfg.secondary;
          }
          {
            name = "DP-8";
            wallpaper = wallpaperPath wallpaperCfg.secondary;
          }
          {
            name = "DP-7";
            wallpaper = wallpaperPath wallpaperCfg.secondary;
          }
        ];

        wallpapers = wallpaperPaths wallpaperCfg.list;
      };
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
      social.enable = lib.mkForce false;
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

  # Configure monitors independently and override module default
  programs.hyprlock.settings.background = lib.mkForce (
    let
      mkBackground = monitor: wallpaper: {
        inherit monitor;
        brightness = "0.817200";
        color = lib.mkDefault "rgba(25, 20, 20, 1.0)";
        path = wallpaperPath wallpaper;
        blur_passes = 3;
        blur_size = 8;
        contrast = "0.891700";
        noise = "0.011700";
        vibrancy = "0.168600";
        vibrancy_darkness = "0.050000";
      };
    in
    [
      (mkBackground "eDP-1" wallpaperCfg.secondary)
      (mkBackground "DP-9" wallpaperCfg.primary)
      (mkBackground "DP-8" wallpaperCfg.secondary)
      (mkBackground "DP-7" wallpaperCfg.secondary)
    ]
  );

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

  # Neo G9
  xresources.properties."Xft.dpi" = "96";

  home.stateVersion = "26.05";
}

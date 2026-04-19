{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.khanelinix) enabled;
  inherit (lib) mkForce mkMerge;
in
{
  imports = [
    ./disks.nix
    ./hardware.nix
    ./network.nix
    # ./specializations.nix
  ];

  khanelinix = {
    nix = enabled;

    archetypes = {
      #gaming = enabled;
      personal = enabled;
    };

    environments = {
      home-network = enabled;
    };

    display-managers = {
      # gdm = {
      #   defaultSession = "gnome";
      # };
      gdm.monitors = ./monitors.xml;
      regreet.hyprlandOutput = builtins.readFile ./hyprlandOutput;
    };

    hardware = {
      audio = {
        enable = true;
      };

      bluetooth = enabled;
      cpu.intel = enabled;
      gpu.nvidia = enabled;
      opengl = enabled;
      rgb.openrgb.enable = true;

      storage = {
        enable = true;
        ssdEnable = true;
      };

      tpm = enabled;
    };

    programs = {
      graphical = {
        # desktop-environment = {
        #   gnome = {
        #     enable = true;
        #   };
        # };
        wms = mkMerge [
          {
            hyprland.enable = true;
            niri = {
              enable = true;
              package = pkgs.niri-unstable;
            };
          }
          {
            sway = {
              enable = true;
              withUWSM = true;
            };
          }
        ];
      };
    };

    services = {
      avahi = enabled;
      geoclue = enabled;
      power = enabled;
      printing = enabled;

      openssh = {
        enable = true;
      };
    };

    security = {
      keyring = enabled;
      sudo-rs = enabled;
      # sops = {
      #   enable = true;
      #   sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      #   defaultSopsFile = lib.getFile "secrets/bruddynix/default.yaml";
      # };
    };

    system = {
      boot = {
        enable = true;
        # TODO: configure
        # secureBoot = true;
        plymouth = true;
        silentBoot = true;
      };

      fonts = enabled;
      locale = enabled;
      networking.enable = true;
      time = enabled;
      xkb = enabled;
    };

    theme = {
      # gtk = enabled;
      # qt = enabled;
      stylix = enabled;
    };

    user.name = "ahmet";
  };

  environment.variables = {
    # Fix black bars in gnome
    GSK_RENDERER = "ngl";
    # Fix mouse pointer in gnome
    NO_POINTER_VIEWPORT = "1";
  };

  nix.settings = {
    cores = 8;
    max-jobs = 8;
  };

  services = {
    displayManager.defaultSession = "hyprland-uwsm";
    irqbalance.enable = mkForce false;
    xserver.xkb.variant = "colemak";
    xserver.xkb.options = mkForce "ctrl:swapcaps";
  };

  system.stateVersion = "26.05";
}

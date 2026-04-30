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
  environment.sessionVariables = {
    # Fix Nvidia cursor rendering issues in wlroots compositors (like Hyprland)
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  nix.settings = {
    cores = 8;
    max-jobs = 8;
  };

  # console.earlySetup = false;
  # console.keyMap = "colemak";
  # console.useXkbConfig = lib.mkForce false;
  console = {
    earlySetup = true;
    font = lib.mkForce "ter-122b";
    packages = with pkgs; [ terminus_font ];
    keyMap = "colemak";
  };

  powerManagement.enable = true;

  powerManagement.powertop.enable = true;
  powerManagement.powertop.postStart = ''
    HIDDEVICES=$(ls /sys/bus/usb/drivers/usbhid | grep -oE '^[0-9]+-[0-9\.]+' | sort -u)
    for i in $HIDDEVICES; do
      echo -n "Enabling " | cat - /sys/bus/usb/devices/$i/product
      echo 'on' > /sys/bus/usb/devices/$i/power/control
    done
  '';

  services = {
    displayManager.defaultSession = "hyprland-uwsm";
    irqbalance.enable = mkForce false;
    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings.main = {
          shift = "oneshot(shift)";
          meta = "oneshot(meta)";
          control = "oneshot(control)";

          leftalt = "oneshot(alt)";
          rightalt = "oneshot(altgr)";

          capslock = "overload(control, esc)";
          insert = "S-insert";
        };
      };
    };
    kmscon = {
      enable = true;
      hwRender = true;
      fonts = [
        {
          name = "MesloLGS NF";
          package = pkgs.meslo-lgs-nf;
        }
      ];
      extraConfig = "font-size=14";
      extraOptions = "--term xterm-256color";
    };
    logind.settings.Login = {
      HandleLidSwitch = "poweroff";
      HandleLidSwitchExternalPower = "suspend";
      HandleLidSwitchDocked = "suspend";
      # one of "ignore", "poweroff", "reboot", "halt", "kexec", "suspend", "hibernate", "hybrid-sleep", "suspend-then-hibernate", "lock"
    };
    thermald.enable = true;
    xserver.xkb.variant = "colemak";
  };

  time.timeZone = mkForce "Europe/Istanbul";

  system.stateVersion = "26.05";
}

{
  lib,
  pkgs,
  ...
}:
{
  specialisation = {
    # zen = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    #   };
    # };

    # lts = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    #   };
    # };

    # dgpu = {
    #   inheritParentConfig = true;
    #   configuration = {
    #     # system.nixos.tags = [ "dgpu" ];
    #     # environment.etc."specialisation".text = "dgpu";

    #     hardware.nvidia = {
    #       prime.sync.enable = lib.mkForce true;
    #       prime.offload.enable = lib.mkForce false;
    #       prime.offload.enableOffloadCmd = lib.mkForce false;

    #       # Finegrained suspend is mutually exclusive with sync mode; keep
    #       # the general suspend/resume hooks so resume-from-s2idle still
    #       # restores the framebuffer cleanly.
    #       powerManagement.finegrained = lib.mkForce false;

    #       forceFullCompositionPipeline = true;
    #     };
    #   };
    # };

    kde = {
      inheritParentConfig = true;
      configuration = {

        services = {
          desktopManager.plasma6.enable = true;
          displayManager.plasma-login-manager.enable = true;
          # displayManager.sddm.enable = true;
          # displayManager.sddm.wayland.enable = true;
        };

        environment.systemPackages = with pkgs; [
          # KDE Utilities
          kdePackages.discover # Optional: Software center for Flatpaks/firmware updates
          kdePackages.kcalc # Calculator
          kdePackages.kcharselect # Character map
          kdePackages.kclock # Clock app
          kdePackages.kcolorchooser # Color picker
          kdePackages.kolourpaint # Simple paint program
          kdePackages.ksystemlog # System log viewer
          kdePackages.sddm-kcm # SDDM configuration module
          kdiff3 # File/directory comparison tool

          # Hardware/System Utilities (Optional)
          kdePackages.isoimagewriter # Write hybrid ISOs to USB
          kdePackages.partitionmanager # Disk and partition management
          hardinfo2 # System benchmarks and hardware info
          wayland-utils # Wayland diagnostic tools
          wl-clipboard # Wayland copy/paste support
          vlc # Media player
        ];

      };
    };

    wms = {
      inheritParentConfig = true;
      configuration = {
        khanelinix = {
          programs = {
            graphical = {
              wms = {
                hyprland.enable = true;
                niri.enable = true;
                sway = {
                  enable = true;
                  withUWSM = true;
                };
              };
            };
          };
        };

        services.displayManager.defaultSession = lib.mkForce "hyprland-uwsm";

      };
    };
  };
}

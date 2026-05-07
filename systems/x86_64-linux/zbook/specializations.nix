{ lib, pkgs, ... }:
{
  specialisation = {
    zen = {
      inheritParentConfig = true;
      configuration = {
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
      };
    };

    lts = {
      inheritParentConfig = true;
      configuration = {
        boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
      };
    };

    dgpu = {
      inheritParentConfig = true;
      configuration = {
        # system.nixos.tags = [ "dgpu" ];
        # environment.etc."specialisation".text = "dgpu";

        hardware.nvidia = {
          prime.sync.enable = lib.mkForce true;
          prime.offload.enable = lib.mkForce false;
          prime.offload.enableOffloadCmd = lib.mkForce false;

          # Finegrained suspend is mutually exclusive with sync mode; keep
          # the general suspend/resume hooks so resume-from-s2idle still
          # restores the framebuffer cleanly.
          powerManagement.finegrained = lib.mkForce false;

          forceFullCompositionPipeline = true;
        };
      };
    };
  };
}

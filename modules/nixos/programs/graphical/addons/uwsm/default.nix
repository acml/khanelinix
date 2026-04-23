{
  config,
  lib,

  ...
}:
let
  inherit (lib) mkIf;

  cfg = config.khanelinix.programs.graphical.addons.uwsm;
in
{
  options.khanelinix.programs.graphical.addons.uwsm = {
    enable = lib.mkEnableOption "uwsm";
  };

  config = mkIf cfg.enable {
    # UWSM documentation
    # See: https://github.com/Vladimir-csp/uwsm
    programs.uwsm.enable = true;

    khanelinix.home = {
      configFile = {
        "uwsm/env".text = /* Bash */ ''
          export CLUTTER_BACKEND=wayland
          export MOZ_ENABLE_WAYLAND=1
          export MOZ_USE_XINPUT2=1
          export WLR_DRM_NO_ATOMIC=1
          export XDG_SESSION_TYPE=wayland
          export _JAVA_AWT_WM_NONREPARENTING=1
          export __GL_GSYNC_ALLOWED=0
          export __GL_VRR_ALLOWED=0
          export QT_QPA_PLATFORM=wayland
          export GBM_BACKEND=nvidia-drm
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export NIXOS_OZONE_WL=1
          export WLR_NO_HARDWARE_CURSORS=1
        '';
        # Debug variables (commented out by default)
        #export AQ_TRACE="1"
        #export HYPRLAND_LOG_WLR="1"
        #export HYPRLAND_TRACE="1"
      };
    };
  };
}

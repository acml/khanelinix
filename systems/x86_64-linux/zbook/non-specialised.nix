(
  {
    lib,
    config,
    ...
  }:
  {
    config = lib.mkIf (config.specialisation != { }) {
      # Config that should only apply to the default system, not the specialised ones

      khanelinix = {
        display-managers = {
          gdm = {
            defaultSession = "gnome";
          };
        };

        programs = {
          graphical = {
            desktop-environment = {
              gnome = {
                enable = true;
                # shell.favorite-apps = [
                #   "org.gnome.Nautilus.desktop"
                #   "org.gnome.Console.desktop"
                #   "firefox-devedition.desktop"
                #   "steam.desktop"
                #   "org.vinegarhq.Sober.desktop"
                # ];
              };
            };
          };
        };

      };
    };

  }
)

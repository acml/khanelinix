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
              };
            };
          };
        };

      };
    };

  }
)

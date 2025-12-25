{
  # config,
  # lib,
  ...
}:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "data";
        source = ''
          $5            ___   __
          $4     /¯\$5    \  \ /  ;
          $4     \  \$5    \  v  /
          $4  /¯¯¯   ¯¯¯¯\$5\   /  $6/\
          $4 ’————————————·$5\  \ $6/  ;
          $3      /¯¯;      $5\ /$6/  /_
          $3_____/  /        $5‘$6/     \
          $3\      /$1,        $6/  /¯¯¯¯
          $3 ¯¯/  /$1/ \      $6/__/     
          $3  .  / $1\  \$2·————————————.
          $3   \/  $1/   \$2\_____   ___/
          $1      /  ,  \$2     \  \
          $1      \_/ \__\$2     \_/'';
        color = {
          "1" = "bright_blue";
          "2" = "bright_cyan";
          "3" = "bright_magenta";
          "4" = "bright_red";
          "5" = "bright_yellow";
          "6" = "bright_green";
        };
        padding = {
          left = 1;
          right = 2;
        };
      };

      display = {
        separator = "   ";
        temp.unit = "C";
        key.type = "icon";
      };

      modules = [
        {
          type = "title";
          color = {
            user = "bright_blue";
            host = "bright_cyan";
          };
        }
        {
          type = "separator";
          string = "─";
        }
        {
          type = "cpu";
          keyColor = "bright_red";
          format = "{name}";
        }
        {
          type = "memory";
          keyColor = "bright_yellow";
          format = "{total}";
        }
        {
          type = "gpu";
          keyColor = "bright_green";
          format = "{name}";
        }
        {
          type = "disk";
          keyColor = "bright_blue";
          format = "{size-total} {size-percentage}";
          folders = [ "/" ];
        }
        {
          type = "separator";
          string = "─";
        }
        {
          type = "os";
          keyColor = "bright_red";
          keyIcon = "";
          format = "{name} {version-id}";
        }
        {
          type = "uptime";
          keyColor = "bright_yellow";
        }
        {
          type = "packages";
          keyColor = "bright_green";
          keyIcon = "󰏗";
          format = "{nix-system} nix, {nix-user} home";
        }
        {
          type = "de";
          keyColor = "bright_cyan";
        }
        {
          type = "terminal";
          keyColor = "bright_blue";
        }
        {
          type = "shell";
          keyColor = "bright_magenta";
        }
      ];
    };
  };
}

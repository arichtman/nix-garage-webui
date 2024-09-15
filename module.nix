{ config, lib, pkgs, ...}:
let
  cfg = config.services.daveyjones;
in
{
  options = {
    services.garage-webui = {
      enabled = lib.options.mkOption {
        description = "Enable garage-webui service";
        default = false;
        type = lib.types.bool;
      };
      config = lib.options.mkOption {
        description = "Nix expression that will be written to config file.";
        default = "{}";
        type = lib.types.attrs;
        example = ''
          {
            topic = {
              default = "prometheusalerts";
              label = "topic";
            };
            ntfy = {
              url = "https://ntfy.example.com/";
              username = "user";
              password = "password";
            };
            templates = {
              title = "...";
              message = ''''''
                abcd
                '''''';
            };
          }
          '';
      };
    };
  };
  config = lib.mkIf cfg.enabled {
    # TODO: Integrate this better with systemd for privacy.
    system.environment.etc.garage-webui = {
      "config.toml" = {
        # Ref: https://github.com/NixOS/nixpkgs/blob/4ffc4dc91838df228c8214162c106c24ec8fe03f/nixos/modules/programs/starship.nix#L10
        source = builtins.writeText (pkgs.formats.toml.generate "config.toml" cfg.config);
        mode = "0444";
      };
    };
    systemd.services.garage-webui = {
      description = "Web UI for Garage";
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.daveyjones}/bin/garage-webui";
        StateDirectory = "/var/lib/garage-webui";
        DynamicUser = true;
        Restart = "on-failure";
        AmbientCapabilities = "cap_net_bind_service";
        RestartSec = 5;
      };
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
    };
  };
}

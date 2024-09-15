# nix-garage-webui

Nix packaging and NixOS module for Garage Webui.

## Usage

`flake.nix`:

```
{
  inputs = {
    davyjones.url = "github:arichtman/nix-garage-webui";
  }
  {...}:{

  }
}
```

## Development

Testing can be done by building a bare-bones NixOS configuration and inspecting it.
`nix build .#nixosConfigurations.test.config.system.build.toplevel`


{
  description = "A declarative, reproducible, and secure NixOS configuration ecosystem.";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    home-managerU = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-managerS = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";
    catppuccin.url = "github:catppuccin/nix";

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    millennium = {
      url = "github:SteamClientHomebrew/Millennium?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    herdr = {
      url = "github:herdrdev/herdr";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
    };
  };

  outputs = {
    nixpkgs-unstable,
    nixpkgs-stable,
    home-managerU,
    home-managerS,
    agenix,
    flatpaks,
    catppuccin,
    lanzaboote,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    libU = nixpkgs-unstable.lib;

    mkWorkstation = {
      deviceModule,
      hmImports,
    }:
      libU.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          deviceModule
          home-managerU.nixosModules.home-manager
          flatpaks.nixosModules.default
          agenix.nixosModules.default
          catppuccin.nixosModules.catppuccin
          lanzaboote.nixosModules.lanzaboote
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                (
                  {osConfig, ...}: {
                    _module.args.hostName = osConfig.networking.hostName;
                  }
                )
              ];
              users.jampyvi = {
                imports = hmImports;
              };
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      huskynix = mkWorkstation {
        deviceModule = ./devices/desktop/huskynix/default.nix;
        hmImports = [
          ./home/common.nix
          ./home/shell/zsh
          ./home/niri.nix
          catppuccin.homeModules.catppuccin
        ];
      };

      pugnix = nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          "${nixpkgs-stable}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          ./devices/server/pugnix/default.nix
          home-managerS.nixosModules.home-manager
          catppuccin.nixosModules.catppuccin
          {
            nixpkgs.overlays = [
              (_final: prev: {
                nodejs_22 = prev.nodejs_24;
                sqlite = prev.sqlite.overrideAttrs (_oldAttrs: {
                  version = "3.51.3";
                  doCheck = false;
                  src = prev.fetchurl {
                    url = "https://sqlite.org/2026/sqlite-src-3510300.zip";
                    hash = "sha256-+KZ6H1tcrnxtQvCZTKe/GkpYWIaMgq3J/BNAvtXrjNI=";
                  };
                });
              })
            ];
          }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = {inherit inputs;};
              sharedModules = [
                (
                  {osConfig, ...}: {
                    _module.args.hostName = osConfig.networking.hostName;
                  }
                )
              ];
              users.jampyvi = {
                imports = [
                  ./home/shell/zsh
                  ./home/programs/hermes.nix
                  catppuccin.homeModules.catppuccin
                  inputs.hermes-agent.homeManagerModules.default
                  {
                    home = {
                      username = "jampyvi";
                      homeDirectory = "/home/jampyvi";
                      stateVersion = "26.05";
                    };
                    catppuccin.autoEnable = true;
                    programs.home-manager.enable = true;
                    programs.btop = {
                      enable = true;
                      settings = {
                        theme_background = true;
                        truecolor = true;
                      };
                    };
                  }
                ];
              };
            };
          }
        ];
      };
    };
    packages.x86_64-linux = {
      pugnix-image = inputs.self.nixosConfigurations.pugnix.config.system.build.sdImage;
    };
  };
}

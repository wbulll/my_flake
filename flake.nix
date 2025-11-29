{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#nixpkgs.url = "github:nixos/nixpkgs?rev=ae814fd3904b621d8ab97418f1d0f2eb0d3716f4"; 

 };
  outputs = { self, nixpkgs }: {
      nixosConfigurations.oto = nixpkgs.lib.nixosSystem {
          modules = [ ./configuration.nix ];
    };
  };
}

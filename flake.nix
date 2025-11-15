{
	description = "Hyprland on Nixos";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable"; 
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs"; 
		}; 
	};

	outputs = { nixpkgs, home-manager, ... }: {
		nixosConfigurations.arjester = nixpkgs.lib.nixosSystem {
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.arjester = import ./home.nix;
						backupFileExtension = "backup"; 
					};
				}
			];
		}; 
	};	
} 

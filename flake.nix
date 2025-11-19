{
	description = "Arjester's Based Nixos Configs";

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
				./hosts/lenovo/configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.arjester = import ./modules/home.nix;
						backupFileExtension = "backup"; 
					};
				}
			];
		}; 
	};	
} 

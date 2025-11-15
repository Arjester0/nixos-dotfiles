 { config, pkgs, ... }: 

 {
 	home.username = "arjester"; 
	home.homeDirectory = "/home/arjester";
	home.stateVersion = "25.05";
	programs.git.enable = true;
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo i use nix btw";
			vi = "nvim"; 
			nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
		};
		profileExtra = ''
			if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
				exec hyprland
			fi 
		'';
	};

	home.packages = with pkgs; [
	    neovim 
	    ripgrep
	    nixpkgs-fmt
	    gcc
	    rofi 
	]; 

	home.file.".config/hypr".source = ./config/hypr; 
	home.file.".config/waybar".source = ./config/waybar; 
	home.file.".config/nvim".source = ./config/nvim; 
 }

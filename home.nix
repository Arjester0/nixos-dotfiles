 { config, pkgs, ... }: 

 let 
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config"; 
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

    # .config/directory 
    configs = {
	nvim = "nvim";
	hypr = "hypr"; 
	rofi = "rofi";
	waybar = "waybar"; 
	kitty = "kitty";
	tmux = "tmux"; 
    };
 in 

 {
 	home.username = "arjester"; 
	home.homeDirectory = "/home/arjester";
	home.stateVersion = "25.05";
	programs.git.enable = true;
	programs.bash = {
		enable = true;
		sessionVariables = {
		    PATH = "$HOME/.cargo/bin:$PATH"; 
		};
		shellAliases = {
			vi = "nvim"; 
			nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
			config = "cd ~/nixos-dotfiles/config"; 
			qs = "quickshot"; 
		};
		profileExtra = ''
			if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
				exec hyprland
			fi 
		'';
	};
	programs.fzf.enable = true;

	xdg.configFile = builtins.mapAttrs
	    (name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
		force = true;
	    })
	    configs; 

	home.packages = with pkgs; [
	    neovim 
	    ripgrep
	    nixpkgs-fmt
	    gcc
	    rofi 
	    fzf
	]; 
 }

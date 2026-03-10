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
	mako = "mako";
    };
 in 

 {
	 imports = [
	    ./zsh.nix
	    ./cursor.nix
	    ./direnv.nix
	    ./zellij.nix
	    ./helix.nix
	]; 
 	home.username = "arjester"; 
	home.homeDirectory = "/home/arjester";
	home.stateVersion = "25.05";
	programs.git.enable = true;
	programs.zoxide = {
	    enable = true;
	    enableZshIntegration = true;
	}; 

	gtk = {
	  enable = true;
	  theme = {
	    name = "Colloid-Dark";
	    package = pkgs.colloid-gtk-theme.override {
	      tweaks = [ "black" ];
	      colorVariants = [ "dark" ];
	    };
	  };
	  iconTheme = {
	    name = "Colloid-Dark";
	    package = pkgs.colloid-icon-theme.override {
	      colorVariants = [ "default" ];
	    };
	  };
	  cursorTheme = {
	    name = "Bibata-Original-Classic";
	    size = 24;
	  };
	  font = {
	    name = "Noto Sans";
	    size = 11;
	  };
	};

	home.sessionVariables = {
	  GTK_THEME = "Colloid-Dark";
	};
	```

	And update the env vars in `hyprland.conf`:
	```
	env = GTK_THEME,Colloid-Dark
	env = GTK_ICON_THEME,Colloid-Dark

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
	    eza
	    bat
	    fd
	    jq
	    tokei
	    dust
	    nixd
	    nixfmt-rfc-style
	]; 
 }


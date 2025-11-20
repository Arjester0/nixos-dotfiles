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
	 imports = [
	    ./zsh.nix
	    ./cursor.nix
	]; 
 	home.username = "arjester"; 
	home.homeDirectory = "/home/arjester";
	home.stateVersion = "25.05";
	programs.git.enable = true;

	xdg.configFile = builtins.mapAttrs
	    (name: subpath: {
		source = create_symlink "${dotfiles}/${subpath}";
		recursive = true;
		force = true;
	    })
	    configs; 
	
	  home.pointerCursor = 
    let 
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 48;
          package = 
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom 
        "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
        "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
        "Fuchsia-Pop";

	home.packages = with pkgs; [
	    neovim 
	    ripgrep
	    nixpkgs-fmt
	    gcc
	    rofi 
	    fzf
	    zsh
	]; 
 }


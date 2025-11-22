{ 
	programs.zsh = {
	    enable = true;
	    enableCompletion = true;
	    autosuggestion.enable = true;
	    syntaxHighlighting.enable = true;

	    sessionVariables = {
		PATH = "$HOME/.cargo/bin:$PATH"; 
		HYPRSHOT_DIR = "$HOME/Pictures/screenshots";
	    };

	    shellAliases = {
		ll = "ls -l";
		vi = "nvim"; 
		nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#arjester";
		config = "cd ~/nixos-dotfiles/config"; 
		qs = "quickshot"; 
	    }; 
	    
	    history.size = 10000;
	    history.ignoreAllDups = true;
	    history.path = "$HOME/.zsh_history";
	    history.ignorePatterns = ["rm *" "pkill *" "cp *"]; 

	    profileExtra = ''
	     if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
	      exec hyprland
	     fi 
	    '';
	    initExtra = ''
		fastfetch
	    ''; 
	    oh-my-zsh = {
		enable = true;
		plugins = [];
		theme = "robbyrussell";
	    }; 
	}; 
	programs.fzf.enable = true;
} 

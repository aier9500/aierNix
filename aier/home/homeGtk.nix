{ config, pkgs, ... }: 

{ 

	# Tell QT to follow adwaita
	qt = {	
		enable = true; 
		platformTheme.name = "adwaita"; 
		style = {
			package = [
				pkgs.adwaita-qt
				pkgs.adwaita-qt6
      ];
			name = "adwaita";
		};
	};


  gtk = { 

  	enable = true; 

  };

}
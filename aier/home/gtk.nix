{ config, pkgs, ... }: 

{ 

	# Tell QT to follow adwaita
	qt = {	
		enable = true; 
		platformTheme.name = "gtk"; 
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

		# ~/.config/gtk-3.0/gtk.css
  	gtk3.extraCss = "
      button.titlebutton,
      windowcontrols > button {
        color: transparent;
        min-width: 16px;
        min-height: 16px;
        box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.2);
      }

      button.titlebutton:backdrop {
        opacity: 0.5;
      }

      windowcontrols > button {
        border-radius: 100%;
        padding: 0;
        margin: 0 3px;
      }

      windowcontrols > button > image {
        padding: 0;
      }

      button.titlebutton {
        margin: 0 2px;
      }

      .titlebar .right {
        margin-right: 8px;
      }

      .titlebar .left {
        margin-left: 8px;
      }

      windowcontrols.end {
        margin-right: 8px;
      }

      windowcontrols.start {
        margin-left: 8px;
      }

      button.titlebutton.close, button.titlebutton.close:hover:backdrop,
      windowcontrols > button.close,
      windowcontrols > button.close:hover:backdrop {
        background-color: #D20F39;
      }

      button.titlebutton.close:hover,
      windowcontrols > button.close:hover {
        background-color: #ED8796;
      }

      button.titlebutton.maximize, button.titlebutton.maximize:hover:backdrop,
      windowcontrols > button.maximize,
      windowcontrols > button.maximize:hover:backdrop {
        background-color: #40A02B;
      }

      button.titlebutton.maximize:hover,
      windowcontrols > button.maximize:hover {
        background-color: #A6DA95;
      }

      button.titlebutton.minimize, button.titlebutton.minimize:hover:backdrop,
      windowcontrols > button.minimize,
      windowcontrols > button.minimize:hover:backdrop {
        background-color: #DF8E1D;
      }

      button.titlebutton.minimize:hover,
      windowcontrols > button.minimize:hover {
        background-color: #EED49F;
      }

      button.titlebutton.close:backdrop, button.titlebutton.maximize:backdrop, button.titlebutton.minimize:backdrop,
      windowcontrols > button.close:backdrop,
      windowcontrols > button.maximize:backdrop,
      windowcontrols > button.minimize:backdrop {
        background-color: #c0bfc0;
      }
    ";

		# ~/.config/gtk-4.0/gtk.css
    gtk4.extraCss = "
			button.titlebutton,
			windowcontrols > button {
				color: transparent;
				min-width: 16px;
				min-height: 16px;
				box-shadow: inset 0 0 0 1px rgba(0, 0, 0, 0.2);
			}

			button.titlebutton:backdrop {
				opacity: 0.5;
			}

			windowcontrols > button {
				border-radius: 100%;
				padding: 0;
				margin: 0 3px;
			}

			windowcontrols > button > image {
				padding: 0;
			}

			button.titlebutton {
				margin: 0 2px;
			}

			.titlebar .right {
				margin-right: 8px;
			}

			.titlebar .left {
				margin-left: 8px;
			}

			windowcontrols.end {
				margin-right: 8px;
			}

			windowcontrols.start {
				margin-left: 8px;
			}

			button.titlebutton.close, button.titlebutton.close:hover:backdrop,
			windowcontrols > button.close,
			windowcontrols > button.close:hover:backdrop {
				background-color: #D20F39;
			}

			button.titlebutton.close:hover,
			windowcontrols > button.close:hover {
				background-color: #ED8796;
			}

			button.titlebutton.maximize, button.titlebutton.maximize:hover:backdrop,
			windowcontrols > button.maximize,
			windowcontrols > button.maximize:hover:backdrop {
				background-color: #40A02B;
			}

			button.titlebutton.maximize:hover,
			windowcontrols > button.maximize:hover {
				background-color: #A6DA95;
			}

			button.titlebutton.minimize, button.titlebutton.minimize:hover:backdrop,
			windowcontrols > button.minimize,
			windowcontrols > button.minimize:hover:backdrop {
				background-color: #DF8E1D;
			}

			button.titlebutton.minimize:hover,
			windowcontrols > button.minimize:hover {
				background-color: #EED49F;
			}

			button.titlebutton.close:backdrop, button.titlebutton.maximize:backdrop, button.titlebutton.minimize:backdrop,
			windowcontrols > button.close:backdrop,
			windowcontrols > button.maximize:backdrop,
			windowcontrols > button.minimize:backdrop {
				background-color: #c0bfc0;
			}
    ";


  };

}
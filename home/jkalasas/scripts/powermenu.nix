{ config, pkgs, ... }:
let
  rofi-powermenu = pkgs.writeShellScriptBin "rofi-powermenu" ''
    #!/usr/bin/env bash
    lockfile="~/.cache/lockscreen.png";
    rofi_conf_dir="${config.xdg.configHome}/rofi";
    powermenu_conf="$rofi_conf_dir/powermenu.rasi"
    rofi_command="rofi -theme $powermenu_conf"

    uptime=$(uptime -p | sed -e 's/up //g')

    # Options
    if [[ "$DIR" == "powermenus" ]]; then
    	shutdown="⏻"
    	reboot="󰜉"
    	lock=""
    	suspend="󰤄"
    	ddir="$rofi_conf_dir"
    else

    # For some reason the Icons are mess up I don't know why but to fix it uncomment section 2 and comment section 1 but if the section 1 icons are mess up uncomment section 2 and comment section 1

    	# Buttons
    	layout=`cat $powermenu_conf | grep BUTTON | cut -d'=' -f2 | tr -d '[:blank:],*/'`
    	if [[ "$layout" == "TRUE" ]]; then
      # Section 1

    		shutdown="⏻"
    		reboot="󰜉"
    		lock=""
    		suspend="󰤄"
      # Section 2
    #		shutdown="襤"
    #		reboot="ﰇ"
    #		lock=""
    #		suspend="鈴"
    #		logout=" "


    	else
      # Section 1
    		shutdown="⏻ Shutdown"
    		reboot="󰜉 Restart"
    		lock=" Lock"
    		suspend="󰤄 Sleep"
      # Section 2
    #		shutdown="襤Shutdown"
    #		reboot="ﰇ Restart"
    #		lock=" Lock"
    #		suspend="鈴Sleep"
    #		logout=" Logout"
    	fi
    	ddir="$rofi_conf_dir"
    fi

    # Ask for confirmation
    rdialog () {
    rofi -dmenu\
        -i\
        -no-fixed-num-lines\
        -p "Are You Sure? : "\
        -theme "$ddir/confirm.rasi"
    }

    # Display Help
    show_msg() {
    	rofi -theme "$ddir/askpass.rasi" -e "Options : yes / no / y / n"
    }

    # Variable passed to rofi
    options="$lock\n$suspend\n$reboot\n$shutdown"

    chosen="$(echo -e "$options" | $rofi_command -p "UP - $uptime" -dmenu -selected-row 0)"
    case $chosen in
        $shutdown)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			systemctl poweroff
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
        $reboot)
    		ans=$(rdialog &)
            if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
    			systemctl reboot
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
        $lock)
            (grim $lockfile; convert $lockfile -blur 0x4 $lockfile; swaylock --image $lockfile) &
            ;;
        $suspend)
    		ans=$(rdialog &)
    		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
                (grim $lockfile; convert $lockfile -blur 0x4 $lockfile; swaylock --image $lockfile) &
                sleep 1
    			systemctl suspend
    		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
    			exit
            else
    			show_msg
            fi
            ;;
    esac
  '';
in
{
  home.packages = with pkgs; [
    rofi-powermenu
  ];
}

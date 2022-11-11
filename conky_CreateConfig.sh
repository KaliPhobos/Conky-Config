echo "-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the \`--\`):
--
--   print(\"Loading Conky config\")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html

conky.config = {
    alignment = 'top_left',
    background = false,
    border_width = 1,
    cpu_avg_samples = 2,
    default_color = '#555',
    default_outline_color = 'white',
    default_shade_color = 'white',
    display = 35651607,
    double_buffer = true,
    draw_borders = false,
    draw_graph_borders = true,
    draw_outline = false,
    draw_shades = false,
    extra_newline = false,
    font = 'DejaVu Sans Mono:size=8',
    format_human_readable = true,
    gap_x = 10,
    gap_y = 10,
    minimum_height = 5,
    minimum_width = 5,
    maximum_width = 280,
    net_avg_samples = 2,
    no_buffers = false,
    out_to_console = false,
    out_to_ncurses = false,
    out_to_stderr = false,
    out_to_x = true,
    own_window = true,
    own_window_transparent = true,
    own_window_argb_visual = true,
    own_window_class = 'Conky',
    own_window_type = 'override',
    show_graph_range = false,
    show_graph_scale = false,
    stippled_borders = 0,
    update_interval = 1.0,
    uppercase = false,
    use_spacer = 'none',
    use_xft = true,
}

conky.text = [["









# Show time+date and general hardware info
echo "\$alignc\${color #999}\${time %A %d.%m.%Y - %T}\$color"
echo "\$alignc\${color #555}\$nodename - \$kernel on \$machine\$color"
echo "\${color #555}CPU \${color #999}\$freq_g\${color #555} @ \${color #999}\$cpu%\${color #555} \${goto 100}Temp:\${color #999} \${hwmon 1 temp 1 1 0}°\${color #555}C\$alignr Uptime \${color #999}\$uptime"

# Show CPU usage (all cores combined)
echo "\${cpugraph 32,280}"

# Get the CPU core count
CoreCount=$(cat /proc/cpuinfo | grep processor | wc -l)

# Change count of cores here for testing purposes
# CoreCount=5
#echo "corecount $CoreCount"

# Draw a separate CPU statistic for each of the cores
# Check the number of cores
if [ $CoreCount -le 6 ] ; then
    # 6 or less cores - do 2 in each line
    Count=0
    while [ $Count -lt $CoreCount ]
    do
        # check if there's 2 or more cores left
        if [ $((Count+2)) -le $CoreCount ] ; then
            # draw two diagrams
            echo "\${color #33f}CPU $Count \${color #555}\${freq_g $Count}GHz, \${color #85f}\${cpu cpu$Count}% \${goto 145} \${color #33f}CPU ${Count+1} \${color #555}\${freq_g ${Count+1}}GHz, \${color #85f}\${cpu cpu${Count+1}}%"
            echo "\${cpugraph cpu$Count 24,135} \${goto 145} \${cpugraph cpu${Count+1} 24,135}"
            Count=$((Count+2))
        else
            # only one core left (off core count, dafuq?), draw only a single diagram
            echo "\${color #33f}CPU $Count \${color #555}\${freq_g $Count}GHz, \${color #85f}\${cpu cpu$Count}%"
            echo "\${cpugraph cpu$Count 24,135}"
            Count=$((Count+1))
        fi
    done
else
    # more than 6 Cores, lets to 4 in each row
    Count=0
    while [ $Count -lt $CoreCount ]
    do
        # check if there's 4 or more cores left
        if [ $((Count+4)) -le $CoreCount ] ; then
            # draw 4 diagrams
            echo "\${color #33f}CPU $Count \${color #85f}\${cpu cpu$Count}% \${goto 72} \${color #33f}CPU $(($Count+1)) \${color #85f}\${cpu cpu$(($Count+1))}% \${goto 144} \${color #33f}CPU $(($Count+2)) \${color #85f}\${cpu cpu$(($Count+2))}% \${goto 216} \${color #33f}CPU $(($Count+3)) \${color #85f}\${cpu cpu$(($Count+3))}%"
            echo "\${cpugraph cpu$Count 24,64} \${goto 72} \${cpugraph cpu$(($Count+1)) 24,64} \${goto 144} \${cpugraph cpu$(($Count+2)) 24,64} \${goto 216} \${cpugraph cpu$(($Count+3)) 24,64}"
            Count=$((Count+4))
        elif [ $((Count+3)) -le $CoreCount ] ; then
            # draw 3 diagrams
            echo "\${color #33f}CPU $Count \${color #85f}\${cpu cpu$Count}% \${goto 72} \${color #33f}CPU $(($Count+1)) \${color #85f}\${cpu cpu$(($Count+1))}% \${goto 144} \${color #33f}CPU $(($Count+2)) \${color #85f}\${cpu cpu$(($Count+2))}%"
            echo "\${cpugraph cpu$Count 24,64} \${goto 72} \${cpugraph cpu$(($Count+1)) 24,64} \${goto 144} \${cpugraph cpu$(($Count+2)) 24,64}"
            Count=$((Count+3))
        elif [ $((Count+2)) -le $CoreCount ] ; then
            # draw 2 diagrams
            echo "\${color #33f}CPU $Count \${color #85f}\${cpu cpu$Count}% \${goto 72} \${color #33f}CPU $(($Count+1)) \${color #85f}\${cpu cpu$(($Count+1))}%"
            echo "\${cpugraph cpu$Count 24,64} \${goto 72} \${cpugraph cpu$(($Count+1)) 24,64}"
            Count=$((Count+2))
        elif [ $((Count+1)) -le $CoreCount ] ; then
            # draw 1 diagram
            echo "\${color #33f}CPU $Count \${color #85f}\${cpu cpu$Count}%"
            echo "\${cpugraph cpu$Count 24,64}"
            Count=$((Count+1))
        else
            # condition is impossible to reach
            echo "\${color red}Solar storm? You broke math\$color"
        fi
    done
fi

# Get a list of all network interfaces that are either UP or RUNNING (only their names)
Interfaces=$(ifconfig | grep "UP\|RUNNING" | awk '{print $1}' | grep ':' | tr -d ':' | grep -v lo)
for Line in $Interfaces
do
    echo "\${color #33f}$Line: IP=\${color #85f}\${addr $Line} \${color #33f}\${hr 1}"
    echo "\${color #555}Wireless signal: \${color #080}\${wireless_link_qual $Line}%\${color #555}, \${color #080}\${downspeedf $Line} \${color #555}Kb/sec"
    echo "\${color #080}Uploaded: \${color #999}\${totalup $Line} \${goto 145} \${color #800}Downloaded: \${color #999}\${totaldown $Line}"
    echo "\${color #070}Current Up:\${color #999} \${upspeed $Line}\${goto 145} \${color #700}Current Down:\${color #999} \${downspeed $Line}"
    echo "\${color #040}\${upspeedgraph $Line 32,135}  \${color #400}\${downspeedgraph $Line 32,135}\${color red}"
done

echo "\${color #33f}ping: \${color #85f}\${execpi 1 /etc/conky/conky_Ping.sh 2>&1}\${color #33f}ms \${hr 1}"




echo "]]"

if [ "$(tty)" = "/dev/tty1" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    startx
fi

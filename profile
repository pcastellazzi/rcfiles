case $- in
    *i*)
        command -v fish >/dev/null && exec fish
        ;;
esac

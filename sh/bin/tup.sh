#!/bin/sh

tup() {

    help() {
        printf "\n%s\n%s\n" "To update time using the NTP pool, use the \"-n\" flag" \
            "To update the time using the Ubuntu timeserver, use the \"-u\" flag"
    }

    # Invoke the "help" function when used without flags and arguments
    if [ $# -eq 0 ]; then
        help
        return
    fi

    packages="ntp ntpdate"
    for package in ${packages}; do
        status=$(dpkg-query -W -f='${Status}\n' "${package}" | grep -c "ok installed")
        if [ "${status}" -eq 0 ]; then
            sudo apt install "${package}" -y
        fi
    done

#     sudo apt install ntp ntpdate -y
    sudo service ntp stop

    while getopts "nuh" opts
    do
        case ${opts} in
            n)
                sudo ntpdate pool.ntp.org
                ;;
            u)
                sudo ntpdate ntp.ubuntu.com
                ;;
            h)
                help
                return
                ;;
            \?)
                printf "\n%s" "Invalid character. Exiting..."
                return
                ;;
            *)
                printf "\n%s" "That's not quite right. Try again."
                return
                ;;
        esac
    done

    sudo service ntp start

}

tup "$@"

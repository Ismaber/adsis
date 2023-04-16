#!/bin/bash
# 796902, Berdusan Muñoz, Ismael, T, 1, A
# 819684, Helali Amoura, Zineb, T, 1, A

check_privileges() {
    if [ $EUID -ne 0 ]; then
        echo "Este script necesita privilegios de administracion"
        exit 1
    fi
}

check_parameters() {
    if [ $# -ne 2 ]; then
        echo "Numero incorrecto de parametros"
        exit 1
    fi
}

create_user() {
    local username="${1}"
    local password="${2}"
    local fullname="${3}"
    
    useradd -m -k /etc/skel -U -K UID_MIN=1815 -c "${fullname}" "${username}" &>/dev/null
    if [ $? -eq 0 ]; then
        usermod -aG 'sudo' ${username}
        passwd -x 30 ${username} &>/dev/null
        echo "${username}:${password}" | chpasswd
        echo "${fullname} ha sido creado"
    else
        echo "El usuario ${username} ya existe"
    fi
}

delete_user() {
    local username="${1}"
    
    local home_usuario="$(getent passwd ${username} | cut -d: -f6)"
    tar cvf /extra/backup/${username}.tar $home_usuario &>/dev/null
    if [ $? -eq 0 ]; then
        userdel -f ${username} &>/dev/null
    fi
}

process_file() {
    local option="${1}"
    local file="${2}"
    
    while read -r usuario; do
        IFS=,
        read -ra campos <<< "$usuario"
        
        if [ ${#campos[@]} -ne 3 ]; then
            exit 1
        fi
        
        for i in "${campos[@]}"; do
            if [ -z "$i" ]; then
                echo "Campo invalido"
                exit 1
            fi
        done
        
        if [ "${option}" = "-a" ]; then
            create_user "${campos[0]}" "${campos[1]}" "${campos[2]}"
        elif [ "${option}" = "-s" ]; then
            delete_user "${campos[0]}"
        else
            echo "Opcion invalida" 1>&2
        fi
    done < "${file}"
}

main() {
    check_privileges
    check_parameters "$@"
    process_file "$@"
}

main "$@"

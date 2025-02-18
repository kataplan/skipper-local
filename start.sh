#!/bin/bash
version="1.0.0"

# Colors
color_background_green='\e[48;5;22m'
color_background_orange='\e[48;5;202m'
color_reset='\033[0m'

echo -e "${color_background_green}┌───────────────────────────┐${color_reset}"
echo -e "${color_background_green}│ local-architecture v${version} │${color_reset}"
echo -e "${color_background_green}└───────────────────────────┘${color_reset}\n"

# Selectable systems
readonly SKIPPER_FRONT="skipper-front"
readonly SKIPPER_API="skipper-api"

selectable_systems=("$SKIPPER_FRONT" "$SKIPPER_API")
log_file="$(pwd)/$(date '+%Y-%m-%d_%H:%M:%S').log"

# Base systems (not selectable)
readonly POSTGRES="postgres"
readonly PGADMIN="pgadmin"

# The variables for systems that the user chooses
user_input=""
systems_tools=""

##########################
# Functions
##########################
verify_user_input() {
    # Check if each input is valid, if not, exits
    for input in "${user_input[@]}"; do
        if [[ ! " ${selectable_systems[@]} " =~ " ${input} " ]]; then
            echo "Invalid input: ${input}"
            exit 1
        fi
    done
}

install_systems() {
    echo -e "\n\e[48;5;22mChecking systems installation... \e[0m"

    for system in "${user_input[@]}"; do
        system_folder_path="./systems/$system"
        if [ ! -d "$system_folder_path" ]; then
            echo "Installing $system ..."

            mkdir -p ./systems/$system
            cd ./systems/$system && git init . > $log_file && cd - >> $log_file
            cd ./systems/$system && git remote add origin git@github.com:kataplan/$system.git >> $log_file && cd - >> $log_file
            cd ./systems/$system && git fetch >> $log_file && cd - >> $log_file
            cd ./systems/$system && git checkout production >> $log_file && cd - >> $log_file
            cd ./systems/$system && git config core.filemode false >> $log_file && cd - >> $log_file

            echo -e "\e[32m\u2714\e[0m $system installed"
        else
            echo -e "\e[32m\u2714\e[0m $system already installed"
        fi
    done
}


add_systems_tools() {
    # No additional tools needed for skipper systems
    systems_tools=()
}
##########################
# / Functions
##########################

################
# Start
################
echo -e "${color_background_green}Systems:${color_reset}"
for system in "${selectable_systems[@]}"; do
    echo -e "${color_background_orange}${system}${color_reset}"
done
read -p "Which systems you want to start? (write them separated by a space): " read_user_input
# Once the user input was read, split it into an array
IFS=' ' read -r -a user_input <<< "$read_user_input"

verify_user_input ""

install_systems ""

add_systems_tools ""

#############################
# Start Docker Compose
#############################
# Start only the Docker services specified by the user.
# Then it checks if in Linux Docker needs sudo. In MacOS and Win we assume that it doesn't need
if [ $OSTYPE == "linux-gnu" ] && ! id -nG "$USER" | grep -qw docker; then
    sudo docker compose up --build "${user_input[@]}" "$POSTGRES" "$PGADMIN"
else
    docker compose up --build "${user_input[@]}" "$POSTGRES" "$PGADMIN"
fi
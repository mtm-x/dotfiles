# we added a config file for you to customize HyDE before loading zshrc
# Edit $ZDOTDIR/.user.zsh to customize HyDE before loading zshrc

#  Plugins 
# oh-my-zsh plugins are loaded  in $ZDOTDIR/.user.zsh file, see the file for more information

#  Aliases 
# Override aliases here in '$ZDOTDIR/.zshrc' (already set in .zshenv)

# # Helpful aliases
# alias c='clear'                                                        # clear terminal
# alias l='eza -lh --icons=auto'                                         # long list
# alias ls='eza -1 --icons=auto'                                         # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias po='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code'                                                        # gui code editor
alias fastfetch='fastfetch --logo-type kitty'

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
# alias mkdir='mkdir -p'

# Add your configurations here
export EDITOR=vim
export CSCOPE_EDITOR=vim
export DOCKER_CLI_EXPERIMENTAL=enabled
alias dock=~/.config/personal_scripts/docker.sh
# Monitor Swap Aliases
alias desk="~/.config/personal_scripts/monitor.sh --desk"
alias tv="~/.config/personal_scripts/monitor.sh --tv"

alias d1="docker exec -it training-test /bin/bash"
alias cscope='EDITOR=vim cscope'
alias lx="cd ~/Linux/linux_mainline/"
alias linux='cd "$HOME/Linux/linux_mainline"'
alias projects='cd "$HOME/Personal_projects"'
alias config='cd "$HOME/.config"'

# Zephyr exports
export ZEPHYR_SDK_INSTALL_DIR=/opt/sdk/zephyr-sdk-1.0.0
zep() {
	cd "$HOME/zep/zephyr" || return 1
	source "$HOME/zep/.venv/bin/activate"
}

aur() {
	cd "$HOME/zep/zephyr-aurix" || return 1
	source "$HOME/zep/.venv/bin/activate"
	export PATH=/home/mtm/zep/aurix/deps/tricore-gcc/:$PATH && \
	export ZEPHYR_TOOLCHAIN_VARIANT=cross-compile && \
	export CROSS_COMPILE=/home/mtm/zep/aurix/deps/tricore-gcc/bin/tricore-elf- && \
	echo "TriCore Setup: GCC MODE Active"
}

zbuild() {
	local board="${1:-${ZEPHYR_BOARD:-nucleo_f411re}}"
	local build_dir="${2:-build}"
	shift $(( $# > 0 ? 1 : 0 ))
	shift $(( $# > 0 ? 1 : 0 ))
	west build -p auto -b "$board" -d "$build_dir" "$@"
}

zflash() {
	west flash --runner "${ZEPHYR_RUNNER:-openocd}" "$@"
}

ztest() {
	west twister -T . "$@"
}

kbuild() {
	local output_dir="${KBUILD_OUTPUT:-$HOME/.cache/kernel-build}"
	make O="$output_dir" LLVM=1 -j"$(nproc)" "$@"
}

kmenu() {
	local output_dir="${KBUILD_OUTPUT:-$HOME/.cache/kernel-build}"
	make O="$output_dir" LLVM=1 menuconfig
}

rf() {
	[[ -f build/CMakeCache.txt ]] || {
		print "Refusing: build/CMakeCache.txt was not found"
		return 1
	}
	rm -rf -- build
}

venv() {
	source "$HOME/zep/.venv/bin/activate"
}

tas() {
    local bin="/opt/Tools/DAS/8.3.0/bin/tas_server"

    # Check if already running
    if pgrep -f "$bin" >/dev/null 2>&1; then
        echo "tas_server is already running (PID: $(pgrep -f "$bin" | tr '\n' ' '))"
        return 0
    fi

    # Start it fully detached so it survives the parent shell closing
    setsid nohup "$bin" >/tmp/tas_server.log 2>&1 < /dev/null &
    disown

    local pid=$!
    echo "tas_server started with PID: $pid"
}

alias tricore-gdb="/opt/Tools/tricore-gdb/bin/tricore-elf-gdb"
alias tricore-openocd="/opt/Tools/tricore-openocd/bin/openocd"

alias wb='zbuild'
alias wf='zflash'

# Dual monitor walls
alias dualwall="~/.config/personal_scripts/dual_wall.sh --source"
alias dualwallapp="~/.config/personal_scripts/dual_wall.sh --apply-only"
alias TAS_DIR="/home/mtm/aurix/das/TAS_V1_1_0/bin/"
alias hg='kitty +kitten hyperlinked_grep'
alias hp='~/.config/personal_scripts/hypr-profile'

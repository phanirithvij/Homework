largest_file(){
    ls -S | head -1
}

archive_files(){
    path=$1
    ls
    cd $path
    date_=$2

    if [ ! -d archive\-$date_ ]; then
        mkdir "archive-$date_"
    fi

    # FInd files (-type f) at a maxdepth of 1
    # and not newer than $date and exec mv filename to archive-
    find $(pwd) -maxdepth 1 -type f ! -newermt ${date_} -exec mv {} -t archive-$date_ \;

    cd -
}

top_n_mem(){
    n=$1
    top -o %MEM | head -$((7+$n)) #sort by %MEM and head 7 + number of processes
}


tmux_session_htop(){
    tmux new-session \; \
        send-keys 'htop' C-m \; \ #sends htop and return key
        split-window -v \; \ #splits vertcially
        select-pane -U \; \ #changes pane
        split-window -h \; \ # splits horizontally
        send-keys 'source clock.sh' C-m \; \ # sends the clock.sh and return key
        select-pane -D \; \ # changes pane
        send-keys 'sudo tcpdump port 80 or port 443' C-m \; #tcpdump not working without superuser permissions
}

clock_tput(){
    while sleep 1;
    do
        tput sc;tput cup 0 $(($(tput cols)-11));
        echo -e "\e[31m`date +%r`\e[39m";
        tput rc;
    done &
}

SESSION=1

script_start(){
    mkdir -p .dump
    SESSION=$((SESSION+1))
    script -t .dump/$SESSION
}

script_replay(){
    scriptreplay ./dump/$1
}

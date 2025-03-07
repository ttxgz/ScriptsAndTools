#!/bin/bash

# usage: ./run-tcpdump.sh hizhan@165.232.180.183

bar_size=40
bar_char_done="#"
bar_char_todo="-"
bar_percentage_scale=2

function display_usage {
	echo -e "\nThis tool runs tcpdump on a SSH server and download the pcap file. User of this"
	echo -e "tool must have ssh access to the server. The server must have tcpdump installed."
	echo -e "\nusage: $0 [options] <user>@<host>"
	echo -e "\noptions:"
	echo -e "    -h/--help         show this help information."
	echo -e "    -i                SSH identify file, optional."
	echo -e "    -d/--duration     capture duration, in seconds. default to 180."
}

function show_progress {
    current="$1"
    total="$2"

    # calculate the progress in percentage 
    percent=$(bc <<< "scale=$bar_percentage_scale; 100 * $current / $total" )
    # The number of done and todo characters
    done=$(bc <<< "scale=0; $bar_size * $percent / 100" )
    todo=$(bc <<< "scale=0; $bar_size - $done" )

    # build the done and todo sub-bars
    done_sub_bar=$(printf "%${done}s" | tr " " "${bar_char_done}")
    todo_sub_bar=$(printf "%${todo}s" | tr " " "${bar_char_todo}")

    # output the bar
    echo -ne "\rProgress : [${done_sub_bar}${todo_sub_bar}] ${percent}%"
}

POSITIONAL_ARGS=()

identify=""
duration=180   # Default 3 min

while [[ $# -gt 0 ]]; do
  case $1 in
     -i)
      identify="-i $2 "
      shift
      shift
      ;;      
     -d|--duration)
      duration="$2"
      shift
      shift
      ;;
    -h|--help)
      display_usage
      exit 0
      ;;
    -*|--*)
      echo "Error: unknown option $1"
      display_usage
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

set -e

NOW=$(date +"%Y%m%d_%H%M%S")

destination="$1"
server=$(echo $1 | cut -d '@' -f 2)

re='^[0-9]+$'
if ! [[ $duration =~ $re ]] ; then
   echo "Error: Duration is not a number" >&2 
   display_usage
   exit 1
fi

echo destination: ${destination}
echo server: ${server}
echo "capture duration: ${duration} seconds"

file="${server}_${NOW}_${duration}s.pcap"

# Set up server
ssh ${identify} ${destination} "sudo tcpdump -G ${duration} -W 1 -i any -w /tmp/${file} > /tmp/${file}.log 2>&1 &"

echo -e "\nNote: If error occured or connection was lost, you can still try to download the pcap by using following command:"
echo -e "\n        scp ${identify}${destination}:/tmp/${file} .\n"

total_wait=$(( 2 + ${duration} )) # Wait 2 more seconds to ensure tcpdump would already exit when downloading.
for i in $(seq ${total_wait})
do
	sleep 1
	show_progress $i ${total_wait}
done

echo -e "\n\nStart downloading:"
scp ${identify} ${destination}:/tmp/${file} .
scp ${identify} ${destination}:/tmp/${file}.log .

echo -e "\nCleanup server.."
ssh ${identify} ${destination} "sudo rm /tmp/${file}*"

echo "Done."

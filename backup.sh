#!/usr/bin/bash

#https://github.com/Manouchehrsoleymani/devops-bash-scripts-backup.git

VERBOSE_MODE=0
ADD_DATE_TO_FILENAME=""

usage() {
    cat <<EOL
    Usage : $0 [OPTIONS] <source_dir> <backup_name>
    Options:
        -v              : Verbose mode
        --date <format> : Add date to the backup filename.
                          Supported formats: time, date, datetime, timestamp

EOL
}

if [[ $# -le 2 ]]; then
    usage
    exit 1
fi
while true; do
    case $1 in 
        -v)
            VERBOSE_MODE=1
            shift 1
            ;;
        --date)
            case $2 in 
                time)
                    ADD_DATE_TO_FILENAME=$(date +%H%M%S)
                    ;;
                date)
                    ADD_DATE_TO_FILENAME=$(date +%Y%m%d)
                    ;;
                datetime)
                    ADD_DATE_TO_FILENAME=$(date +%Y%m%d-%H%M%S)
                    ;;
                timestamp)
                    ADD_DATE_TO_FILENAME=$(date +%s)
                    ;;
                *)
                    echo "ERROR: Unsupported Date Format..."
                    ;;
            esac
            shift 2
            ;;
        *)
            break
            ;;
    esac
done
if [[ ! $# -eq 2 ]]; then
    usage
    exit 1
fi

if [[ ! -d "$1" ]]; then
    echo "ERROR: $1 should be a directory"
fi
if [[  $2 != *.tar.gz ]]; then
    echo "ERROR: $2 should be a file with .tar.gz extention"
fi

FILENAME="${2##*/}"      #or use filename=$(basename -- "$2")                
DESTINATION="${2:0:${#2} - ${#FILENAME}}"
BACKUP_FILENAME="$DESTINATION${ADD_DATE_TO_FILENAME}-$FILENAME"

# echo $DESTINATION
# echo $BACKUP_FILENAME
if [[ $VERBOSE_MODE -eq 0 ]]; then
    tar -zvcf $BACKUP_FILENAME $1 &> /dev/null
else
    tar -zvcf $BACKUP_FILENAME $1
fi

if [[ -f $BACKUP_FILENAME ]]; then
    echo "backup file created successfully"
else
    echo "could not create backup file.."
fi
#!/usr/bin/env bash
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
version="0.9.0"

cd "$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
root_path=$(pwd)

mkdir -p $root_path/logs
logfile=$root_path/logs/onzcoin.log

set_branch() {
  if [ "$(grep "xxxxxxxxxxxxxxxxxxxxUSE_MASTER_FOR_DEVELOPMENTxxxxxxxxxxxxxxxxxxxxxxxx" $ONZ_CONFIG )" ];then
    GIT_BRANCH="master"
  elif [ "$(grep "aa14b4d84260e00b6fc033c022a25965629ab0e8a4aafc77e64cad4cf0dc2e00" $ONZ_CONFIG )" ];then
    GIT_BRANCH="testnet"
  else
    GIT_BRANCH="unknown"
  fi
}

ONZ_CONFIG="config.json"
DB_NAME="$(grep "database" $ONZ_CONFIG | cut -f 4 -d '"' | head -1)"
DB_UNAME="$(grep "user" $ONZ_CONFIG | cut -f 4 -d '"' | head -1)"
DB_PASSWD="$(grep "password" $ONZ_CONFIG | cut -f 4 -d '"' | head -1)"
GIT_ROOT="https://github.com/onzcoin"
GIT_BRANCH=""
set_branch
BLOCKCHAIN_URL="https://onzcoin.com/snapshots/$GIT_BRANCH/latest"
DB_SNAPSHOT="blockchain.db.gz"

install_prereq() {

    if [[ ! -f /usr/bin/sudo ]]; then
        echo "Install sudo before continuing. Issue: apt-get install sudo as root user."
        echo "Also make sure that your user has sudo access."
    fi

    sudo id &> /dev/null || { exit 1; };

    echo ""
    echo "-------------------------------------------------------"
    echo "ONZ installer script. Version: $version"
    echo "-------------------------------------------------------"

    echo -n "Running: apt-get update... ";
    sudo apt-get update  &> /dev/null || \
    { echo "Could not update apt repositories. Run apt-get update manually. Exiting." && exit 1; };
    echo -e "done.\n"

    echo -n "Running: apt-get install curl build-essential python lsb-release wget openssl autoconf libtool automake libsodium-dev... ";
    sudo apt-get install -y -qq curl build-essential python lsb-release wget openssl autoconf libtool automake libsodium-dev &>> $logfile || \
    { echo "Could not install packages prerequisites. Exiting." && exit 1; };
    echo -e "done.\n"

    echo -n "Updating apt repository sources for postgresql.. ";
    sudo bash -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ wheezy-pgdg main" > /etc/apt/sources.list.d/pgdg.list' &>> $logfile || \
    { echo "Could not add postgresql repo to apt." && exit 1; }
    echo -e "done.\n"

    echo -n "Adding postgresql repo key... "
    sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add - &>> $logfile || \
    { echo "Could not add postgresql repo key. Exiting." && exit 1; }
    echo -e "done.\n"

    echo -n "Installing postgresql... "
    sudo apt-get update -qq &> /dev/null && sudo apt-get install -y -qq postgresql-9.6 postgresql-contrib-9.6 libpq-dev &>> $logfile || \
    { echo "Could not install postgresql. Exiting." && exit 1; }
    echo -e "done.\n"

    echo -n "Enable postgresql... "
        sudo update-rc.d postgresql enable
    echo -e "done.\n"

    return 0;
}

ntp_checks() {
    # Install NTP or Chrony for Time Management - Physical Machines only
    if [[ ! -f "/proc/user_beancounters" ]]; then
      if ! sudo pgrep -x "ntpd" > /dev/null; then
        echo -n "\nInstalling NTP... "
        sudo apt-get install ntp -yyq &>> $logfile
        sudo service ntp stop &>> $logfile
        sudo ntpdate pool.ntp.org &>> $logfile
        sudo service ntp start &>> $logfile
        if ! sudo pgrep -x "ntpd" > /dev/null; then
          echo -e "onz requires NTP running. Please check /etc/ntp.conf and correct any issues. Exiting."
          exit 1
        echo -e "done.\n"
        fi # if sudo pgrep
      fi # if [[ ! -f "/proc/user_beancounters" ]]
    elif [[ -f "/proc/user_beancounters" ]]; then
      echo -e "Running OpenVZ or LXC VM, NTP is not required, done. \n"
    fi
}

create_database() {
    res=$(sudo -u postgres dropdb --if-exists "$DB_NAME" 2> /dev/null)
    res=$(sudo -u postgres createdb -O "$DB_UNAME" "$DB_NAME" 2> /dev/null)
    res=$(sudo -u postgres psql -t -c "SELECT count(*) FROM pg_database where datname='$DB_NAME'" 2> /dev/null)

    if [[ $res -eq 1 ]]; then
      echo "√ Postgresql database created successfully."
    else
      echo "X Failed to create Postgresql database."
      exit 1
    fi
}

download_blockchain() {
    echo -n "Download a recent, verified snapshot? ([y]/n): "
    read downloadornot

    if [ "$downloadornot" == "y" ] || [ -z "$downloadornot" ]; then
        rm -f $DB_SNAPSHOT
        echo "√ Downloading $DB_SNAPSHOT from $BLOCKCHAIN_URL"
        curl --progress-bar -o $DB_SNAPSHOT "$BLOCKCHAIN_URL"
        if [ $? != 0 ]; then
            rm -f $DB_SNAPSHOT
            echo "X Failed to download blockchain snapshot."
            exit 1
        else
            echo "√ Blockchain snapshot downloaded successfully."
        fi
    else
        echo -e "√ Using this Awesome Snapshot."
    fi
}

restore_blockchain() {
    export PGPASSWORD=$DB_PASSWD
    echo "Restoring blockchain with $DB_SNAPSHOT"
    # Be sure that all tables exist
    gunzip -fcq "$DB_SNAPSHOT" | psql -q -h 127.0.0.1 -U "$DB_UNAME" -d "$DB_NAME" &> $logfile
    if [ $? != 0 ]; then
        echo "X Failed to restore blockchain."
        exit 1
    else
      if [[ -f $DB_SNAPSHOT ]]; then
        echo -e "√ Using Local Snapshot."
      else
        echo -e "X No local snapshot found. I will exit now.."
        exit 1;
      fi
    fi
}

add_pg_user_database() {

    if start_postgres; then
        user_exists=$(grep postgres /etc/passwd |wc -l);
        if [[ $user_exists == 1 ]]; then
            res=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_UNAME'" 2> /dev/null)
            if [[ $res -ne 1 ]]; then
              echo -n "Creating database user... "
              res=$(sudo -u postgres psql -c "CREATE USER $DB_UNAME WITH PASSWORD '$DB_PASSWD';" 2> /dev/null)
              res=$(sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_UNAME'" 2> /dev/null)
              if [[ $res -eq 1 ]]; then
                echo -e "done.\n"
              fi
            fi

            echo -n "Creating database... "
            res=$(sudo -u postgres dropdb --if-exists "$DB_NAME" 2> /dev/null)
            res=$(sudo -u postgres createdb -O "$DB_UNAME" "$DB_NAME" 2> /dev/null)
            res=$(sudo -u postgres psql -t -c "SELECT count(*) FROM pg_database where datname='$DB_NAME'" 2> /dev/null)
            if [[ $res -eq 1 ]]; then
                echo -e "done.\n"
            fi
        fi
        return 0
    fi

    return 1;
}

start_postgres() {

    installed=$(dpkg -l |grep postgresql |grep ii |head -n1 |wc -l);
    running=$(ps aux |grep "bin\/postgres" |wc -l);

    if [[ $installed -ne 1 ]]; then
        echo "Postgres is not installed. Install postgres manually before continuing. Exiting."
        exit 1;
    fi

    if [[ $running -ne 1 ]]; then
        sudo /etc/init.d/postgresql start &>> $logfile || { echo -n "Could not start postgresql, try to start it manually. Exiting." && exit 1; }
    fi

    return 0
}

install_node_npm() {

    echo -n "Installing nodejs and npm..."
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - &>> $logfile
    sudo apt-get install -y -qq nodejs &>> $logfile || { echo "Could not install nodejs and npm. Exiting." && exit 1; }
    echo -e "done.\n" && echo -n "Installing grunt-cli... "
    sudo npm install grunt-cli -g &>> $logfile || { echo "Could not install grunt-cli. Exiting." && exit 1; }
    echo -e "done.\n" && echo -n "Installing bower... "
    sudo npm install bower -g &>> $logfile || { echo "Could not install bower. Exiting." && exit 1; }
    echo -e "done.\n" && echo -n "Installing process management software... "
    sudo npm install forever -g &>> $logfile || { echo "Could not install process management software(forever). Exiting." && exit 1; }
    echo -e "done.\n"

    return 0;
}

install_onz() {

    echo -n "Installing onz core..."
    npm install --production &>> $logfile || { echo "Could not install onz, please check the log directory. Exiting." && exit 1; }
    echo -e "done.\n"

    return 0;
}

update_client() {

    if [[ -f config.json ]]; then
        cp $root_path/config.json $root_path/config.json.bak
    fi

    echo -n "Updating onz client..."

    echo -e "Updating onz client..."
    cd $root_path
    git checkout . &>> $logfile || { echo "Failed to checkout latest status. See $logfile for more information." && exit 1; }
    git pull &>> $logfile || { echo "Failed to fetch new files from git. See $logfile for more information. Exiting." && exit 1; }
    npm install --production &>> $logfile || { echo "Could not install node modules. See $logfile for more information. Exiting." && exit 1; }

    if [[ -f config.json.bak ]]; then
      echo -n "Take over config.json entries from previous installation ... "
      node $root_path/updateConfig.js -o $root_path/config.json.bak -n $root_path/config.json
      echo "done."
    fi

    return 0;
}

stop_onz() {
    echo -n "Stopping onz..."
    forever_exists=$(whereis forever | awk {'print $2'})
    if [[ ! -z $forever_exists ]]; then
        $forever_exists stop $root_path/app.js &>> $logfile
    fi

    if ! running; then
        echo "OK"
        return 0
    fi

    return 1
}

start_onz() {
    echo -n "Starting onz..."
    forever_exists=$(whereis forever | awk {'print $2'})
    if [[ ! -z $forever_exists ]]; then
        $forever_exists start -o $root_path/logs/onzcoin.log -e $root_path/logs/onzcoin-err.log app.js &>> $logfile || \
        { echo -e "\nCould not start onz." && exit 1; }
    fi

    sleep 1

    if running; then
        echo "OK"
        return 0
    fi
    return 1
}


running() {
    process=$(forever list |grep app.js |awk {'print $9'})
    if [[ -z $process ]] || [[ "$process" == "STOPPED" ]]; then
        return 1
    fi
    return 0
}

show_blockHeight(){
  export PGPASSWORD=$DB_PASSWD
  blockHeight=$(psql -d $DB_NAME -U $DB_UNAME -h localhost -p 5432 -t -c "select height from blocks order by height desc limit 1")
  echo "Block height = $blockHeight"
}

parse_option() {
  OPTIND=2
  while getopts d:r:n opt
  do
    case $opt in
      s) install_with_ssl=true ;;
    esac
  done
}

rebuild_onz() {
  download_blockchain
  create_database
  restore_blockchain
}

start_log() {
  echo "Starting $0... " > $logfile
  echo -n "Date: " >> $logfile
  date >> $logfile
  echo "" >> $logfile
}

case $1 in
    "install")
      parse_option $@
      start_log
      install_prereq
      ntp_checks
      add_pg_user_database
      install_node_npm
      install_onz
      echo ""
      echo ""
      echo "onz successfully installed"
    ;;
    "update_client")
      start_log
      stop_onz
      sleep 1
      update_client
      sleep 1
      start_onz
      show_blockHeight
    ;;
    "reload")
      stop_onz
      sleep 1
      start_onz
      show_blockHeight
      ;;
    "rebuild")
      stop_onz
      sleep 1
      start_postgres
      sleep 1
      rebuild_onz
      start_onz
      show_blockHeight
      ;;
    "clean_start")
      stop_onz
      create_database
      start_onz
    ;;
    "status")
      if running; then
        echo "√ onz is running."
        show_blockHeight
      else
        echo "X onz is NOT running."
      fi
    ;;
    "start")
      start_onz
      show_blockHeight
    ;;
    "stop")
      stop_onz
    ;;

*)
    echo 'Available options: install, reload (stop/start), rebuild (official snapshot), clean_start (drop database), start, stop, update_client'
    echo 'Usage: ./onz_manager.bash install'
    exit 1
;;
esac
exit 0;

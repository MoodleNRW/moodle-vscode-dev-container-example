#!/usr/bin/env bash

until mysql -h db -u mariadb -pmariadb mariadb -e 'exit'; do
  sleep 1
done

PWD="$(pwd)"

sudo chmod a+x $PWD && 
sudo rm -rf /var/www/html && 
sudo ln -s $PWD /var/www/html &&

for MDL_VERSION in $MOODLE_VERSION; do
echo "Setting up environment for ${MDL_VERSION}"

DATADIR=/var/www/moodledata-${MDL_VERSION}
if [ -d "$DATADIR" ]; then
  sudo rm -rf $DATADIR
fi

if [ ! -d "$DATADIR" ]; then
  sudo mkdir -p $DATADIR &&
  sudo chmod a+x $DATADIR
fi

MOODLEDIR=$PWD/moodle-${MDL_VERSION}
if [ ! -d "$MOODLEDIR" ]; then
  git clone -b MOODLE_${MDL_VERSION}_STABLE https://github.com/moodle/moodle.git $MOODLEDIR
  # sudo rm -rf $MOODLEDIR/.git
fi

CFGFILE=$MOODLEDIR/config.php
if [ -f "$CFGFILE" ]; then
  sudo rm $MOODLEDIR/config.php
fi

MDL_VERSION_DB=${DB_NAME}_${MDL_VERSION}
MDL_VERSION_DB_USER=${DB_USER}_${MDL_VERSION}
if [ ! -f "$CFGFILE" ]; then
  # Drop data that might be existing from previous build
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "DROP DATABASE IF EXISTS ${MDL_VERSION_DB};"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "DROP USER IF EXISTS ${MDL_VERSION_DB_USER}@'%';"
  # Create database entitites for current version
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "CREATE DATABASE ${MDL_VERSION_DB};"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "CREATE USER ${MDL_VERSION_DB_USER}@'%' IDENTIFIED BY '${DB_USER_PWD}';"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "GRANT ALL PRIVILEGES ON ${MDL_VERSION_DB}.* TO ${MDL_VERSION_DB_USER}@'%';"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "FLUSH PRIVILEGES;"
  # Run moodle install cli
  sudo php $MOODLEDIR/admin/cli/install.php --dbtype=mariadb --dbhost=${DB_HOST} --dbname=${MDL_VERSION_DB} --dbuser=${MDL_VERSION_DB_USER} --dbpass=${DB_USER_PWD} --prefix="mdl_" --fullname="Moodle Development ${MDL_VERSION}" --shortname="MDEV${MDL_VERSION}" --wwwroot="http://localhost:8080/moodle-${MDL_VERSION}" --dataroot=$DATADIR --adminuser="${ADMIN_NAME}" --adminpass="${ADMIN_PASS}" --adminemail="${ADMIN_MAIL}" --non-interactive --agree-license &&
  # Set configuration settings
  sudo php $MOODLEDIR/admin/cli/cfg.php --name=smtphosts --set="localhost:1025"
  sudo php $MOODLEDIR/admin/cli/cfg.php --name=noreplyaddress --set=${ADMIN_MAIL}
  sudo php $MOODLEDIR/admin/cli/cfg.php --name=cachejs --set=0
  sudo php $MOODLEDIR/admin/cli/cfg.php --name=cachetemplates --set=0
  sudo php $MOODLEDIR/admin/cli/cfg.php --name=themedesignermode --set=1
  # Set rights on newly downloaded files
  # sudo chmod -R a+xr $PWD
fi

# Add cronjob for instance
(sudo crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/php /var/www/html/moodle-${MDL_VERSION}/admin/cli/cron.php > /dev/null") | sudo crontab -
done
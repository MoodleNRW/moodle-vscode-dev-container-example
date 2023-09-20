#!/usr/bin/env bash

until mysql -h db -u mariadb -pmariadb mariadb -e 'exit'; do
  sleep 1
done

PWD="$(pwd)"

# Moosh
if [ "$INSTALL_MOOSH" == "TRUE" ]; then
echo -e "\nInstall MOOSH\n"
if [ ! -d /opt ]; then sudo mkdir /opt ; fi
sudo git clone https://github.com/tmuras/moosh.git /opt/moosh
sudo rm -rf /opt/moosh/.git
sudo composer update --with-dependencies --working-dir=/opt/moosh
sudo composer install --working-dir=/opt/moosh
sudo ln -s /opt/moosh/moosh.php /usr/local/bin/moosh
fi

# Moodle
echo -e "\nInstall Moodle\n"
sudo chmod 755 $PWD &&
sudo rm -rf /var/www/html && 
sudo ln -s $PWD /var/www/html &&

for MDL_VERSION in $MOODLE_VERSION; do
echo -e "\nSetting up environment for ${MDL_VERSION}\n"

DATADIR=/var/www/moodledata-${MDL_VERSION}
if [ -d "$DATADIR" ]; then
  sudo rm -rf $DATADIR
fi

if [ ! -d "$DATADIR" ]; then
  sudo mkdir -p $DATADIR &&
  sudo chown www-data:www-data $DATADIR &&
  sudo chmod 700 $DATADIR
fi

MOODLEDIR=$PWD/moodle-${MDL_VERSION}
if [ ! -d "$MOODLEDIR" ]; then
  git clone -b MOODLE_${MDL_VERSION}_STABLE https://github.com/moodle/moodle.git $MOODLEDIR --depth 1
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
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "CREATE DATABASE ${MDL_VERSION_DB} DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "CREATE USER ${MDL_VERSION_DB_USER}@'%' IDENTIFIED BY '${DB_USER_PWD}';"
  sudo mysql -h ${DB_HOST} -u root -p${DB_ROOT_PWD} -e "GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,CREATE TEMPORARY TABLES,DROP,INDEX,ALTER ON ${MDL_VERSION_DB}.* TO ${MDL_VERSION_DB_USER}@'%';"
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
  sudo find $MOODLEDIR -type d -name .git -prune -exec chmod -R 755 {} +
  sudo find $MOODLEDIR -type f ! -name '*.idx' ! -name '*.pack' -exec chmod -R g+w {} +
  # Enable git
  sudo git config --global --add safe.directory $MOODLEDIR
fi

if [ $INSTALL_MOOSH == "TRUE" ]; then
echo -e "\n[MOOSH] Install language pack de\n"
moosh -n -p $MOODLEDIR language-install de

echo -e "\n[MOOSH] Create 10 new courses\n"
moosh -n -p $MOODLEDIR course-create newcourse{1..10}

echo -e "\n[MOOSH] Create 10 new user\n"
moosh -n -p $MOODLEDIR user-create testuser{1..10}
fi

# Add cronjob for instance
(sudo crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/php /var/www/html/moodle-${MDL_VERSION}/admin/cli/cron.php > /dev/null") | sudo crontab -
done

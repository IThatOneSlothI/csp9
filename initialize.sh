#!/bin/bash
# Prepares Cloud9 workspace for use with PLTW CSP curriculum

echo "Initializing Cloud9 container for use in PLTW CSP."
echo "Installing PHP myAdmin."
phpmyadmin-ctl install
echo "Asking MySQL to list databases:"
mysql "show databases;"
# sudo apt-get install iputils-tracepath
# previous command left in 2.1.3
#!/bin/bash
echo "Initializing Cloud9 container for use in PLTW CSP."
echo "Installing PHP myAdmin."
phpmyadmin-ctl install
echo "PHPMyAdmin installed."
echo
echo $C9_USER

#This works:
#echo "Asking MySQL to list databases:"
#mysql -u $C9_USER -e "show databases; use mysql; show tables;"

echo "Because the system offers MySQL access to the world through PHPMyAdmin,"
echo "You will need to set a password for MySQL."
echo "In a secure location, write down a new secure password (8+ chars) for MySQL."

#Initialize pwd and pwd2 so that while executes at least once
pwd=""
pwd2="A"
while [ "$pwd" != "$pwd2" ]
do
  read -s  -p "Enter the new password for MySQL: " pwd
  echo
  read -s  -p "Confirm the new password for MySQL: " pwd2
  echo
  if [ $pwd != $pwd2 ];
  then
    echo "Passwords don't match. Try again."
  else  
    if [ ${#pwd} -le 7 ]; # length(pwd)<=7
    then
      echo "Password is too short. Try again."
      pwd="."$pwd2 # force while loop
    else
      echo "Changing MySQL password..."
      mysql -u $C9_USER -e "set password for 'mepi'@'%'=password('"$pwd"');"
      echo "MySQL password changed. Use this password for MySQL and for PHPMyAdmin."
      
      echo "Creating step2 script to change PHPMyAdmin controluser password..."
      echo "#!/bin/bash" > ~/setup2.sh
      echo "sed \"s/\$dbpass=.*/\$dbpass='"$pwd"';/\" /etc/phpmyadmin/config-db.php > /etc/phpmyadmin/config-db.php" >> setup2.sh
      chmod 711 setup2.sh
      
      echo 'apt-get install python-dev' >> setup2.sh
      echo 'apt-get install libjpeg-dev' >> setup2.sh
      echo 'apt-get install libjpeg-dev' >> setup2.sh
      
      echo "You will still need to execute step2 to update the PHPMyAdmin control-user password. At the $ prompt, type:"
      echo "     \$ sudo ./setup2.sh"
      
      echo "<?php" > login.php
      echo '$host = "localhost";' >> login.php
      echo '$dbname ="artgallery";' >> login.php
      echo '$username = "'$C9_USER'";' >>login.php
      echo '$password = "'$pwd'";' >> login.php
      echo '?>' >> login.php
      
     # mysql -u $C9_USER -p$pwd -e "CREATE DATABASE artgallery"
      mysql -u $C9_USER -p$pwd < setup.sql
      
    fi
  fi
done

# Remove git branch from shell prompt.
sed -i -e "s/\$(__git_ps1 \" (%s)\")//" ../.bashrc
source ../.bashrc 
# create database for Activity 2.2.2
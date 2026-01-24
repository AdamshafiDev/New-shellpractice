#1/bin/bash

Name="adamshafi"

echo "$Name"

echo "crontab -e */2 * * * * /home/ec2-user/New-shellpractice/6-crontab.sh >> /home/ec2-user/New-shellpractice/cron.log 2>&1
"
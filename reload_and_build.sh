#!/bin/sh
SESSION=/tmp/jenkins_rb.txt
CRUMB=$(curl -s -u admin:admin123 -c $SESSION http://localhost:8080/crumbIssuer/api/json | grep -o '"crumb":"[^"]*"' | cut -d'"' -f4)
echo "Crumb: $CRUMB"
curl -s -o /dev/null -w "Reload: %{http_code}\n" -X POST -u admin:admin123 -b $SESSION -H "Jenkins-Crumb: $CRUMB" http://localhost:8080/reload
sleep 3
SESSION2=/tmp/jenkins_rb2.txt
CRUMB2=$(curl -s -u admin:admin123 -c $SESSION2 http://localhost:8080/crumbIssuer/api/json | grep -o '"crumb":"[^"]*"' | cut -d'"' -f4)
curl -s -w "\nBuild trigger: %{http_code}" -X POST -u admin:admin123 -b $SESSION2 -H "Jenkins-Crumb: $CRUMB2" --data-urlencode "script=Jenkins.instance.getJob('Calculatrice-Pipeline').scheduleBuild2(0)" http://localhost:8080/scriptText

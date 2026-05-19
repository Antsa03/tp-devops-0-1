#!/bin/sh
SESSION=/tmp/jenkins_s4.txt
CRUMB_RESP=$(curl -s -u admin:admin123 -c $SESSION http://localhost:8080/crumbIssuer/api/json)
CRUMB=$(echo "$CRUMB_RESP" | grep -o '"crumb":"[^"]*"' | cut -d'"' -f4)
echo "Crumb: $CRUMB"
curl -s -w "\nHTTP: %{http_code}" -X POST -u admin:admin123 -b $SESSION \
  -H "Jenkins-Crumb: $CRUMB" \
  --data-urlencode "script=Jenkins.instance.getJob('Calculatrice-Pipeline').scheduleBuild2(0)" \
  "http://localhost:8080/scriptText"

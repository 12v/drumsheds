#!/bin/sh

curl -s -D headers.txt --location 'https://bookings.drumshedslondon.com/api/start' --header 'content-type: application/x-www-form-urlencoded' --header 'package-id: 20092' --data-urlencode 'client_id=69' --data-urlencode 'package_id=20092' --data-urlencode 'agent_id=' --data-urlencode 'adults=0' --data-urlencode 'children=0' --data-urlencode 'infants=0' --data-urlencode 'currency_id=98'

cookie=$(grep -i 'set-cookie: kabFLOW=' headers.txt | head -n 1 | awk '{print $2}')

RESPONSE=$(curl -s "https://bookings.drumshedslondon.com/api/4.0/package/ticketavailability" -H "cookie: $cookie" -H "package-id: 20092")

echo $RESPONSE

if echo "$RESPONSE" | jq '.tickets[] | select(.id == 169632 and .available > 1)' | grep -q .; then
    echo "Ticket with id 169632 is available."
    echo 111 > output.txt
else
    echo "Ticket with id 169632 is not available."
    echo 111 > output.txt
fi

#!/bin/sh

curl -s -D headers.txt --location 'https://bookings.drumshedslondon.com/api/start' --header 'content-type: application/x-www-form-urlencoded' --header 'package-id: 20092' --data-urlencode 'client_id=69' --data-urlencode 'package_id=20092' --data-urlencode 'agent_id=' --data-urlencode 'adults=0' --data-urlencode 'children=0' --data-urlencode 'infants=0' --data-urlencode 'currency_id=98'

cookie=$(grep -i 'set-cookie: kabFLOW=' headers.txt | head -n 1 | awk '{print $2}')

RESPONSE=$(curl -s "https://bookings.drumshedslondon.com/api/4.0/package/ticketavailability" -H "cookie: $cookie" -H "package-id: 20092")

echo $RESPONSE

CALCULATED_HASH=$(echo -n $RESPONSE | sha256sum)

echo $CALCULATED_HASH

EXPECTED_HASH="d5d3327091ebff0ce9388371d38dd3ceedb995fec29a9052cbb6dc1d590e675 - "

echo $EXPECTED_HASH

CALCULATED_HASH=$(echo -n "$CALCULATED_HASH" | tr -d '[:space:]')
EXPECTED_HASH=$(echo -n "$EXPECTED_HASH" | tr -d '[:space:]')

if [ "$CALCULATED_HASH" = "$EXPECTED_HASH" ]; then
echo "The strings are equal."
else
echo "The strings are not equal."
exit 111
fi

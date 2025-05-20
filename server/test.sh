#!/bin/bash

echo "Logging in..."

TOKEN=$(curl -s -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "raresai@gmail.com",
    "password": "anaaremere"
  }' | jq -r '.access_token')

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "Login failed. Check credentials."
  exit 1
fi

echo "Token received: $TOKEN"

echo "Sending booking..."
curl -s -X POST http://localhost:5000/api/bookings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  --data-raw '{
    "room_id": 1,
    "check_in_date": "2025-06-10",
    "check_out_date": "2025-06-12",
    "guests": 2
  }'
echo

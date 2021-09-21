#!/bin/bash
printf "\nGetting admin user profile\n"
response=$(curl -X GET -w "\nhttps" \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: $TOKEN" \
"$URL/users?email=$USER_EMAIL&dataScope=index")

code=$(echo "$response" | tail -n1)

userid=$(echo "$response" | head -n1 | jq -j '.users[0].id')
echo $userid

response=$(curl -X POST \
  -H 'Accept: application/json' \
  -H "Authorization: $TOKEN" \
  "${URL}/cloud_directory/remove/$userid")

echo $response

code=$(echo "${response}" | tail -n1)
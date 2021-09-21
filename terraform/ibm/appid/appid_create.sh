#!/bin/bash
response=$(curl -X POST -w "\n%{http_code}" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -H "Authorization: $TOKEN" \
  -d '{"emails": [
          {"value": "'$USER_EMAIL'","primary": true}
        ],
       "userName": "'$USER_NAME'",
       "password": "'$USER_PASSWORD'"
      }' \
  "${URL}/cloud_directory/sign_up?shouldCreateProfile=true")
echo $response
code=$(echo "$response" | tail -n1)
# [ "$code" -ne 201 ] && printf "\nFAILED to define admin user in cloud directory\n" && exit 1

printf "\nGetting admin user profile\n"
response=$(curl -X GET -w "\nhttps" \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: $TOKEN" \
"$URL/users?email=$USER_EMAIL&dataScope=index")
code=$(echo "$response" | tail -n1)
# [ "$code" -ne 200 ] && printf "\nFAILED to get admin user profile\n" && exit 1

userid=$(echo "$response" | head -n1 | jq -j '.users[0].id')

printf "\nAdding admin role to admin user\n"
response=$(curl -X PUT -w "\nhttps" \
-H 'Content-Type: application/json' \
-H 'Accept: application/json' \
-H "Authorization: $TOKEN" \
-d '{"roles": { "ids": ["'$ROLE'"]}}' \
"$URL/users/$userid/roles")

code=$(echo "$response" | tail -n1)
# [ "$code" -ne 200 ] && printf "\nFAILED to add admin role to admin user\n" && exit 1
#!/bin/sh

NGROK_ADDR=ngrok:4040

# sleep to start
sleep 3

# main loop
while :
do

  # get the address from ngrok
  echo "Getting ngrok tunnel data..."
  tunnel=$(curl -sm 5 $NGROK_ADDR/api/tunnels/command_line | jq -r ".public_url")
  if [ $? -ne 0 ]; then
    echo "NGROK Server unreachable!"
    exit 1
  fi

  # text formatting
  tempstr=${tunnel#*//}
  domain=$(echo $tempstr | cut -d: -f1)
  port=$(echo $tempstr | cut -d: -f2)
  date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "Domain: $domain"
  echo "Port: $port"

  # huh
  json=$(cat <<EOF | jq -r tostring
  {
    "content":"",
    "username":"Apollo - Terraria Server",
    "avatar_url":"https://avatarfiles.alphacoders.com/238/238775.png",
    "embeds":[
      {
        "title":"Current Server IP",
        "description":"**IP:** \`$domain\`\n**Port:** \`$port\`\n**Pass:** \`$pass\`",
        "color":2148759,
        "timestamp": "$date"
      }
    ]
  }
EOF
  )

  # update discord
  curl \
    -X PATCH $webhook/messages/$m_id \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    --data "$json"

  # sleep
  sleep 3600

# end loop
done
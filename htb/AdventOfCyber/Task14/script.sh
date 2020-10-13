value=s
next=f
key=s
while [[ "$value" != "end" && "$next" != "end" ]]; do
    response=`curl -s 10.10.169.100:3000/$next`
    value=`echo "$response" | jq -r ".value"`
    if [[ "$value" == "end" ]]; then
        key+=$next
        next="end"
    else
        key+=`echo "$response" | jq -r ".value"`
        next=`echo "$response" | jq -r ".next"`
    fi
done
echo $key

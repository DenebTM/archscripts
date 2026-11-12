#!/usr/bin/bash

set -euo pipefail

ports=($1)
shift

nft() {
	sudo /usr/bin/nft "$@"
}

old_ruleset="$(nft --handle list chain inet filter input)"
before_handle="$(echo "$old_ruleset" | grep admin-prohibited | sed 's/.*# handle //')"

echo "nftwrap: opening ports: ${ports[@]}"
for port in ${ports[@]}; do
	#sudo nft add rule inet filter input tcp dport  accept comment \"TEMP: mqtt\"
	/usr/bin/sudo nft insert rule inet filter input handle "$before_handle" meta l4proto \{ tcp, udp \} th dport "$port" accept comment \"TEMP: nftwrap "$@"\"
done

new_ruleset="$(nft --handle list chain inet filter input)"
ruleset_diff="$(/usr/bin/diff <(echo "$old_ruleset") <(echo "$new_ruleset") || true)"
new_handles=($(echo "$ruleset_diff" | sed -n 's/.*# handle //p'))

echo

# run command
echo "nftwrap: running command: $@"
"$@"

echo

echo "nftwrap:closing ports: ${ports[@]}"
for handle in ${new_handles[@]}; do
	#/usr/bin/sudo nft add rule inet filter input tcp dport  accept comment \"TEMP: mqtt\"
	/usr/bin/sudo nft delete rule inet filter input handle "$handle"
done

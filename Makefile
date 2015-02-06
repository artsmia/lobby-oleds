objects-on-the-lobby-screens-and-their-locations.csv:
	echo 'id,title,gallery,on the lobby screen' > $@
	csvcut -c1,7 "MASTER—Upper Lobby OLED Playlists - MIDDLE OLED.csv" \
	| grep -v '^,$$' \
	| sed 's/,$$/,nope/' \
	| tail -n+2 \
	| tr ',' '\n' | while read id; do \
		read onScreen; \
		mia $$id | jq -r --arg onScreen $$onScreen '[.id, .title, .room, $$onScreen == "X"] | @csv' | sed 's|http://api.artsmia.org/objects/||'; \
	done >> $@
	(head -1 $@ && tail -n+2 $@ | sort -t'"' -k2g | uniq) \
		| sponge $@

.PHONY: objects-on-the-lobby-screens-and-their-locations.csv

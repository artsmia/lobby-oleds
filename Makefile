doc=https://docs.google.com/a/artsmia.org/spreadsheets/d/1MiMk6tRcB280mZDbNeSIs0reMOllS007piQAoKxtZDo/export?format=csv&id=1MiMk6tRcB280mZDbNeSIs0reMOllS007piQAoKxtZDo&gid=599804977

oleds.csv:
	wget --no-check-certificate --output-document=oleds.csv "$(doc)&output=csv"

objects-on-the-lobby-screens-and-their-locations.csv: oleds.csv
	echo 'id,title,gallery,on the lobby screen' > $@
	csvcut -c1,7 oleds.csv | tail -n+5 \
	| grep -v '^,$$' \
	| sed 's/,$$/,nope/' \
	| tail -n+2 \
	| tr ',' '\n' | while read id; do \
		read onScreen; \
		mia $$id | jq -r --arg onScreen $$onScreen '[.id, .title, .room, $$onScreen == "X"] | @csv' | sed 's|http://api.artsmia.org/objects/||'; \
	done >> $@
	(head -1 $@ && tail -n+2 $@ | sort -t'"' -k2g | uniq) \
		| sponge $@

.PHONY: objects-on-the-lobby-screens-and-their-locations.csv oleds.csv

objects-on-the-lobby-screens-and-their-locations.csv:
	j Lobby\ OLED\ Screens\ Playlist.xlsx | tail -n+4 | csvcut -c1 | grep -v '""' | sed 's/64.7/64.70/' | while read acc; do \
		mia $$acc | jq -r '[.id, .title, .room] | @csv' | sed 's|http://api.artsmia.org/objects/||'; \
	done > $@

.PHONY: objects-on-the-lobby-screens-and-their-locations.csv

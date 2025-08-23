/client
	var/discord_id = null

/client/New()
	. = ..()
	load_player_discord(src)

/proc/IsGuestKey(key)
	if(findtext(key, "Guest-", 1, 7) != 1) //was findtextEx
		return 0

	var/i, ch, len = length(key)

	for(i = 7, i <= len, ++i)
		ch = text2ascii(key, i)
		if(ch < 48 || ch > 57)
			return 0
	return 1

/client/proc/load_player_discord()
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT discord_id FROM [CONFIG_GET(string/utility_database)].[format_table_name("discord_links")] WHERE valid=1 AND ckey=:ckey", list("ckey" = ckey))

	if(!query.warn_execute())
		qdel(query)
		return

	while(query.NextRow())
		discord_id = query.item[1]

	qdel(query)

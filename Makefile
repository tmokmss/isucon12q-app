db:
	sudo systemctl restart mysql.service

nginx:
	sudo systemctl restart nginx.service

app:
	sudo systemctl restart isuports.service

systemctl-list:
	systemctl list-unit-files --type=service

alp:
	sudo cat /var/log/nginx/access.log | alp ltsv -m '/api/player/competition/.*/ranking','/api/player/player/.*','/api/organizer/competition/.*/score','/api/organizer/player/.*/disqualified','/api/organizer/competition/.*/finish'

ptq:
	sudo pt-query-digest --limit 15 /var/log/mysql/mysql-slow.log

mss:
	sudo mysqldumpslow -s t -t 20

reset-log:
	sudo rm /var/log/mysql/mysql-slow.log || true
	sudo rm /var/log/nginx/access.log || true
	make db
	make nginx

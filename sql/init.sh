#!/bin/sh

set -ex
cd `dirname $0`

ISUCON_DB_HOST=${ISUCON_DB_HOST:-127.0.0.1}
ISUCON_DB_PORT=${ISUCON_DB_PORT:-3306}
ISUCON_DB_USER=${ISUCON_DB_USER:-isucon}
ISUCON_DB_PASSWORD=${ISUCON_DB_PASSWORD:-isucon}
ISUCON_DB_NAME=${ISUCON_DB_NAME:-isuports}

# MySQLを初期化
mysql -u"$ISUCON_DB_USER" \
		-p"$ISUCON_DB_PASSWORD" \
		--host "$ISUCON_DB_HOST" \
		--port "$ISUCON_DB_PORT" \
		"$ISUCON_DB_NAME" < init.sql

# SQLiteのデータベースを初期化
rm -f ../tenant_db/*.db
cp -r ../../initial_data/*.db ../tenant_db/

for f in ../tenant_db/*.db; do
  echo "Processing $f file..";
  sqlite3 -line $f 'CREATE INDEX `created_at_idx` ON `competition` (`created_at`);'
  sqlite3 -line $f 'CREATE INDEX `comp_pla_row_idx` ON player_score  (`competition_id`, `player_id`, `row_num`);'
  sqlite3 -line $f 'CREATE INDEX `comp_pla_row_idx` ON player_score  (`player_id`);'
  sqlite3 -line $f 'CREATE INDEX `comp_row_idx` ON player_score  (`competition_id`, `row_num`);'
done

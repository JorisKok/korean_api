# KoreanApi

## Troubleshooting

In case Elasticsearch shuts down because of not enough virtual memory

`sudo sysctl -w vm.max_map_count=262144`

## Powa

1) Create the powa database

2) Create the powa extensions on the powa database
```
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION btree_gist;
CREATE EXTENSION powa;
CREATE EXTENSION pg_qualstats;
CREATE EXTENSION pg_stat_kcache;
CREATE EXTENSION hypopg;
```

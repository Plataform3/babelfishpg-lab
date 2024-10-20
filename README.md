# babelfishpg-lab


Lab for testing babelfishpg.


```bash
docker compose up
```

Get in the bash:

```bash
docker compose exec -it bbf bash
```

For get into postgres, just `psql`.

For logging into Babelfish (password is `password`):

```bash
tsql -H localhost -p 1433 -U bbf bff
```

Helper scripts based in the SQL code at [Babelfish loose contributions](https://tr3s.ma/toolbox/2024/babelfish-on-docker/) for testing.

```bash
scripts/init.sh
scripts/show_logs.sh
```


Explain supported in TDS:

```sql
set babelfish_showplan_all on
GO
<query>
GO
```

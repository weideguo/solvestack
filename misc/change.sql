-- sqlite3
-- 0.18.2 -> 0.19.0
ALTER TABLE auth_new_permanenttoken RENAME COLUMN validate_date to expire_date;

alter table auth_new_permanenttoken rename to auth_new_permanenttoken_bak;
CREATE TABLE IF NOT EXISTS "auth_new_permanenttoken" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "token" varchar(32) NOT NULL UNIQUE, "username" varchar(150) NOT NULL, "expire_date" datetime NULL, "create_date" datetime NOT NULL, "lastest_date" datetime NULL, "invoke_count" integer NOT NULL, "invoke_success_count" integer NOT NULL, "lastest_success_date" datetime NULL, "max_invoke" integer NOT NULL, "invoke_rule_ids" varchar(200) NOT NULL, "is_validate" integer NOT NULL);
insert into auth_new_permanenttoken select * from auth_new_permanenttoken_bak;
drop table auth_new_permanenttoken_bak;


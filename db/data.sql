INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Account" ("id", "login", "password")
VALUES (lastval(), 'admin', '$scrypt$N=32768,r=8,p=1,maxmem=67108864$Y33PUdCTNJuYb7FKkfbT/E4zWi2cukceqV7vBeL+ZmI$vPMMSHnn/izf7lnQtv9/Ilync+JmKEHwn4vB94X3qe+QS2D9jqjRvZ8+tzSk7A6rB3paznAjlKaXK2C/xYU9Pg');

INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Account" ("id", "login", "password")
VALUES (lastval(), 'marcus', '$scrypt$N=32768,r=8,p=1,maxmem=67108864$CEUCHFbTTOvyD/VMi3wrFE1DYS9UNYQbTmL6fOx1BwY$MU1M+TH4/6lmq5b8k/kyCvaNXC68oB9oTTDvtRoaeu61+1EKHNGx2E8FfUWuB7Y3DBkfKqhN37Y7FnIuYgyTzQ');

INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Account" ("id", "login", "password")
VALUES (lastval(), 'user', '$scrypt$N=32768,r=8,p=1,maxmem=67108864$dSBT3AVxqctYVBDRDaIzc7e9Nxvtoqf3kQgdSrdo+5Y$Zv3CriftrUsPmGaqqptvVsw8D18J7G+VYLsasqJGSLQpqkuAi2Tm4sMgpXvwe3GfDv6KA9XLC5dH4VlGGddJiw  ');

INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Account" ("id", "login", "password")
VALUES (lastval(), 'iskandar', '$scrypt$N=32768,r=8,p=1,maxmem=67108864$SDeMXuBRl38SNKpf5+1abpIKrUhp/EfX9YsHQLwlrnA$KEY2UOaUJEEYtURagtobQFWxBIBvOzMpAqwWkiDXGI/NJwGowbzswoNLbzcGcsGTjs05eHc00jaSgNsaVazHew');

-- Examples login/password
-- admin/123456
-- marcus/marcus
-- user/nopassword
-- iskandar/zulqarnayn

INSERT INTO "Area" ("name", "ownerId") VALUES
  ('Metarhia', (SELECT "id" FROM "Account" WHERE "login" = 'marcus')),
  ('Metaeducation', (SELECT "id" FROM "Account" WHERE "login" = 'marcus'));

INSERT INTO "AreaAccount" ("areaId", "accountId") VALUES
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metarhia'), (SELECT "id" FROM "Account" WHERE "login" = 'admin')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metarhia'), (SELECT "id" FROM "Account" WHERE "login" = 'marcus')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metarhia'), (SELECT "id" FROM "Account" WHERE "login" = 'user')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metarhia'), (SELECT "id" FROM "Account" WHERE "login" = 'iskandar')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metaeducation'), (SELECT "id" FROM "Account" WHERE "login" = 'admin')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metaeducation'), (SELECT "id" FROM "Account" WHERE "login" = 'marcus')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metaeducation'), (SELECT "id" FROM "Account" WHERE "login" = 'user')),
  ((SELECT "areaId" FROM "Area" WHERE "name" = 'Metaeducation'), (SELECT "id" FROM "Account" WHERE "login" = 'iskandar'));

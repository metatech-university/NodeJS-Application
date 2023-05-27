CREATE TABLE "Identifier" (
  "id" bigint generated always as identity,
  "entityId" bigint NULL,
  "creation" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "change" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "Identifier" ADD CONSTRAINT "pkIdentifier" PRIMARY KEY ("id");
ALTER TABLE "Identifier" ADD CONSTRAINT "fkIdentifierEntity" FOREIGN KEY ("entityId") REFERENCES "Identifier" ("id");

CREATE TABLE "Division" (
  "id" bigint NOT NULL,
  "name" varchar NOT NULL,
  "parentId" bigint NULL
);

ALTER TABLE "Division" ADD CONSTRAINT "pkDivision" PRIMARY KEY ("id");
ALTER TABLE "Division" ADD CONSTRAINT "fkDivisionId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
CREATE UNIQUE INDEX "akDivisionName" ON "Division" ("name");
ALTER TABLE "Division" ADD CONSTRAINT "fkDivisionParent" FOREIGN KEY ("parentId") REFERENCES "Division" ("id");

CREATE TABLE "Role" (
  "roleId" bigint generated always as identity,
  "name" varchar NOT NULL,
  "active" boolean NOT NULL DEFAULT true,
  "DivisionId" bigint NOT NULL
);

ALTER TABLE "Role" ADD CONSTRAINT "pkRole" PRIMARY KEY ("roleId");
CREATE UNIQUE INDEX "akRoleName" ON "Role" ("name");
ALTER TABLE "Role" ADD CONSTRAINT "fkRoleDivision" FOREIGN KEY ("DivisionId") REFERENCES "Division" ("id") ON DELETE RESTRICT;

CREATE TABLE "Account" (
  "id" bigint NOT NULL,
  "login" varchar(64) NOT NULL,
  "password" varchar NOT NULL,
  "active" boolean NOT NULL DEFAULT true,
  "fullName" varchar NULL,
  "email" varchar(255) NULL,
  "phone" varchar(15) NULL
);

ALTER TABLE "Account" ADD CONSTRAINT "pkAccount" PRIMARY KEY ("id");
ALTER TABLE "Account" ADD CONSTRAINT "fkAccountId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
CREATE UNIQUE INDEX "akAccountLogin" ON "Account" ("login");
CREATE INDEX "idxAccountEmail" ON "Account" ("email");
CREATE INDEX "idxAccountPhone" ON "Account" ("phone");

CREATE TABLE "AccountDivision" (
  "accountId" bigint NOT NULL,
  "divisionId" bigint NOT NULL
);

ALTER TABLE "AccountDivision" ADD CONSTRAINT "pkAccountDivision" PRIMARY KEY ("accountId", "divisionId");
ALTER TABLE "AccountDivision" ADD CONSTRAINT "fkAccountDivisionAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("id") ON DELETE CASCADE;
ALTER TABLE "AccountDivision" ADD CONSTRAINT "fkAccountDivisionDivision" FOREIGN KEY ("divisionId") REFERENCES "Division" ("id") ON DELETE CASCADE;

CREATE TABLE "AccountRole" (
  "accountId" bigint NOT NULL,
  "roleId" bigint NOT NULL
);

ALTER TABLE "AccountRole" ADD CONSTRAINT "pkAccountRole" PRIMARY KEY ("accountId", "roleId");
ALTER TABLE "AccountRole" ADD CONSTRAINT "fkAccountRoleAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("id") ON DELETE CASCADE;
ALTER TABLE "AccountRole" ADD CONSTRAINT "fkAccountRoleRole" FOREIGN KEY ("roleId") REFERENCES "Role" ("roleId") ON DELETE CASCADE;

CREATE TABLE "Area" (
  "areaId" bigint generated always as identity,
  "name" varchar NOT NULL,
  "ownerId" bigint NOT NULL
);

ALTER TABLE "Area" ADD CONSTRAINT "pkArea" PRIMARY KEY ("areaId");
CREATE UNIQUE INDEX "akAreaName" ON "Area" ("name");
ALTER TABLE "Area" ADD CONSTRAINT "fkAreaOwner" FOREIGN KEY ("ownerId") REFERENCES "Account" ("id");

CREATE TABLE "AreaAccount" (
  "areaId" bigint NOT NULL,
  "accountId" bigint NOT NULL
);

ALTER TABLE "AreaAccount" ADD CONSTRAINT "pkAreaAccount" PRIMARY KEY ("areaId", "accountId");
ALTER TABLE "AreaAccount" ADD CONSTRAINT "fkAreaAccountArea" FOREIGN KEY ("areaId") REFERENCES "Area" ("areaId") ON DELETE CASCADE;
ALTER TABLE "AreaAccount" ADD CONSTRAINT "fkAreaAccountAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("id") ON DELETE CASCADE;

CREATE TABLE "Catalog" (
  "id" bigint NOT NULL,
  "parentId" bigint NULL,
  "name" varchar NOT NULL
);

ALTER TABLE "Catalog" ADD CONSTRAINT "pkCatalog" PRIMARY KEY ("id");
ALTER TABLE "Catalog" ADD CONSTRAINT "fkCatalogId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
ALTER TABLE "Catalog" ADD CONSTRAINT "fkCatalogParent" FOREIGN KEY ("parentId") REFERENCES "Catalog" ("id");
CREATE INDEX "idxCatalogName" ON "Catalog" ("name");

CREATE TABLE "CatalogIdentifier" (
  "catalogId" bigint NOT NULL,
  "identifierId" bigint NOT NULL
);

ALTER TABLE "CatalogIdentifier" ADD CONSTRAINT "pkCatalogIdentifier" PRIMARY KEY ("catalogId", "identifierId");
ALTER TABLE "CatalogIdentifier" ADD CONSTRAINT "fkCatalogIdentifierCatalog" FOREIGN KEY ("catalogId") REFERENCES "Catalog" ("id") ON DELETE CASCADE;
ALTER TABLE "CatalogIdentifier" ADD CONSTRAINT "fkCatalogIdentifierIdentifier" FOREIGN KEY ("identifierId") REFERENCES "Identifier" ("id") ON DELETE CASCADE;
CREATE UNIQUE INDEX "akCatalogNaturalKey" ON "Catalog" ("parentId", "name");

CREATE TABLE "Chat" (
  "chatId" bigint generated always as identity,
  "createdById" bigint NOT NULL,
  "name" varchar NOT NULL
);

ALTER TABLE "Chat" ADD CONSTRAINT "pkChat" PRIMARY KEY ("chatId");
ALTER TABLE "Chat" ADD CONSTRAINT "fkChatCreatedBy" FOREIGN KEY ("createdById") REFERENCES "Account" ("id");

CREATE TABLE "ChatMember" (
  "chatMemberId" bigint generated always as identity,
  "accountId" bigint NOT NULL,
  "chatId" bigint NOT NULL,
  "status" varchar NOT NULL
);

ALTER TABLE "ChatMember" ADD CONSTRAINT "pkChatMember" PRIMARY KEY ("chatMemberId");
ALTER TABLE "ChatMember" ADD CONSTRAINT "fkChatMemberAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("id");
ALTER TABLE "ChatMember" ADD CONSTRAINT "fkChatMemberChat" FOREIGN KEY ("chatId") REFERENCES "Chat" ("chatId");

CREATE TABLE "Entity" (
  "id" bigint NOT NULL,
  "name" varchar NOT NULL,
  "kind" varchar NOT NULL DEFAULT 'entity'
);

ALTER TABLE "Entity" ADD CONSTRAINT "pkEntity" PRIMARY KEY ("id");
ALTER TABLE "Entity" ADD CONSTRAINT "fkEntityId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
CREATE UNIQUE INDEX "akEntityName" ON "Entity" ("name");

CREATE TABLE "Field" (
  "id" bigint NOT NULL,
  "entityId" bigint NOT NULL,
  "name" varchar NOT NULL
);

ALTER TABLE "Field" ADD CONSTRAINT "pkField" PRIMARY KEY ("id");
ALTER TABLE "Field" ADD CONSTRAINT "fkFieldId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
ALTER TABLE "Field" ADD CONSTRAINT "fkFieldEntity" FOREIGN KEY ("entityId") REFERENCES "Entity" ("id") ON DELETE CASCADE;
CREATE UNIQUE INDEX "akFieldNaturalKey" ON "Field" ("entityId", "name");

CREATE TABLE "File" (
  "id" bigint NOT NULL,
  "filename" varchar NOT NULL,
  "crc32" varchar NOT NULL,
  "hashsum" varchar NOT NULL,
  "size" integer NOT NULL,
  "mediaType" varchar NOT NULL,
  "accessLast" timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "accessCount" integer NOT NULL DEFAULT 0,
  "compressionFormat" varchar NOT NULL,
  "compressionSize" integer NOT NULL
);

ALTER TABLE "File" ADD CONSTRAINT "pkFile" PRIMARY KEY ("id");
ALTER TABLE "File" ADD CONSTRAINT "fkFileId" FOREIGN KEY ("id") REFERENCES "Identifier" ("id");
CREATE INDEX "idxFileFilename" ON "File" ("filename");
CREATE INDEX "idxFileCrc32" ON "File" ("crc32");

CREATE TABLE "Folder" (
  "folderId" bigint generated always as identity,
  "parentId" bigint NULL,
  "ownerId" bigint NOT NULL,
  "name" varchar NOT NULL,
  "logo" varchar NOT NULL
);

ALTER TABLE "Folder" ADD CONSTRAINT "pkFolder" PRIMARY KEY ("folderId");
ALTER TABLE "Folder" ADD CONSTRAINT "fkFolderParent" FOREIGN KEY ("parentId") REFERENCES "Folder" ("folderId");
ALTER TABLE "Folder" ADD CONSTRAINT "fkFolderOwner" FOREIGN KEY ("ownerId") REFERENCES "Account" ("id");

CREATE TABLE "FolderChat" (
  "folderId" bigint NOT NULL,
  "chatId" bigint NOT NULL
);

ALTER TABLE "FolderChat" ADD CONSTRAINT "pkFolderChat" PRIMARY KEY ("folderId", "chatId");
ALTER TABLE "FolderChat" ADD CONSTRAINT "fkFolderChatFolder" FOREIGN KEY ("folderId") REFERENCES "Folder" ("folderId") ON DELETE CASCADE;
ALTER TABLE "FolderChat" ADD CONSTRAINT "fkFolderChatChat" FOREIGN KEY ("chatId") REFERENCES "Chat" ("chatId") ON DELETE CASCADE;

CREATE TABLE "Message" (
  "messageId" bigint generated always as identity,
  "threadId" bigint NULL,
  "chatId" bigint NOT NULL,
  "areaId" bigint NOT NULL,
  "fromId" bigint NOT NULL,
  "data" jsonb NOT NULL
);

ALTER TABLE "Message" ADD CONSTRAINT "pkMessage" PRIMARY KEY ("messageId");
ALTER TABLE "Message" ADD CONSTRAINT "fkMessageThread" FOREIGN KEY ("threadId") REFERENCES "Message" ("messageId");
ALTER TABLE "Message" ADD CONSTRAINT "fkMessageChat" FOREIGN KEY ("chatId") REFERENCES "Chat" ("chatId");
ALTER TABLE "Message" ADD CONSTRAINT "fkMessageArea" FOREIGN KEY ("areaId") REFERENCES "Area" ("areaId");
ALTER TABLE "Message" ADD CONSTRAINT "fkMessageFrom" FOREIGN KEY ("fromId") REFERENCES "Account" ("id");

CREATE TABLE "MessageReaction" (
  "messageReactionId" bigint generated always as identity,
  "messageId" bigint NOT NULL,
  "reaction" varchar NOT NULL,
  "fromId" bigint NOT NULL
);

ALTER TABLE "MessageReaction" ADD CONSTRAINT "pkMessageReaction" PRIMARY KEY ("messageReactionId");
ALTER TABLE "MessageReaction" ADD CONSTRAINT "fkMessageReactionMessage" FOREIGN KEY ("messageId") REFERENCES "Message" ("messageId");
ALTER TABLE "MessageReaction" ADD CONSTRAINT "fkMessageReactionFrom" FOREIGN KEY ("fromId") REFERENCES "Account" ("id");

CREATE TABLE "Permission" (
  "permissionId" bigint generated always as identity,
  "roleId" bigint NOT NULL,
  "identifierId" bigint NOT NULL,
  "action" varchar NOT NULL DEFAULT 'update'
);

ALTER TABLE "Permission" ADD CONSTRAINT "pkPermission" PRIMARY KEY ("permissionId");
ALTER TABLE "Permission" ADD CONSTRAINT "fkPermissionRole" FOREIGN KEY ("roleId") REFERENCES "Role" ("roleId") ON DELETE CASCADE;
ALTER TABLE "Permission" ADD CONSTRAINT "fkPermissionIdentifier" FOREIGN KEY ("identifierId") REFERENCES "Identifier" ("id") ON DELETE CASCADE;
CREATE UNIQUE INDEX "akPermissionNaturalKey" ON "Permission" ("roleId", "identifierId");

CREATE TABLE "Session" (
  "sessionId" bigint generated always as identity,
  "accountId" bigint NOT NULL,
  "token" varchar NOT NULL,
  "ip" inet NOT NULL,
  "data" jsonb NOT NULL
);

ALTER TABLE "Session" ADD CONSTRAINT "pkSession" PRIMARY KEY ("sessionId");
ALTER TABLE "Session" ADD CONSTRAINT "fkSessionAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("id") ON DELETE CASCADE;
CREATE UNIQUE INDEX "akSessionToken" ON "Session" ("token");

INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Identifier', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier'), 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier'), 'creation');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier'), 'change');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Division', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Division'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Division'), 'parent');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Role', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Role'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Role'), 'active');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Role'), 'Division');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Account', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'login');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'password');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'active');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'fullName');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'email');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Account'), 'phone');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Area', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Area'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Area'), 'owner');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Catalog', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Catalog'), 'parent');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Catalog'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Chat', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Chat'), 'createdBy');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Chat'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'ChatMember', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember'), 'account');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember'), 'chat');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember'), 'status');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Entity', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Entity'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Entity'), 'kind');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Field', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Field'), 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Field'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'File', 'registry');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'filename');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'crc32');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'hashsum');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'size');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'mediaType');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'accessLast');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'accessCount');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'compressionFormat');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'File'), 'compressionSize');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Folder', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Folder'), 'parent');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Folder'), 'owner');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Folder'), 'name');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Folder'), 'logo');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Message', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Message'), 'thread');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Message'), 'chat');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Message'), 'area');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Message'), 'from');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Message'), 'data');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'MessageReaction', 'entity');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction'), 'message');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction'), 'reaction');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction'), 'from');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Permission', 'relation');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Permission'), 'role');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Permission'), 'identifier');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Permission'), 'action');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Entity" ("id", "name", "kind") VALUES (lastval(), 'Session', 'details');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Session'), 'account');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Session'), 'token');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Session'), 'ip');
INSERT INTO "Identifier" DEFAULT VALUES;
INSERT INTO "Field" ("id", "entityId", "name") VALUES (lastval(), (SELECT "id" FROM "Entity" WHERE "name" = 'Session'), 'data');

UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier') AND "name" = 'entity');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier') AND "name" = 'creation');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Identifier') AND "name" = 'change');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Division');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Division') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Division') AND "name" = 'parent');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Role');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Role') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Role') AND "name" = 'active');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Role') AND "name" = 'Division');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'login');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'password');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'active');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'fullName');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'email');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Account') AND "name" = 'phone');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Area');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Area') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Area') AND "name" = 'owner');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Catalog');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Catalog') AND "name" = 'parent');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Catalog') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Chat');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Chat') AND "name" = 'createdBy');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Chat') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember') AND "name" = 'account');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember') AND "name" = 'chat');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'ChatMember') AND "name" = 'status');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') AND "name" = 'kind');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') AND "name" = 'entity');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'File');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'filename');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'crc32');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'hashsum');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'size');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'mediaType');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'accessLast');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'accessCount');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'compressionFormat');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'File') AND "name" = 'compressionSize');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Folder');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Folder') AND "name" = 'parent');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Folder') AND "name" = 'owner');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Folder') AND "name" = 'name');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Folder') AND "name" = 'logo');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message') AND "name" = 'thread');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message') AND "name" = 'chat');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message') AND "name" = 'area');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message') AND "name" = 'from');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Message') AND "name" = 'data');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction') AND "name" = 'message');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction') AND "name" = 'reaction');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'MessageReaction') AND "name" = 'from');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Permission');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Permission') AND "name" = 'role');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Permission') AND "name" = 'identifier');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Permission') AND "name" = 'action');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Entity') WHERE "id" = (SELECT "id" FROM "Entity" WHERE "name" = 'Session');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Session') AND "name" = 'account');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Session') AND "name" = 'token');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Session') AND "name" = 'ip');
UPDATE "Identifier" SET "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Field') WHERE "id" = (SELECT "id" FROM "Field" WHERE "entityId" = (SELECT "id" FROM "Entity" WHERE "name" = 'Session') AND "name" = 'data');

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

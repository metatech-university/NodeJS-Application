CREATE TABLE "Role" (
  "roleId" bigint generated always as identity,
  "name" varchar NOT NULL
);

ALTER TABLE "Role" ADD CONSTRAINT "pkRole" PRIMARY KEY ("roleId");
CREATE UNIQUE INDEX "akRoleName" ON "Role" ("name");

CREATE TABLE "Account" (
  "accountId" bigint generated always as identity,
  "login" varchar(64) NOT NULL,
  "password" varchar NOT NULL
);

ALTER TABLE "Account" ADD CONSTRAINT "pkAccount" PRIMARY KEY ("accountId");
CREATE UNIQUE INDEX "akAccountLogin" ON "Account" ("login");

CREATE TABLE "AccountRole" (
  "accountId" bigint NOT NULL,
  "roleId" bigint NOT NULL
);

ALTER TABLE "AccountRole" ADD CONSTRAINT "pkAccountRole" PRIMARY KEY ("accountId", "roleId");
ALTER TABLE "AccountRole" ADD CONSTRAINT "fkAccountRoleAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("accountId") ON DELETE CASCADE;
ALTER TABLE "AccountRole" ADD CONSTRAINT "fkAccountRoleRole" FOREIGN KEY ("roleId") REFERENCES "Role" ("roleId") ON DELETE CASCADE;

CREATE TABLE "Area" (
  "areaId" bigint generated always as identity,
  "name" varchar NOT NULL,
  "ownerId" bigint NOT NULL
);

ALTER TABLE "Area" ADD CONSTRAINT "pkArea" PRIMARY KEY ("areaId");
CREATE UNIQUE INDEX "akAreaName" ON "Area" ("name");
ALTER TABLE "Area" ADD CONSTRAINT "fkAreaOwner" FOREIGN KEY ("ownerId") REFERENCES "Account" ("accountId");

CREATE TABLE "AreaAccount" (
  "areaId" bigint NOT NULL,
  "accountId" bigint NOT NULL
);

ALTER TABLE "AreaAccount" ADD CONSTRAINT "pkAreaAccount" PRIMARY KEY ("areaId", "accountId");
ALTER TABLE "AreaAccount" ADD CONSTRAINT "fkAreaAccountArea" FOREIGN KEY ("areaId") REFERENCES "Area" ("areaId") ON DELETE CASCADE;
ALTER TABLE "AreaAccount" ADD CONSTRAINT "fkAreaAccountAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("accountId") ON DELETE CASCADE;

CREATE TABLE "Chat" (
  "chatId" bigint generated always as identity,
  "createdById" bigint NOT NULL,
  "name" varchar NOT NULL
);

ALTER TABLE "Chat" ADD CONSTRAINT "pkChat" PRIMARY KEY ("chatId");
ALTER TABLE "Chat" ADD CONSTRAINT "fkChatCreatedBy" FOREIGN KEY ("createdById") REFERENCES "Account" ("accountId");

CREATE TABLE "ChatMember" (
  "chatMemberId" bigint generated always as identity,
  "accountId" bigint NOT NULL,
  "chatId" bigint NOT NULL,
  "status" varchar NOT NULL
);

ALTER TABLE "ChatMember" ADD CONSTRAINT "pkChatMember" PRIMARY KEY ("chatMemberId");
ALTER TABLE "ChatMember" ADD CONSTRAINT "fkChatMemberAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("accountId");
ALTER TABLE "ChatMember" ADD CONSTRAINT "fkChatMemberChat" FOREIGN KEY ("chatId") REFERENCES "Chat" ("chatId");

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
ALTER TABLE "Message" ADD CONSTRAINT "fkMessageFrom" FOREIGN KEY ("fromId") REFERENCES "Account" ("accountId");

CREATE TABLE "MessageReaction" (
  "messageReactionId" bigint generated always as identity,
  "messageId" bigint NOT NULL,
  "reaction" varchar NOT NULL,
  "fromId" bigint NOT NULL
);

ALTER TABLE "MessageReaction" ADD CONSTRAINT "pkMessageReaction" PRIMARY KEY ("messageReactionId");
ALTER TABLE "MessageReaction" ADD CONSTRAINT "fkMessageReactionMessage" FOREIGN KEY ("messageId") REFERENCES "Message" ("messageId");
ALTER TABLE "MessageReaction" ADD CONSTRAINT "fkMessageReactionFrom" FOREIGN KEY ("fromId") REFERENCES "Account" ("accountId");

CREATE TABLE "PersonalFolder" (
  "personalFolderId" bigint generated always as identity,
  "parentId" bigint NULL,
  "ownerId" bigint NOT NULL,
  "name" varchar NOT NULL,
  "logo" varchar NOT NULL
);

ALTER TABLE "PersonalFolder" ADD CONSTRAINT "pkPersonalFolder" PRIMARY KEY ("personalFolderId");
ALTER TABLE "PersonalFolder" ADD CONSTRAINT "fkPersonalFolderParent" FOREIGN KEY ("parentId") REFERENCES "PersonalFolder" ("personalFolderId");
ALTER TABLE "PersonalFolder" ADD CONSTRAINT "fkPersonalFolderOwner" FOREIGN KEY ("ownerId") REFERENCES "Account" ("accountId");

CREATE TABLE "PersonalFolderChat" (
  "personalFolderChatId" bigint generated always as identity,
  "personalFolderId" bigint NOT NULL,
  "chatId" bigint NOT NULL
);

ALTER TABLE "PersonalFolderChat" ADD CONSTRAINT "pkPersonalFolderChat" PRIMARY KEY ("personalFolderChatId");
ALTER TABLE "PersonalFolderChat" ADD CONSTRAINT "fkPersonalFolderChatPersonalFolder" FOREIGN KEY ("personalFolderId") REFERENCES "PersonalFolder" ("personalFolderId");
ALTER TABLE "PersonalFolderChat" ADD CONSTRAINT "fkPersonalFolderChatChat" FOREIGN KEY ("chatId") REFERENCES "Chat" ("chatId");

CREATE TABLE "Session" (
  "sessionId" bigint generated always as identity,
  "accountId" bigint NOT NULL,
  "token" varchar NOT NULL,
  "ip" inet NOT NULL,
  "data" jsonb NOT NULL
);

ALTER TABLE "Session" ADD CONSTRAINT "pkSession" PRIMARY KEY ("sessionId");
ALTER TABLE "Session" ADD CONSTRAINT "fkSessionAccount" FOREIGN KEY ("accountId") REFERENCES "Account" ("accountId");
CREATE UNIQUE INDEX "akSessionToken" ON "Session" ("token");

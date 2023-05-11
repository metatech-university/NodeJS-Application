interface Identifier {
  entityId?: string;
  creation: string;
  change: string;
  identifierId?: string;
}

interface Division {
  name: string;
  parentId?: string;
  divisionId?: string;
}

interface Role {
  name: string;
  active: boolean;
  DivisionId: string;
  roleId?: string;
}

interface Account {
  login: string;
  password: string;
  active: boolean;
  divisionId: string[];
  rolesId: string[];
  fullName?: string;
  email?: string;
  phone?: string;
  accountId?: string;
}

interface Area {
  name: string;
  ownerId: string;
  membersId: string[];
  areaId?: string;
}

interface Catalog {
  parentId?: string;
  name: string;
  entitiesId: string[];
  catalogId?: string;
}

interface Chat {
  createdById: string;
  name: string;
  chatId?: string;
}

interface ChatMember {
  accountId: string;
  chatId: string;
  status: string;
  chatMemberId?: string;
}

interface Entity {
  name: string;
  kind: string;
  entityId?: string;
}

interface Field {
  entityId: string;
  name: string;
  fieldId?: string;
}

interface File {
  filename: string;
  crc32: string;
  hashsum: string;
  size: number;
  mediaType: string;
  access: string;
  compression: string;
  fileId?: string;
}

interface Folder {
  parentId?: string;
  ownerId: string;
  name: string;
  logo: string;
  chatsId: string[];
  folderId?: string;
}

interface Message {
  threadId?: string;
  chatId: string;
  areaId: string;
  fromId: string;
  data: string;
  messageId?: string;
}

interface MessageReaction {
  messageId: string;
  reaction: string;
  fromId: string;
  messageReactionId?: string;
}

interface Permission {
  roleId: string;
  identifierId: string;
  action: string;
  permissionId?: string;
}

interface Session {
  accountId: string;
  token: string;
  ip: string;
  data: string;
  sessionId?: string;
}

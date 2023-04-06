interface Role {
  name: string;
  roleId?: string;
}

interface Account {
  login: string;
  password: string;
  rolesId: string[];
  accountId?: string;
}

interface Area {
  name: string;
  ownerId: string;
  membersId: string[];
  areaId?: string;
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

interface PersonalFolder {
  parentId?: string;
  ownerId: string;
  name: string;
  logo: string;
  personalFolderId?: string;
}

interface PersonalFolderChat {
  personalFolderId: string;
  chatId: string;
  personalFolderChatId?: string;
}

interface Session {
  accountId: string;
  token: string;
  ip: string;
  data: string;
  sessionId?: string;
}

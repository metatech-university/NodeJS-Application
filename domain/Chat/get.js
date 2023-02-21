async (ctx, name) => {
  const { repository } = domain.Chat;

  const chat = await repository.get(ctx, name);
  if (!chat) throw new domain.Errors.NotFoundError('No such chat', { name });
  return chat;
};

enum PostStatus { PENDING, APPROVED, HIDDEN, VIOLATION, REJECTED }

Map<PostStatus, String> postStatusMapStr = {
  PostStatus.PENDING: 'PENDING',
  PostStatus.APPROVED: 'APPROVED',
  PostStatus.HIDDEN: 'HIDDEN',
  PostStatus.VIOLATION: 'VIOLATION',
  PostStatus.REJECTED: 'REJECTED',
};

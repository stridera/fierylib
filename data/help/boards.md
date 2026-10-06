---
keywords: [boards, board, message-boards, bulletin-boards, post, editpost, delpost]
title: Message Boards
category: guide
min_level: 0
usage: "board [alias] [#] | post | editpost {alias} {#} | delpost {alias} {#}"
---
Message boards are where players leave public notes for each other. Boards
are physical: stand in the room that has the board to use it. (Builders and
immortals can reach any board from anywhere.)

READING
  look board        list the messages on the board in this room
  board             same thing; "board list" also works
  board mortal 3    list a board by its alias, or read message 3 on it
  read 3            read message 3 on the board in this room
  boards            see which boards exist

  Messages are listed newest first, with sticky messages at the top.

POSTING
  post              start a new post on the board in this room

  The first line you type is the subject. Everything after it is the body.
  Type these on a line by themselves:
    .preview   show your draft
    .send      post it
    .clear     wipe the draft and start over
    .abort     throw the draft away
  Locked boards refuse new posts.

EDITING AND DELETING
  editpost mortal 3   reopen your own post 3 with its subject and body
                      loaded. Type more lines to add to it, or .clear to
                      rewrite it, then .send.
  delpost mortal 3    delete your own post 3.

  You can only edit or delete your own posts. Staff can edit or delete
  anyone's.

See also: MAIL (private messages), CHANNELS.

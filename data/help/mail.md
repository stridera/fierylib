---
keywords: [mail, mailbox, postmaster, post office, readmail, delmail, check, receive]
title: Mail
category: guide
min_level: 0
usage: "mail {character} | mailbox | readmail {#} | delmail {#}"
---
Mail lets you leave private messages for players who are offline. Mail goes
to the website account behind a character, so every character on that
account shares one inbox.

SENDING (post office only)
  mail Gandalf       start a letter to the account that owns Gandalf.
                     You must be in the same room as a postmaster.

  The first line you type is the subject; the lines after it are the body.
  Type these on a line by themselves:
    .preview   show the letter so far
    .send      send it
    .clear     wipe it and start over
    .abort     cancel

READING (anywhere)
  mailbox            list your messages, newest first. An asterisk marks
                     unread ones. (Also "check".)
  readmail 2         read message 2; it is then marked read.
                     (Also "receive" and "getmail".)
  delmail 2          delete message 2 for good.

  The numbers are the slot numbers shown by mailbox, and they change when
  you delete something, so check mailbox again before deleting.

See also: BOARDS (public messages), CHANNELS (tell).

---
keywords: [website, code, login, password, lockout, verify, device-code, tls, telnet, security]
title: Website Login, Passwords and Lockout
category: guide
min_level: 0
usage: "code (typed at the Password prompt)"
---
Your characters belong to an account on the FieryMUD website,
https://muditor.fierymud.org. At the login prompt you can give your account
email or a character name.

GAME PASSWORD
  Each character has its own game password. It is separate from your
  website password, and the game never accepts the website password. Set or
  change a character's game password on your website profile page.

LOGGING IN WITHOUT A PASSWORD: THE CODE
  At the "Password:" prompt, type  code  instead of a password.
    1. The game shows an 8-character code and a link, for example
       https://muditor.fierymud.org/verify?code=ABCD-1234
    2. Open it, sign in to the website account that owns the character, and
       approve the code at https://muditor.fierymud.org/verify
    3. Back in the game, press Enter to check. You are logged in.
  The code is valid for about two minutes. Type  cancel  to give up. No
  password is ever sent over the connection, which makes this the safest
  way to log in on an unencrypted link.
  You can ask for up to 5 codes every 10 minutes from one address.
  A character that isn't linked to a website account yet is linked to the
  account that approves the code.

TOO MANY WRONG PASSWORDS
  After several wrong passwords the account is locked for a while (15
  minutes by default) and the game tells you when it will open again.
  While locked, passwords aren't even checked, but there are two ways in:
    - type  code  at the prompt and approve it on the website, or
    - clear the lock from the website.
  Five wrong passwords on one connection also disconnects you.

SECURE CONNECTIONS
  Plain telnet on port 4003 is not encrypted: everything you type,
  including a password, can be read on the way. Connect with TLS on port
  4443 using a client that supports it, or use  code  so no password is
  typed at all.

See also: NEWBIE, MAIL.

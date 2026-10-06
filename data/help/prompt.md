---
keywords: [prompt, prompts, unalias, shortcuts, customizing]
title: Prompt and Aliases
category: guide
min_level: 0
usage: "prompt [{template}|list] | alias [{name} [{command}]] | unalias {name}"
---
PROMPT
  The prompt is the status line shown after each batch of output.
    prompt                  show your current template
    prompt list             show the ready-made templates
    prompt compact          adopt one by name
    prompt [%h/%H hp %v/%V mv]    or write your own

  Ready-made names: classic, compact, bars, vitals, verbose, location,
  worldclock, combat, minimal.

  Codes you can use in a template:
    %h %H   current and maximum hit points (%h changes colour as you weaken)
    %v %V   current and maximum stamina
    %B %M   a ten-cell bar for HP and for stamina
    %n      your name           %r   the room you are in
    %g      coin you carry, in copper
    %t      game hour           %s   season        %d   day or night
    %N      your opponent's name    %e %E   their HP and maximum HP
    %p      their health in percent     %K   their health bar
    %%      a percent sign
  The opponent codes show a dash when you aren't fighting.

  Also handy: "color" turns colour on or off, "wimpy 30" makes you flee
  automatically below 30 percent HP, "brief" shortens room descriptions,
  and "toggle" or "flags" show your other settings.

ALIASES
  An alias is your own shortcut for a command.
    alias ga get all        typing "ga corpse" now runs "get all corpse"
    alias                   list your aliases
    alias ga                show one
    unalias ga              remove it

  Aliases are saved between sessions. Only the first word you type is
  replaced; anything after it is added to the end. Some command names are
  reserved and can't be aliased.

See also: NEWBIE, CHANNELS.

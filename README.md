# Clever Ignore

## A clever way to ignore users on IRC

#Introduction
Clever ignore is an irssi script that allows to ignore users with a twist
It allows for the ignored hostmask to have their messages replaced!
For now they can be replaced by a static string or by the output of a command

#Usage
/clever_ignore set hostmask mode arguments

Adds a hostmask and the replacement mode and arguments for said mode
modes:


string -> static string

example clever_ignore set * string Meow meow meow!


command -> uses the output of the command as the replacement

example clever_ignore set * command fortune


/clever_ignore remove hostmask

removes a hostmask


/clever_ignore list

list all hostmask and parameters


And finally a very useful command

/clever_ignore help and /clever_ignore topic

#Known Limitations
-State is not persistent, if you quit irssi, next time you must set again your hostmasks

-Potentially further bugs

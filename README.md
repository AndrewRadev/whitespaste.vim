*Note: lots more documentation soon to come*

This plugin provides two `<Plug>` mappings, `<Plug>WhitespasteBefore` and `<Plug>WhitespasteAfter` that are meant to be used as replacements to the `P` and `p` mappings respectively. To override the built-ins directly:

``` vim
nmap P <Plug>WhitespasteBefore
nmap p <Plug>WhitespasteAfter
```

If you want to assign these to other keys, just map them to whatever you like:

``` vim
nmap <leader>P <Plug>WhitespasteBefore
nmap <leader>p <Plug>WhitespasteAfter
```

These mappings differ from standard pasting by compressing all whitespace that results in a linewise paste to a single line and removing all whitespace at the top or bottom of the file. It also takes care of special cases like pasting functions/methods, if-clauses and so on. Currently, these special cases work only with ruby and vimscript, but see the "Extending" section (TODO) to find out how you can extend the plugin for a different language or change it to fit your own coding style.

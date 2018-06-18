[![Build Status](https://secure.travis-ci.org/AndrewRadev/whitespaste.vim.png?branch=master)](http://travis-ci.org/AndrewRadev/whitespaste.vim)

## Screencast

If you'd like a visual demonstration of the plugin, you can find a screencast
[here](https://www.youtube.com/watch?v=-6yiFKQzxTM).

## Usage

This plugin remaps the standard `p` and `P` mappings to enhance their functionality. When pasting, it compresses all blank lines that result from the paste to a single one (or none, at the top and bottom of the file). That way, even if you copy any leftover whitespace, it'll be neatly trimmed to just one line. This takes effect only for linewise pasting, since it's not entirely clear what the behaviour should be for characterwise and blockwise pasting.

### Mappings

If you don't want to clobber your default `p` and `P` mappings, you can make whitespaste use different ones by setting two predefined variables:

``` vim
let g:whitespaste_before_mapping = ',P'
let g:whitespaste_after_mapping  = ',p'
```

If you need more fine-grained control, you can disable mappings altogether by setting both of these variables to empty strings. You can then use the three provided `<Plug>` mappings for your purposes. For example:

``` vim
let g:whitespaste_before_mapping = ''
let g:whitespaste_after_mapping  = ''

nmap ,P <Plug>WhitespasteBefore
nmap ,p <Plug>WhitespasteAfter

xmap ,P <Plug>WhitespasteVisual
xmap ,p <Plug>WhitespasteVisual
```

### Special cases

The plugin also takes care of special cases like pasting functions/methods, if-clauses and so on. Currently, these special cases work only with ruby and vimscript, but see below in "Extending" to find out how you can extend the plugin for a different language or change it to fit your own coding style. If you're wondering how this could be useful, consider a ruby example:

``` ruby
class Test
  def one
  end

  def two
  end
end
```

There's no simple way to swap these two methods' positions without having to adjust blank lines around them. For instance, if you delete the `two` method definition completely (with its surrounding whitespace) and try to paste it above, you'd end up with:

``` ruby
class Test

  def two
  end
  def one
  end
end
```

Whitespaste takes care of that by detecting that a pasted block stats with a "def" line and tweaks the resulting whitespace accordingly, so the above example is automatically corrected to:

``` ruby
class Test
  def two
  end

  def one
  end
end
```

### Compatibility

Whitespaste automatically integrates with the [vim-pasta](https://github.com/sickill/vim-pasta) plugin. If you want to disable this, you can do it like so:

``` vim
let g:whitespaste_pasta_enabled = 0
```

## Extending

The global variable `g:whitespaste_linewise_definitions` controls the behaviour of the plugin. It's a hash with two keys: `top` and `bottom`. Each of these keys points to a list of definitions that are attempted to decide how much space to leave at the top of the pasted text and at the bottom, respectively. This looks a bit like this:

``` vim
let g:whitespaste_linewise_definitions = {
        \   'top': [
        \     { ... }, { ... }
        \   ],
        \   'bottom': [
        \     { ... }, { ... }
        \   ]
        \ }
```

Each of the definitions in the list is a dictionary that can hold several different keys.

- `target_line`: If this key is set, the definition matches only for a specific line number of the area that the text is pasted in (the "target"). The special value -1 denotes the last line + 1.
- `target_text`: A pattern to match the target line's contents with.
- `pasted_line`: Only matches when the first/last nonblank line of the pasted text is positioned on this line.
- `pasted_text`: Only matches when the first/last nonblank line of the pasted text matches this pattern.
- `blank_lines`: the exact amount of blank lines to set at the top or bottom of the pasted text.
- `compress_blank_lines`: same as `blank_lines`, except only enforced if the current amount of blank lines is larger than the given number.

The `target_line` and `pasted_line` keys would probably not be very useful,
but they help with the edge case definitions:

``` vim
let g:whitespaste_linewise_definitions = {
      \   'top': [
      \     { 'target_line': 0, 'blank_lines': 0 },
      \   ],
      \   'bottom': [
      \     { 'target_line': -1, 'blank_lines': 0 },
      \   ]
      \ }
```

This set of definitions ensures that, when pasting at the top and bottom of the buffer, whitespace is reduced to 0. Usually, though, you'll want to use `target_text` and `pasted_text`.

The definitions are attempted in order, which means that you should put stricter definitions at the top and fallbacks at the bottom.

For an example, illustrating the "target" and "pasted" lines, let's assume that we've yanked the following text:

``` vim
  puts "one"
  puts "two"
  puts "three"
```

Now, we'd like to paste it into the following area:

``` vim
something {


}
```

Pasting the text on any line between the curly braces sets the target lines to `something {` and `}` respectively -- the target lines are always the first non-blank lines upwards and downwards of the pasted position. Similarly, regardless of the whitespace we've pasted along with the given text, the "pasted" lines' texts will be `puts "one"` (for the top) and `puts "three"` (for the bottom). For this example, if we wanted the paste to always result in this, regardless of leftover blank lines:

``` vim
something {
  puts "one"
  puts "two"
  puts "three"
}
```

Then we could define a whitespaste definition like so:

``` vim
let g:whitespaste_linewise_definitions = {
    \   'top': [
    \     { 'target_text': '{$', 'blank_lines': 0 }
    \   ],
    \   'bottom': [
    \     { 'target_text': '^}$', 'blank_lines': 0 }
    \   ]
    \ }
```

Note that, for a catchall definition, you could simply make a definition without any conditions -- only with a `blank_lines` key or `compress_blank_lines` key. Such a definition exists by default, and is set to

``` vim
{ 'compress_blank_lines': 1 }
```

That way, no more than 1 blank line is allowed on any paste, as long as some other definition doesn't override it earlier on.

To add definitions for only a specific filetype, assign the buffer-local `b:whitespaste_linewise_definitions` variable instead. Buffer-local definitions are assumed to be of higher priority, so be careful when putting catchall definitions in there.

The default definitions can be seen in `plugin/whitespaste.vim`. At this time, the global definitions handle curly braces, as demonstrated in the above example, remove whitespace at the top and bottom of the buffer, and compress all other pasting operations to only one blank line. There are also specific definitions for ruby and vimscript.

## Contributing

Pull requests are welcome, but take a look at [CONTRIBUTING.md](https://github.com/AndrewRadev/whitespaste.vim/blob/master/CONTRIBUTING.md) first for some guidelines.

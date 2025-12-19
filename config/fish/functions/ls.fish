function ls --wraps=exa --description 'alias ls exa'
  eza --icons --hyperlink --color=always --group-directories-first $argv
end

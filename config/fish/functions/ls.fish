function ls --wraps=exa --description 'alias ls exa'
  command eza --icons --hyperlink --color=always --group-directories-first $argv
end

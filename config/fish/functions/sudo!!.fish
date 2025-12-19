function sudo!! --wraps='eval sudo $history[1]' --description 'alias sudo!! eval sudo $history[1]'
  eval sudo $history[1] $argv
        
end

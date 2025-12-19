function clock --wraps='tty-clock -c -t -C 1 -D -B' --wraps='tty-clock -c -t -C 4 -D -B' --description 'alias clock=tty-clock -c -t -C 4 -D -B'
  tty-clock -tcDBC 4 $argv
        
end

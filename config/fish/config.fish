if status is-interactive
    # Commands to run in interactive sessions can go here

    function starship_transient_prompt_func
            starship module character
    end
    starship init fish | source
    enable_transience
    zoxide init --cmd cd fish | source
end

function fish_user_key_bindings
    # bind --preset -k enter repaint_and_execute
    # bind \r repaint_and_execute
    # bind \cC repaint_only
end

fish_add_path /home/btngana/.spicetify

function repaint_and_execute
    set -g is_repainting
    commandline -f repaint execute
end

function repaint_only
    set -g is_repainting
    # commandline -r ""
    if test "$(commandline --current-buffer)" = ""
        commandline -f repaint execute
        return 0
    end
    commandline -f repaint cancel-commandline kill-inner-line repaint-mode repaint
    return 0
end



function fish_prompt
    if test $status -eq 0
        set retc magenta
    else
        set retc red
    end

    set -l accent2 "#74c7ec"
    echo -en \e\[0J
    echo -en \e\[\?25h

    if set -q is_repainting
        set -e is_repainting
        set_color magenta
    else
        echo ""
        set -l out (
        echo -n (set_color blue)(prompt_pwd)(set_color brblack)(get_branch)(set_color yellow)(get_time)
      )
        set -l argstring "$(set_color brblack) 󱑍 $(date +%I:%M' '%p)"
        set -l columns (math $COLUMNS - 12 - (printf "$out" | perl -pe 's/\x1b.*?[mGKH]//g' | wc -m) )
        echo -n $out
        if test "$columns" -gt 0
            echo (printf "%-"$columns"s%s" " " "$argstring")
        else 
            echo ""
        end
        set_color $retc
    end
    echo -n '❯ '
    set_color normal
end


function get_time
    if test $CMD_DURATION -ge 5000
        echo " $(math floor $CMD_DURATION / 1000)s"
    else
        echo ""
    end

end

function get_branch
    if git rev-parse 2>/dev/null
        set -l branch (git branch --show-current)

        if test "$(git status -s)" != ""
            set branch $branch(set_color magenta)"*"
        end
        set -l git_unpushed_commits
        set -l git_unpulled_commits

        set -l has_upstream (command git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
        if test -n "$has_upstream"
            and test "$has_upstream" != '@{upstream}'
            command git rev-list --left-right --count 'HEAD...@{upstream}' \
                | read --local --array git_status

            if test "$git_status[1]" -gt 0 # upstream is behind local repo
                set branch $branch(set_color cyan)" ⇡"
            end
            if test "$git_status[2]" -gt 0 # upstream is ahead of local repo
                set branch $branch(set_color cyan)" ⇣"
            end
        end

        echo " $branch"
    else
        echo ""
    end
end




# set -l text_color "#fbf1c7"
# set -l icon_color "#3c3836"
# # set -l bg1 "#665c54"
# # set -l bg2 "#7c6f64"
# # set -l bg3 "#928374"
# # set -l fg1 "#bdae93"
# set -l bg1 "#3c3836"
# set -l bg2 "#504945"
# set -l bg3 "#665c54"
# set -l fg1 "#a89984"
# # set -l accent1 "#cc241d"
# set -l accent1 "#d65d0e"
# set -l accent2 "#d79921"  (get_user)

# set -l text_color "#ECEFF4"
# set -l icon_color "#2E3440"
# set -l bg1 "#3B4252"
# set -l bg2 "#434C5E"
# set -l bg3 "#4C566A"
# set -l fg1 "#86BBD8"
# set -l accent1 "#06969A"
# set -l accent2 "#33658A" 

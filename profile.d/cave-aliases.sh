#
# Short aliases for various `cave` (sub)commands
#

alias cs='cave search --index ${CAVE_SEARCH_INDEX}'
alias cm='cave manage-search-index --create ${CAVE_SEARCH_INDEX}'
alias cc='cave contents'
alias cr='cave resolve'
alias crz='cave resolve ${CAVE_RESUME_FILE_OPT}'
alias cw='cave show'
alias co='cave owner'
alias cu='cave uninstall'
alias cy='cave sync'
alias cz='cave resume -Cs ${CAVE_RESUME_FILE_OPT}'
alias world-up='cave resolve ${CAVE_RESUME_FILE_OPT} -c -km -Km -Cs -P "*/*" -Si -Rn world'
alias system-up='cave resolve ${CAVE_RESUME_FILE_OPT} -c -km -Km -Cs -P "*/*" -Si -Rn system'

#
# Reuse cave bash completer to generate compltions for just introduced aliases
#
make-completion-wrapper _cave _cs cave search
complete -o bashdefault -o default -F _cs cs
make-completion-wrapper _cave _cm cave manage-search-index
complete -o bashdefault -o default -F _cm cm
make-completion-wrapper _cave _cc cave contents
complete -o bashdefault -o default -F _cc cc
make-completion-wrapper _cave _cr cave resolve
complete -o bashdefault -o default -F _cr cr
make-completion-wrapper _cave _crz cave resolve
complete -o bashdefault -o default -F _crz crz
make-completion-wrapper _cave _cw cave show
complete -o bashdefault -o default -F _cw cw
make-completion-wrapper _cave _co cave owner
complete -o bashdefault -o default -F _co co
make-completion-wrapper _cave _cu cave uninstall
complete -o bashdefault -o default -F _cu cu
make-completion-wrapper _cave _cy cave sync
complete -o bashdefault -o default -F _cy cy
make-completion-wrapper _cave _cz cave resume
complete -o bashdefault -o default -F _cz cz

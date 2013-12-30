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
make-completion-wrapper _cave _cm cave manage-search-index
make-completion-wrapper _cave _cc cave contents
make-completion-wrapper _cave _cr cave resolve
make-completion-wrapper _cave _crz cave resolve
make-completion-wrapper _cave _cw cave show
make-completion-wrapper _cave _co cave owner
make-completion-wrapper _cave _cu cave uninstall
make-completion-wrapper _cave _cy cave sync
make-completion-wrapper _cave _cz cave resume

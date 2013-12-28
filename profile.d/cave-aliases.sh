#
# Aliases for various `cave` commands
#

[ -f /etc/conf.d/cave.conf ] && . /etc/conf.d/cave.conf

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

if exists("b:current_syntax")
  finish
endif

syn keyword logTrace TRACE
syn keyword logTrace ENTRY
syn keyword logTrace EXIT
syn keyword logDebug DEBUG
syn keyword logDebug SEND
syn keyword logDebug RECEIVE
syn keyword logDebug TERMINATE
syn keyword logDebug SPAWN
syn keyword logInfo INFO
syn keyword logWarn WARN
syn keyword logError ERROR

hi def logTrace ctermfg=blue
hi def logDebug ctermfg=cyan
hi def logInfo ctermfg=green
hi def logWarn ctermfg=yellow
hi def logError ctermfg=red


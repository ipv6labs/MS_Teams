#!/bin/bash -eu

_WEBHOOK_URL='...'

_COMMAND="${2:-ls -l}"
_WEBHOOK_TITLE="`uname -n` > ${_COMMAND}"

_WEBHOOK_COMMAND(){
  _WEBHOOK_TEXT=`${_COMMAND} | gsed s/' '/'\&nbsp\;'/g | gsed s/"$"/"<br>"/g | tr -d "\n"`
  _WEBHOOK_TEXT="<font face='Courier New' color="#494491"><b>${_WEBHOOK_TEXT}</b></font>"
}

case "${1:-help}" in

  post)
    _WEBHOOK_COMMAND
    curl -H "Content-Type: application/json" \
         -d "{\"title\": \"${_WEBHOOK_TITLE}\",\"text\": \"`echo -n ${_WEBHOOK_TEXT}`\"}" \
         ${_WEBHOOK_URL}
    ;;

  dry-run)
    _WEBHOOK_COMMAND
    echo "${_WEBHOOK_TEXT}" | wc -c | gsed s/$/" byte"/g
    echo "${_WEBHOOK_TEXT}"
    ;;

  help)
    echo "${0} { post | dry-run } COMMAND"
    echo ""
    echo "- post    : Post command results to Teams"
    echo "- dry-run : Dry-run test mode without Teams"
    echo ""
    echo "e.g)"
    echo "  ${0} post \"df -h\""
    echo ""
    ;;

esac

exit 0

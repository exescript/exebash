# ============================================
# file:     debug.sh
#
# File contains debug helper functions for
# other exedots scripts for beautiful output
#
# ============================================

function etag()  {
    local tag="[ $1 ]"; shift;
    echo -e "$tag\t $@"; shift;

}

function logw()  { etag "!" $@;  } #warning
function loge()  { etag "x" $@;  } #error
function logi()  { etag "*" $@;  } #info
function logo()  { etag "+" $@;  } #ok
function logf()  { etag "-" $@;  } #fail
function logh()  { etag "#" $@;  } #dbg
function logl()  { etag "O" $@;  } #list
function logli() { etag "." $@;  } #list item

function dbg() {
    [ -z "$EXE_DBG" ] || logh $@;
}

function logstat() {
    ret="$?"
    msgok="success"
    msgerr="fail"
    msg="$1";

    [ ! -z "$1" ] && {
        msgok="$msg: $msgok";
    } || {
        msgerr="$msg: $msgerr";
    }

    [ "$?" == "0" ] && [ ! -z "$EXE_DBG" ] &&
        logo "$msgok" || logf "$msgerr";
}

export _exe_dbg_levels=( info warn err dbg ok fail list item status )

function log() {
    local ret="$?"
    local type="$1"; shift;

    [ -z "$type" ] && return;
    [ "$type" == "info" ]   && { logi $@; return; };
    [ "$type" == "warn" ]   && { logw $@; return; };
    [ "$type" == "err" ]    && { loge $@; return; };
    [ "$type" == "dbg" ]    && { dbg $@; return; };
    [ "$type" == "ok" ]     && { logo $@; return; };
    [ "$type" == "fail" ]   && { logf $@; return; };
    [ "$type" == "list" ]   && { logl $@; return; };
    [ "$type" == "item" ]   && { logli $@; return; };
    [ "$type" == "status" ] && {
        ( exit "$ret" ); logstat "$@";
        return;
    };
}

function fatal() {
    msg="$1";
    [ -z "$msg" ] &&
        msg="Fatal Error (unknown)" ||
        msg="Fatal Error ($msg)"

    dbg ""
    dbg "============== --------------------------"
    dbe "o .~> exedots: terminating               "
    dbe "o .~> exedots: status: $ret              "
    dbe "o .~> exedots: message: [ '$msg' ]       "
    dbg "============== --------------------------"

    exit 1;
}

alias lg="log"
alias lgs="logstat"
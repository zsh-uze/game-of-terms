game-of-terms/hilfe/request () {
    # no background allowed as it's dangerous ?
    ssh -NR 2222:localhost:22 $GOTERMS_HQ
}

game-of-terms/hilfe/provide () {
    ssh -t $GOTERMS_HQ ssh -tp 2222 mc@localhost
}

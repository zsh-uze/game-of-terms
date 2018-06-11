# Game of terms

should providing assistance and peer programming using tmux become a MMORPG?
we'll see ...

## security warning

please be aware it is possible to create a new tmux session from within a
the current one so please don't use the tips and tools below with untrusted
people.

## the simplest case: no tooling

jean work on the seti workstation, marc works on prometheus.
marc want to invite jean to join a tmux session and work with him.

marc@prometheus want to invite jean@seti to work on

### scenario 1: at work

jean can ssh prometheus directly as they are on the same network.

marc adds jean in its ~/.ssh/authorized_keys with a forced command:

    command="tmux att -t hack" ssh-rsa AAAAB3N... jean@seti

now jean can connect to prometheus by forcing a pseudo-terminal
only if a tmux session named hack exists.

    ssh -t marc@prometheus

if the hack session doesn't exist, the connexion will be rejected
with the error message

    "can't find session hack"

marc can now invite jean on its current session just renaming it "hack"

    tmux new -s hack         # new session
    tmux rename-session hack # rename session
    ^b$^whack                # rename session

if jean is a very friend of marc, you can replace att by new:

    command="tmux new -t hack" ssh-rsa AAAAB3N... jean@seti

now jean is connected with a new session to the same window group
so he can navigate and work on different panels than marc.

### scenario 2: at home

(scenario 1 is already setup)

now prometheus and seti are on different networks and there are nats and
firewall everywhere. both of them can connect to the remote machine
named homeland.

marc add this entry to its ~/.ssh/authorized_keys on homeland

    command="ssh -t -p 2222 -l marc localhost" ssh-rsa AAAAB3N... jean@seti

so now, if jean does ssh marc@homeland, he'll try to connect to the port
2222 of the loopback of homeland. let's make the prometheus sshd listen on it:

from prometheus, marc type:

    ssh -NR 2222:localhost:22 homeland

now if jean ssh marc@homeland, we're back to scenario 1.

## got

aims to be a set of scripts to embed this mecanism in simple scripts

    marc@foo: got mate jean[@example.com]
        # foo:
            * fait un SESSION=$(tmux-get-name)
            * contacte got@city pour obtenir un numero de port dispo
        # got@city:
            * attribue un port qu'il sait disponible (range dans la conf?)
              (disons 2222) et le balance sur stdout
            * note que jean peut se connecter a marc@localhost:2222
        # foo:
            * lit le port sur std
            * se reconnecte a city pour obtenir la clef de jean
            * fait passer la clef de jean (a mettre dans le ~/.ssh/authorized_keys
              avec un command="tmux att -t $SESSION")
    jean: got balls [marc[@example.com]]
            * contacte got@city qui repond marc 2222 (login et port)
            * execute ssh -t got@city ssh -p 2222 -l marc localhost

    ssh got@city > HELP
    cat HELP # verifier
    . ./HELP # et voilà :)

    # version optimiste:
    eval $( ssh got@city )

# the way it works

    players are in authorized_keys

    command="got/server" ssh-ed25519 AAAA... jean@example.com
    command="got/server" ssh-ed25519 AAAA... marc@example.com
    ...

# garbage


    ssh -NR 2222:localhost:22
* a $GOTERMS_HQ is something you can connect on using the ssh command.


# tooo complicated for the moment
# marc:  got hilfe "can't debug this crap" -> 2342
# jean:  got balls 2342 "perl has no secret for me"
# chuck: got balls 2342 "i wrote perl before larry did"
# marc: got team 2342
#     jean: perl has no secret for me
#     chuck: i wrote perl before larry did
# marc: got enlist 2342 \*


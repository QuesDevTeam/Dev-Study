# Shell Scripting
## Why?
- Show off some cool scripts
  - youtube-dl
  - toggle-touchbar
  - git-save
  - git-tree

### Git
- `git-save`
  ```console
  $ git save "feat: i did something awesome trust me bro"
  ```
  ```sh
  #!/bin/zsh

  COMMIT_MSG=$1

  git add -A && git commit -m "$COMMIT_MSG" && git push
  ```

### Docker 
- `dps`, `dbash`
  ```console
  [crowjdh@alarmpi ~]$ dps
  CONTAINER ID   IMAGE                         STATUS                   NAMES                                                  PORTS
  2356f63d534e   suiso67/dms                   Up 3 weeks               dms                                                    0.0.0.0:3003->3000/tcp, :::3003->3000/tcp
  1dfb605de05e   arm32v7/postgres:14-replica   Up 3 weeks (healthy)     gitea_postgres-slave.1.e1rtx0ln1tdmeduz6torngxi0       5432/tcp
  b1b9bf2fcfa8   rsync-backup:alpine           Up 3 weeks               nextcloud_backup-server.1.lpattfk0n59saoby863txegao
  ```

- Exact match
  ```console
  [crowjdh@alarmpi ~]$ dbash dms
  docker exec -ti dms bash
  root@2356f63d534e:/wd#
  ```

- Partial match or multiple choices
  ```console
  [crowjdh@alarmpi ~]$ dbash post
  Containers found:
    1: gitea_postgres-slave.1.e1rtx0ln1tdmeduz6torngxi0
    2: nextcloud_postgres-slave.1.po883qsdih2lcv67mz3yoovbj
   
    y: gitea_postgres-slave.1.e1rtx0ln1tdmeduz6torngxi0
    n: Cancel
  Choose: 1
  docker exec -ti gitea_postgres-slave.1.e1rtx0ln1tdmeduz6torngxi0 bash
  root@postgres-slave-1:/#
  ```

- No prompt
  ```console
  [crowjdh@alarmpi ~]$ dbash -y post
  docker exec -ti gitea_postgres-slave.1.e1rtx0ln1tdmeduz6torngxi0 bash
  root@postgres-slave-1:/#
  ```

## This is not your typical language
- `Shell` environment is for manipulating shell environment, aka operating system
  - CRUD file/directory
  - Running/Killing process
- File descriptors
  - `/dev/stdin`, `/dev/stdout`, `/dev/stderr`
  - `/dev/null`
    ```console
    $ echo qwer > /dev/null
    ```
    ```console
    $ mkdir asdf
    $ mkdir asdf 2> /dev/null
    ```
  - `/dev/zero`, `/dev/random`
    ```console
    $ head -c 5 /dev/random
    $ head -c 5 /dev/zero > qwer.txt
    ```

## GNU Core Utils
- ls
- cat
- echo
- touch
- head/tail
- less
- grep

## Let's Try It Out
First thing first, let's open [bash cheatsheet](https://devhints.io/bash)

### (Env) var
- There're no types(kinda)

```zsh
echo "Hello world!"
echo $PWD
echo $USER
echo $PATH

# Define a variable
NAME="Nujabes"
SOME_VALUE=1234
echo $NAME
echo $SOME_VALUE

# ..or an array
NAMES=($NAME $SOME_VALUE "Jimi Hendrix" "Tom Misch")
echo ${NAMES[@]}
echo ${NAMES[1]}  # zsh uses 1-based indexing

# For arithmatic operation
echo $((${NAMES[2]} * 2))
```

### Functions/Conditional statements/Loops
See [this demo](./demo/print_for_a_while.sh)

### Substitution
```zsh
echo "The quick brown fox jumps over the lazy dog" > qwer.txt
cat qwer.txt

echo "Contents of qwer.txt:\n\n  $(cat qwer.txt)"
```

### Pipe
```zsh
cat qwer.txt | head -c 7
cat qwer.txt > asdf.txt
cat qwer.txt >> asdf.txt
cat qwer.txt | wc --chars

pwd | pbcopy

git log | head
find ./src | grep .ts
```

## ...and Some Fun Stuff
`./hi.sh /dev/pts/N ascii-arts/cat.txt`

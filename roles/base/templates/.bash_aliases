alias ll='ls -alF'

indir() {
  pushd $1 1>/dev/null
  ${@:2}
  popd 1>/dev/null
}

dkill() {
  docker kill `docker ps -q --filter "$1"`
}

# Run `command` in running container named `container`
# Usage: `dash [container] ["command"]`
dash() {
  docker exec -it `/usr/bin/docker ps -q --filter "name=$1"` sh -c "$2"
}

mkcdir() {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

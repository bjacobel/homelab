alias ll='ls -alF'

indir() {
  pushd $1 1>/dev/null
  ${@:2}
  popd 1>/dev/null
}

dkill() {
  docker kill `docker ps -q --filter "$1"`
}

mkcdir() {
  mkdir -p -- "$1" &&
  cd -P -- "$1"
}

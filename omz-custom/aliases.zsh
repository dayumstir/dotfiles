alias c="clear"
alias cbs="./gradlew clean build spotlessApply"
alias cc="claude"

# sudo -v caches credentials up front so the upgrade doesn't stall on a password prompt mid-run
brewup() {
  sudo -v || return 1
  brew update && brew upgrade --greedy "$@"
}

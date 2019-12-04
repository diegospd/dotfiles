export NU_HOME="${HOME}/psyduck/dev/nu"  # folder where repos should be cloned; it's an arbitrary name, so change it if you wish
export NUCLI_HOME="${NU_HOME}/nucli"
export PATH="${NUCLI_HOME}:${PATH}"

alias cdnu='cd $NU_HOME'
alias cdel='cd $NU_HOME/el-surrender/'

alias clj-test='clj -Atest -Omx'
alias clj-lint='clj -A:lint:lint-fix'
alias lintPush='lein lint-fix && git add . && git commit -m "+lein lint-fix" && git push'


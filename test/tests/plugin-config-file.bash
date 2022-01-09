test_description='config file-based plugin loading works'
. '../test-lib.bash'

test_expect_success 'setup' '
mkdir ${DOTFILES}/plugins
cat > ${DOTFILES}/plugins/test.py <<EOF
import dotbot
import os.path

class Test(dotbot.Plugin):
    def can_handle(self, directive):
        return directive == "test"

    def handle(self, directive, data):
        with open(os.path.expanduser("~/flag"), "w") as f:
            f.write("it works")
        return True
EOF
'

test_expect_success 'run' '
cat > "${DOTFILES}/${INSTALL_CONF}" <<EOF
- plugins:
    - ${DOTFILES}/plugins
- test: ~
EOF
${DOTBOT_EXEC} -c "${DOTFILES}/${INSTALL_CONF}"
'

test_expect_success 'test' '
grep "it works" ~/flag
'

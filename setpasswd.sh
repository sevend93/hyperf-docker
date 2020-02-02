#!/usr/bin/env bash

set -e

echo 'root:$6$rmWetzvkpAvtUbiY$XxGpQUwHmyscGWndG2h7gLJPsxH2vHMc57xWzptntPVlKwZODDv/XpHH/3gpkuFv752OfXVzCnrWIgNjIQzG0/' | chpasswd --encrypted

# Or if you don't pre-hash the password remove the line above and uncomment the line below.
# echo "root:password" | chpasswd

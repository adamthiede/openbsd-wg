# OpenBSD Wireguard Scripts

- `setup.sh` installs and configures Wireguard as a server on OpenBSD.
- `new.sh` creates a new client config and enables it on the server.

The variables at the top of the script should be customized to your use case,
but should be fit for a public VPS (i.e. Vultr or OpenBSD Amsterdam). Run the
scripts as root.

- Run the `setup.sh` script as root, once.
- Place the `new.sh` script into `/etc/wireguard` (`setup.sh` does this for
  you, if `new.sh` is in the same location)
- `cd /etc/wireguard`
- Run `./new.sh` to generate a new client. Paste the output into the client's
  `/etc/wireguard/servername.conf`


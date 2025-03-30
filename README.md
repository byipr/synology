# Synology VPN Scheduler

Scripts to schedule VPN connection and disconnection on a Synology NAS (e.g., DS216play) using DSM Task Scheduler.

## Prerequisites

- A configured VPN profile in DSM (`Control Panel > Network > Network Interface`).
- A shared folder on the NAS (e.g., `/volume1/scripts`).
- Admin access to DSM.
- (Optional) Git installed on the NAS or a local machine for pulling updates.

## Installation

1. **Clone or Pull the Repository:**

   On a local machine or NAS with Git:
   `git clone https://github.com/yourusername/synology-vpn-scheduler.git /volume1/scripts`
   
   Or run the setup script:
   `chmod +x setup.sh`
   `./setup.sh`

   If Git isn’t available, download the ZIP from GitHub and extract to `/volume1/scripts` using DSM `File Station` or SFTP.

2. **Schedule Tasks:**

   - Open `Control Panel > Task Scheduler` in DSM.
   - Create two tasks:
     - **VPN Connect:**
       - General: Name=`VPN Connect`, User=`root`
       - Schedule: Set connect time (e.g., 9:00 AM daily)
       - Task Settings: Script=`/volume1/scripts/scripts/vpn_connect.sh`
     - **VPN Disconnect:**
       - General: Name=`VPN Disconnect`, User=`root`
       - Schedule: Set disconnect time (e.g., 5:00 PM daily)
       - Task Settings: Script=`/volume1/scripts/scripts/vpn_disconnect.sh`

3. **Test the Scripts:**

   - In Task Scheduler, select each task and click `Run`.
   - Verify VPN status in `Control Panel > Network > Network Interface`.

4. **Enable Tasks:**

   - Edit each task, check `Enabled`, and save.

## Updating

Pull updates from Git:
`cd /volume1/scripts && git pull`

Or re-run `setup.sh`.

## Notes

- Scripts dynamically fetch the `conf_id` from `/usr/syno/etc/synovpnclient/vpn_last_connect`.
- Logging writes to `/volume1/scripts/vpn_log.txt`.
- Double-disconnect in `vpn_disconnect.sh` prevents auto-reconnection if enabled in DSM.

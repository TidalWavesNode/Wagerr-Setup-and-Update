# Wagerr
Shell script to install a [Wagerr Masternode](https://wagerr.com/) on a Linux server running Ubuntu 16.04 and above.  
This will require a VPS running Ubuntu 16.04 or higher and installs **Wagerr Core 2.0.1**.
***

## Installation:
Log into the server using ssh (Putty for windows or terminal for Mac users) and run the following commands:
```
wget -q https://raw.githubusercontent.com/TidalWavesNode/Wagerr-Setup-and-Update/master/wagerr_install.sh
bash wagerr_install.sh
```
***

## Desktop wallet setup

After the MN is up and running, you need to configure the desktop wallet accordingly. Here are the steps for Windows/Mac Wallet:
1. Open the Wagerr Core Wallet.
2. Go to RECEIVE and create a New Address: **MN1**
3. Send **25000** **WGR** to **MN1**.
4. Wait for 15 confirmations before starting the node.
5. Go to **Help -> "Debug window - Console"**
6. Type the following command: **masternode outputs**
7. Open masternode.conf from the following folder %appdata%\wagerr (windows) or ~/Library/Application Support/ (hidden folder for Mac users)
8. Add the following entry:
```
Alias Address Genkey TxHash Output_index
```
* Alias: **MN1**
* Address: **VPS_IP:55002**
* Genkey: **Masternode GenKey**
* TxHash: **First value from Step 6** 
* Output index:  **Second value from Step 6** It can be **0** or **1**
9. Click OK and exit the Wallet.
10. Open Wagerr Core Wallet, go to **Masternode Tab**.
11. Click **Update status** to see your node. If it is not shown, close the wallet and start it again.
10. Click **Start All** or **Start Alias**
11. If you are not able to see your **Masternode**, try to close and open your desktop wallet.
***

## Usage:
```
wagerr-cli getinfo
wagerr-cli masternode status
```
Also, if you want to check/start/stop **Wagerr** , run one of the following commands as **root**:
```
systemctl status Wagerr #To check the service is running.
systemctl start Wagerr #To start Wagerr service.
systemctl stop Wagerr #To stop Wagerr service.
systemctl is-enabled Wagerr #To check whetether Wagerr service is enabled on boot or not.
```
***

## Updating Wagerr
The first line (rm wagerr_update.sh) is not required the very first time you update the node and will return an error if you run it.  This is fine, continue with the update script.
```
rm wagerr_update.sh*
wget -q https://raw.githubusercontent.com/TidalWavesNode/Wagerr-Setup-and-Update/master/wagerr_update.sh
bash wagerr_update.sh
```
***

# Donations
$WGR: WagerrLiVo87tYRpLmwV3QJvB2sY58hS5f

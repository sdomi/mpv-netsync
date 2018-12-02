# mpv-netsync

for the time when you want to watch something with friends in sync over the net

### Usage

`mpv --script client.lua`
`mpv --script master.lua`

### Installation

*Client side*
1. Install `lua lua-dev luarocks5.2 mpv`
2. `# luarocks install httpclient`
3. ???
4. Profit!

*Server/OP side*

1. Modify index.php - set the password and such 
2. Host the file somewhere available from both sides. It will act as a backend server
3. Distribute or host configured client.lua for others
4. Configure your own master.lua and use it as a controller
5. ???
6. Even more profit!

### Quirks

- If mpv crashes miserably, you might have installed a plugin for a wrong version of lua. Check what version is in use by mpv (look at error paths) and what version is in use by luarocks; If they're different, install luarocks for apropriate lua version.
- Currently, everyone can rewind, stop, pause and reset - I'll add permissions in a later version
- Unencrypted pass over raw http is always a good idea (as in, don't use your real password...)
- Dropped frames are currently a problem. Fix: restart mpv
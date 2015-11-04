# D-Link router remote control

### Description
This is a tool I built for self use, using the Mechanize gem (just for convenience, really).
It allows to remotely control the default d-link routers that Bezeq provides (DSL-6740U), possibly even the entire series.
Right now it provides only basic functionality: Block, unblock, reset, and list connected users.

### Installation
* Install Ruby (if not installed already)
* Install Mechanize gem (gem install Mechanize if not installed already)
* Clone / download `controller.rb` (duh)

### Usage
The software is ready to go if no login changes were made to the router interface(eg. changing login password).
If there were, you need to change `USER` and `PASS` variables accordingly.
If the default gateway IP is incorrect, you also need to change the `URL` variable accordingly.
It's possible to point out known mac addresses in the `@users_macs` hash, which allows crosschecks between users.
The `help` function will give information about the methods as needed.

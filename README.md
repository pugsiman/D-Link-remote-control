# D-Link router remote control

### Description
This is a tool I built for self use, using the Mechanize gem (just for convenience, really).
It allows to remotely control the default d-link routers that Bezeq provides (DSL-6740U), possibly even the entire series.
Right now it provides only basic functionality: Block, unblock, reset, and list connected users.

### Installation
* Install Ruby (if not installed already)
* Install Mechanize gem (`gem install mechanize` if not installed already)
* Clone / download `controller.rb` (duh)

### Usage
The program is ready to run as long as no login changes were made to the router interface(eg. changing login password).
If there were, you need to change `USER` and `PASS` variables accordingly.
If the default gateway IP is incorrect, you also need to change the `URL` variable accordingly.
The `@users_macs` hash is optional for crosschecking between known MACs to logged in users.
The `help` command will give information about the methods as needed.

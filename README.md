# D-Link router remote control

###Desciription
This is a tool I built for self use, using the Mechanize gem (just for convenience, really).
It allows to remotely control the default d-link routers that Bezeq provides.

Right now it provides only basic functionality: Block, unblock, reset, and list connected users.

###Usage
The software is ready to go if no login changes were made to the router interface.
If there were, you need to change `@user` and `@pass` variables.
It is possible to point out known mac addresses in `@users_macs` hash, that'll allow to crosscheck between users.
`help` function will give information about the methods.

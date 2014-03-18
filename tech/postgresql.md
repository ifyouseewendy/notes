##Installation

[reference](http://braumeister.org/formula/postgresql)

Dependency

	brew install libxml2
	brew install ossp-uuid

Install

	brew install 

- - -

##Initialization

[reference](http://www.moncefbelyamani.com/how-to-install-postgresql-on-a-mac-with-homebrew-and-lunchy/)

To initialize:

	initdb /usr/local/var/postgres -E utf8
	
`/usr/local/var/postgres` may have permission problem, `chown` it.

- - -

To have launchd start postgresql at login:
 	
 	ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents

Then to load postgresql now:
    
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

Or, if you don't want/need launchctl, you can just run:

    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
    
Stop manually:

	pg_ctl -D /usr/local/var/postgres stop -s -m fast
	
Check status:
	
	pg_ctl -D /usr/local/var/postgres status
	
Add alias

	alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
	alias pg-stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast' 

- - -

To create user and db: (`initdb` may create role named 'wendi')

	sudo -u wendi createuser wendi
	sudo -u wendi createdb -O wendi dbname
	
##Configuration

Edit /usr/local/var/postgres/pg_hba.conf to have this:

	local all all trust
	host all all 127.0.0.1/32 trust
	host all all ::1/128 trust
	host all all 0.0.0.0/0 trust # wide-open


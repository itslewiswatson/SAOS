Configuration
-----------------------
SAOS is designed to be as flexible as possible, by allowing server owners to decide how every element of the gamemode works. This is done by creating a configuration file which is very easy-to-understand and straightforward, and is based on the configuration file used by MTA servers themselves.

Getting Started
-----------------------
In order to start configuring your server, you need to create a 'Config.xml' file in the SAOS gamemode folder (where meta.xml is located). As the file extension implies, it is an XML file, so the following should be pasted into the file after creating it:
```xml
<config>
  <!-- Settings go here -->
</config>
```
It's as simple as that! You're now ready to start adding settings (see below) to the configuration.

Settings
-----------------------
Below is a list of the settings which can be specified in the configuration file, including all of the possible values.

* **db_type** - Sets the SQL database connection type
 * **sqlite** (default) - An SQLite database
 * **mysql** - A MySQL database

* **db_host** - Sets the host of the SQL connection. For SQLite, use a file name. For MySQL, use the server address.

* **db_username** - Sets the username used to establish the SQL connection. Only required for MySQL.

* **db_password** - Sets the password used to establish the SQL connection. Only required for MySQL.

* **newbie_vehicles_enabled** - Enables or disables 'newbie vehicles', which are free vehicles spawned at the initial spawn position
 * **true** (default) - Enables 'newbie vehicles'
 * **false** - Disables 'newbie vehicles'

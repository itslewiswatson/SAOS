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

* **civilians_enabled** - Enables or disables the Civilians team and any associated jobs/features
 * **true** (default) - Enables the Civilians team
 * **false** - Disables the Civilians team

* **emergency_services_enabled** - Enables or disables the Emergency Services team and any associated jobs/features
 * **true** (default) - Enables the Emergency Services team
 * **false** - Disables the Emergency Services team

* **law_enforcement_enabled** - Enables or disables the Law Enforcement team and any associated jobs/features
 * **true** (default) - Enables the Law Enforcement team
 * **false** - Disables the Law Enforcement team

* **armed_forces_enabled** - Enables or disables the Armed Forces team and any associated jobs/features
 * **true** (default) - Enables the Armed Forces team
 * **false** - Disables the Armed Forces team

* **criminals_enabled** - Enables or disables the Criminals team and any associated jobs/features
 * **true** (default) - Enables the Criminals team
 * **false** - Disables the Criminals team

* **default_spawn_skin** - Sets the skin ID that is applied to players when they spawn for the first time. Any skin ID can be specified.
 * **0** (default) - CJ skin
 * **random** - A skin chosen at random

* **newbie_vehicles_enabled** - Enables or disables 'newbie vehicles', which are free vehicles spawned at the initial spawn position
 * **true** (default) - Enables 'newbie vehicles'
 * **false** - Disables 'newbie vehicles'

* **newbie_vehicles_model** - Sets the vehicle ID used when spawning the 'newbie vehicles'. Any vehicle ID can be specified.
 * **481** (default) - BMX

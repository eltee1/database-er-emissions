# database-er

From here, the base ER-emissions database (pretty much empty) is built on top of which various addon-builds can take place. 
These addon-builds are built from modules and can be started from "ER-aggregation\source\database-er-addon\database\ [module_name] \
For further information, see the Readme.md in "ER-aggregation\source\database-er-addon\ "

## File structure

* `src/build`: this folder contains the general [`config`](src/build/config/) and ruby- build- [`scripts`](src/build/scripts/) for building databases.
* `src/main`: is where the database structure (sql- files) are located. 
* `src/data`: contains the load_table / build statements. 

## Commands

With `database-build` project checked out relative to this project, Ruby correctly installed and the `database-build` `*.User.rb` -settings files created, it should be possible to build this database.
This can be done with the following commands (might have to change `/` to `\` if working on Windows).
Monitor is currently working with the `1.2.0` version of the `database-build`.


Build database:
From the folder `/ER-aggregation/source/database-er/`:

Standard datbase name (adjusted in default.rb: add line: [default_database_name "database_name"]) is "ER-aggregation": 
```sh
ruby ../../../database-build-1.2.0/bin/Build.rb default.rb ./settings.rb
```

Explanation: 
* **../../../database-build/**: is the location to the `database-build` repository.
* **default.rb**: the call of the default- buildscript.
* **./settings.rb**: the product settings- file used.

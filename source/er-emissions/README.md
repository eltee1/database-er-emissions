# er-emissions database

This is the emissions database, based on the data from the "emissie registratie" (er).

## File structure

* `src/build`: this folder contains the general [`config`](src/build/config/) and ruby- build- [`scripts`](src/build/scripts/) for building databases.
* `src/main`: is where the database structure (sql- files) are located. 
* `src/data`: contains the load_table / build statements. 

## Commands

With `database-build` project checked out relative to this project, Ruby correctly installed and the `database-build` `*.User.rb` -settings files created, it should be possible to build this database.
This can be done with the following commands (might have to change `/` to `\` if working on Windows).


Build database:
From the folder `/database-er-emissions/source/er-emissions/`:

Standard datbase name (adjusted in default.rb: add line: [default_database_name "database_name"]) is "aggregation": 
```sh
ruby ../../../database-build/bin/Build.rb default.rb ./settings.rb --version '#'
```

Explanation: 
* **../../../database-build/**: is the location to the `database-build` repository.
* **default.rb**: the call of the default- buildscript.
* **./settings.rb**: the product settings- file used.

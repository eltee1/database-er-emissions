# er-emissions-addon

From here, the addon builds can be performed on a mxx-er-emissions base-database. All addons are added in seperate schemas in the base-database.


## File structure

* [`er-emissions-addon/build`](build/): this folder contains the general [`config`](build/config/) and ruby- build- [`scripts`](build/scripts/) for running the addon-builds.
* [`er-emissions-addon/database`](database/): is from where the database structure (sql- files) per addon is built; via an 'import-common', the corresponding database-structure in "database/[addon]" or build/export section is called. For each new addon, this section must be added.

Addons have to be added to all of the above locations, the current addons are:
- freeway-aggregation


## Commands

With `database-build` project checked out relative to this project, Ruby correctly installed and the `database-build` `*.User.rb` -settings files created, it should be possible to build this database.
This can be done with the following commands (might have to change `/` to `\` if working on Windows).

`--database-name` has to be the database-name on top of which the addon must be built.

Build database:
From the folder `/database-er-emissions/source/er-emissions-addon/database/[addon map]`:

* full addon: import of files and necessary actions followed by compiling of the result-tables.
```sh
ruby ../../../../../database-build/bin/Build.rb default.rb ./settings.rb --database-name '[database name]'
```

* compiling of the result-tables only (necessary imports- and actions have to be performed previously):
```sh
ruby ../../../../../database-build/bin/Build.rb default.rb ./settings.rb --database-name '-[database name]' --flags [flag]
```

Explanation: 
* **../../../../../database-build/**: is the location to the `database-build` repository.
* **default.rb**: the call of the default- buildscript.
* **./settings.rb**: the product settings- file used.
* --database-name: the database on top of which the addons are built.
* --flags: 
	- build_freeway_only

# er-emissions-addon

Vanuit hier kan en addon build worden uitgevoerd bovenop een bestaande mxx-er-emissions basis-database. Alle addons worden toegevoegd in aparte schemas in de basis-database.


## File structure

* [`er-emissions-addon/build`](build/): deze folder bevat de algemene [`config`](build/config/) en ruby- build- [`scripts`](build/scripts/) voor het uitvoeren van de addon-builds.
* [`er-emissions-addon/database`](database/): is de locatie vanuit waar de database structuur (sql- files) per addon wordt gebouwd; via een  'import-common', wordt de corresponderende database-structuur in "database/[addon]" of build/export sectie aangeroepen. Voor elke nieuwe addon moet deze sectie worden toegevoegd.

Nieuwe addons moeten worden toegevoegd aan alle bovenstaande locaties, de huidige addons zijn: 
- freeway-aggregation
- shipping-aggregation


## Commands

Met het `database-build` project uitgechecked relative naar dit project, Ruby correct geinstalleerd en de `database-build` `*.User.rb` -settings files aangemaakt, kan deze database gebouwd worden.
Dit kan worden gedaan met de onderstaande commando's (aanpassen van `/` naar `\` kan nodig zijn als wordt gewerkt in Windows).

`--database-name` is de database-naam waar de addon(s) aan wordt toegevoegd.

Bouw de addon:
Vanuit de folder `/database-er-emissions/source/er-emissions-addon/database/[addon map]`:

* volledige addon: database structuur, import van de benodigde files gevolgd door het samenstellen van de result-tabellen.
```sh
ruby ../../../../../database-build/bin/Build.rb default.rb ./settings.rb --database-name '[database name]'
```

* samenstellen van de resultaat-tabellen alleen (het benodigde aanmaken van de structuur en import van de data is al eerder uitgevoerd):
```sh
ruby ../../../../../database-build/bin/Build.rb default.rb ./settings.rb --database-name '-[database name]' --flags [flag]
```

Uitleg: 
* **../../../database-build/**: de locatie van de `database-build` repository.
* **default.rb**: de aanroep van het default- buildscript.
* **./settings.rb**: de gebruikte product settings- file.
* --database-name: de naam van de database waaraan de addon wordt toegevoegd.
* --flags: 
	- build_freeway_only

# er-emissions-addon

Vanuit hier kan een addon build worden uitgevoerd bovenop een bestaande mxx-er-emissions basis-database. Alle addons worden toegevoegd in aparte schemas in de basis-database.


## File structuur

* [`er-emissions-addon/build`](build/): deze folder bevat de algemene [`config`](build/config/) en ruby- build- [`scripts`](build/scripts/) voor het uitvoeren van de addon-builds.
* [`er-emissions-addon/database`](database/): is de locatie vanuit waar de database structuur (sql- files) per addon wordt gebouwd; via een  'import-common', wordt de corresponderende database-structuur in "database/[addon]" of build/export sectie aangeroepen. Voor elke nieuwe addon moet deze sectie worden toegevoegd.

Nieuwe addons moeten worden toegevoegd aan alle bovenstaande locaties. De huidige addons zijn, met specifieke uitleg: 
- freeway-aggregation:
	aggregatie van emissiebronnen op afstand van natuurgebieden voor de sectorgroep Wegverkeer-Snelwegen.
	Voor deze addon moeten specifieke brn- en agg_grid_n2k_clusters files worden samengesteld in de bron-database op het aerius-cluster. Deze worden door het build-script gebruikt als bronbestanden voor de aggregatie. Vooral de brn-file is een grote file en de import hiervan kan heel lang duren, vandaar dat de import van deze twee files en uitvoer van de aggregatie zijn losgetrokken van elkaar; hierdoor is alleen de aggregatie (dus niet de import) los uit te voeren als de import van de benodigde files al is uitgevoerd. Dit kan met de buildflag "build_freeway_only".
	Hoe de brn-file moet worden samengesteld, wordt hier beschreven: [`database/freeway-aggregation/src/data/sql/preparation.sql`](database/freeway-aggregation/src/data/sql/preparation.sql)

- shipping-aggregation
	aggregatie van emissiebronnen op afstand van natuurgebieden voor de sectorgroep scheepvaart.
	Voor deze addon moeten specifieke brn- en agg_grid_n2k_clusters files worden samengesteld in de bron-database op het aerius-cluster. Deze worden door het build-script gebruikt als bronbestanden voor de aggregatie. Vooral de brn-file is een grote file en de import hiervan kan heel lang duren, vandaar dat de acties import van deze file en uitvoer van de aggregatie zijn losgetrokken van elkaar; hierdoor is alleen de aggregatie (dus niet de import) los uit te voeren als de import van de benodigde files al is uitgevoerd. Dit kan met de buildflag "build_shipping_only".
	Hoe de brn-file moet worden samengesteld, wordt hier beschreven: [`database/shipping-aggregation/src/data/sql/preparation.sql`](database/shipping-aggregation/src/data/sql/preparation.sql)


## Commando's

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
* --flags (depening on the addon): 
	- build_freeway_only (addon freeway-aggregation)
	- build_shipping_only (addon shipping-aggregation)

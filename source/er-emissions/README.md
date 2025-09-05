# er-emissions

Dit is de mxx-er-emissions database, gebaseerd op de data van de Emissie Registratie (ER).

## File structure

* `src/build`: Deze folder bevat de algemene [`config`](src/build/config/) en ruby- build- [`scripts`](src/build/scripts/) voor het bouwen van databases.
* `src/main`: is vanuit waar de database structure (sql- files) wordt neergezet. 
* `src/data`: bevat de load_table / build statements. 

## Commands

Met het `database-build` project uitgechecked relative naar dit project, Ruby correct geinstalleerd en de `database-build` `*.User.rb` -settings files aangemaakt, zou het moegelijk moeten zijn deze database te bouwen.
Dit kan worden gedaan met de volgende commando's (aanpassen van `/` naar `\` kan nodig zijn als wordt gewerkt in Windows).


Bouw de database:
Vanuit de folder `/database-er-emissions/source/er-emissions/`:

De standaard database name is "mxx-er-emissions" (mxx = m-version, bijvoorbeeld m26), dit wordt aangevuld met de git-hash '-#', samengvoegd als voorbeeld: 
```sh
ruby ../../../database-build/bin/Build.rb default.rb ./settings.rb --database-name 'm26-er-emissions-#'
```

Uitleg: 
* **../../../database-build/**: de locatie van de `database-build` repository.
* **default.rb**: de aanroep van het default- buildscript.
* **./settings.rb**: de gebruikte product settings- file.

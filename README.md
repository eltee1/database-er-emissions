# database-er-emissions

Deze repositiory bevat:
* [`er-emissions`](source/er-emissions/): de database waarin de stikstof-emissiedata van de Emissie Registratie wordt verzameld. In de loop van tijd wordt deze database verder gevuld met nieuwe data zodra deze aangeleverd wordt; het is dus niet zo dat gelijk vanuit hier en volledig gevulde database kan worden gebouwd.
Het doel van de initiele database build is dat de structuur voor deze aan te leveren data, al aanwezig is in de database.
* [`er-emissions-addon`](source/er-emissions-addon/): vanuit hier kunnen addons gebouwd worden bovenop een mxx-er-emissions database. Alle addons worden toegevoegd in aparte schema's in de basis-database.

Huidige addons: 
* freeway-aggregation: aggregatie van emissiebronnen op afstand van natuurgebieden voor de sectorgroep Wegverkeer-Snelwegen.

* shipping-aggregation: aggregatie van emissiebronnen op afstand van natuurgebieden voor de sectorgroep scheepvaart.

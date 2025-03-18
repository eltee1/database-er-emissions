# database-er-emissions

This repositiory contains:
* [`er-emissions`](source/er-emissions/): the database in which the N-emission data from "Emissie Registratie" is collected. This data is also processed in this database, so this database is gradular filled in time. The aim is that all the structure to do this, is generated during the database-build.
* [`er-emissions-addon`](source/er-emissions-addon/): from here, addons can be buildt on top of a er--emissions database. All addons are added in seperate schemas in the base-database.

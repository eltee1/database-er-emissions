/* De volgende regel staat expliciet uit, zodat de build faalt als het schema al bestaat; zo is degene die de build start, zich ervan bewust dat hij/zij op het punt staat een lange build opnieuw te starten. 
Het schema 'shipping' moet dus eerst bewust handmatig verwijderd worden.*/
-- DROP SCHEMA IF EXISTS shipping; 

/*
 * shipping
 * --------
 * The shipping schema contains tables, functions and views for the determination of the shipping aggregation.
 */
CREATE SCHEMA shipping;
 
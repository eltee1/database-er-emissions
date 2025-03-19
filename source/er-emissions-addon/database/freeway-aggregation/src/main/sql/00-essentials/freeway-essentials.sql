/*de volgende regel staat expliciet uit, zodat de build faalt als het schema al bestaat; zo is degene die de build start, zich ervan bewust dat hij/zij op het punt staat een lange build opnieuw te starten. 
Het schema 'freeway' moet dus eerst bewust handmatig verwijderd worden.*/
--DROP SCHEMA IF EXISTS freeway; 

/*
 * freeway
 * -------
 * The freeway schema contains tables, functions and views for the determination of the freeway aggregation.
 */
CREATE SCHEMA freeway;

COMMENT ON SCHEMA freeway IS 'The freeway schema contains tables, functions and views for the determination of the freeway aggregation.';
 
// vim: noai:ts=4:sw=4

/* ./external-auth [uri [database [collection [ro|rw]]]] */

// author: david . bennett at percona . com

// based on Mongo C Driver - examples/example-client.c

#include <mongoc.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int
main (int   argc,
      char *argv[])
{
   mongoc_client_t *client;
   mongoc_collection_t *collection;
   mongoc_cursor_t *cursor;
   bson_error_t error;
   const bson_t *doc;
   const char *uristr = "mongodb://exttestro:exttestro9a5S@localhost/?authMechanism=PLAIN&authSource=$external";
   const char *database_name = "test";
   const char *collection_name = "query1";
   const char *user_role = "ro";

   if (argc == 2 && !strcmp("--help",argv[1])) {
     printf ("Usage: [uri [database [collection [ro|rw]]]]\n");
     return EXIT_FAILURE;
   }

   if (argc > 1) {
      uristr = argv [1];
   }

   if (argc > 2) {
      database_name = argv [2];
   }

   if (argc > 3) {
      collection_name = argv [3];
   }

   if (argc > 4) {
      user_role = argv [4];
   }

   mongoc_init ();

   client = mongoc_client_new (uristr);
   collection = mongoc_client_get_collection (client, database_name, collection_name);

   if (!client) {
      fprintf (stderr, "Failed to parse URI.\n");
      return EXIT_FAILURE;
   }

   // write

   if (!strcasecmp(user_role,"rw")) {

      bson_t *rwbson;
      bson_error_t rwerror;

      rwbson = bson_new();
      time_t now = time(NULL);
      bson_append_utf8(rwbson,"db",-1,database_name,-1);
      bson_append_time_t(rwbson,"date",-1,now);
      mongoc_client_get_database(client, database_name);
      bool ret = mongoc_collection_insert(collection, MONGOC_INSERT_NONE, rwbson, NULL,
                                                                     &rwerror);

      bson_destroy(rwbson);

      if (!ret)
          return EXIT_FAILURE;

   }

   // read
   bson_t roquery;
   bson_init (&roquery);
   char *str;

#if 0
   eson_append_utf8 (&roquery, "hello", -1, "world", -1);
#endif

   cursor = mongoc_collection_find (collection,
                                    MONGOC_QUERY_NONE,
                                    0,
                                    0,
                                    0,
                                    &roquery,
                                    NULL,  /* Fields, NULL for all. */
                                    NULL); /* Read Prefs, NULL for default */
   while (mongoc_cursor_next (cursor, &doc)) {
      str = bson_as_json (doc, NULL);
      fprintf (stdout, "%s\n", str);
      bson_free (str);
   }

   if (mongoc_cursor_error (cursor, &error)) {
      fprintf (stderr, "Cursor Failure: %s\n", error.message);
      return EXIT_FAILURE;
   }

   bson_destroy (&roquery);

  // close server connection

   mongoc_cursor_destroy (cursor);
   mongoc_collection_destroy (collection);
   mongoc_client_destroy (client);

   mongoc_cleanup ();

   return EXIT_SUCCESS;
}

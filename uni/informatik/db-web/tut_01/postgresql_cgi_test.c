// Had to compile like this: gcc -o postgresql_cgi_test postgresql_cgi_test.c -lpq

// postgresql_cgi_test.c
// PostgreSQLCGI
// Sample script to establish a connection to postgresql and display a table

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libpq-fe.h> // Header fuer libpq

// @TODO This section has to be edited to reach your specific database.
const char host[] = "localhost";
const char port[] = "5432"; // should be 5432
const char databaseName[] = "db-web-test";
const char userName[] = "eoshiru";
const char password[] = " ";
const char tableName[] = "posts";

int main(int argc, const char *argv[])
{
  PGconn *my_db = NULL;
  int i, j;

  printf("Content-Type: text/html\r\n\r\n");
  printf("<html>\r\n");
  printf("<head></head>\r\n");
  printf("<body>\r\n");

  printf("<h1>PostgreSQL-Verbindungstest</h1>\r\n");
  printf("Die Verbindung wird zu folgender Datenbank aufgebaut:<br/>\r\n");
  printf("<ul>\r\n");
  printf("<li>Host: %s</li>\r\n", host);
  printf("<li>Port: %s</li>\r\n", port);
  printf("<li>Datenbank: %s</li>\r\n", databaseName);
  printf("<li>Benutzername: %s</li>\r\n", userName);
  printf("<li>Relation: %s</li>\r\n", tableName);
  printf("</ul>\r\n");

  printf("<h2>1. Aufbau der Verbindung</h2>\r\n");
  my_db = PQsetdbLogin(host, port, NULL, NULL, databaseName, userName, password);

  if(PQstatus(my_db) != CONNECTION_OK)
  {
    printf("<h1>Die Verbindung konnte nicht aufgebaut werden</h1>\r\n");
    printf("<p>%s</p>\n", PQerrorMessage(my_db));
    exit(EXIT_FAILURE);
  }

  printf("<h2>2. Ausfuehren der Anfrage</h2>\r\n");
  const char select[] = "SELECT * FROM ";
  char *query = (char *)malloc(1 + strlen(select) + strlen(tableName));
  strcpy(query, select);
  strcat(query, tableName);
  PGresult *result = PQexec(my_db, query);
  free(query);

  int numfields = PQnfields(result);
  int numrows = PQntuples(result);

  printf("<h2>3. Ergebnis holen</h2>\r\n");
  printf("<table>\r\n");
  printf("<thead><tr>");
  for(i = 0; i < numfields; i++)
    printf("<th>%-15s</th>", PQfname(result, i));
  printf("</tr></thead>\r\n");

  for(i = 0; i < numrows; i++)
  {
    printf("<tr>");
    for(j = 0; j < numfields; j++)
      printf("<td>%-15s</td>", PQgetvalue(result, i, j));
    printf("</tr>\r\n");
  }
  printf("</table>\r\n");

  printf("<h2>4. Beenden der Verbindung</h2>\r\n");
  PQclear(result);
  PQfinish(my_db);

  printf("</body>\r\n");
  printf("</html>");

  exit(EXIT_SUCCESS);
}

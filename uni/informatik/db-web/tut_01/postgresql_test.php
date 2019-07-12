<?php
// Sample script to establish a connection to postgresql and display a table

// @TODO This section has to be edited to reach your database.
$host = "localhost";
$port = "5432"; // should be 5432
$databaseName = "db-web-test";
$userName = "eoshiru";
$password = "";
$tableName = "posts";

echo "<html>\r\n";
echo "</head></head>\r\n";
echo "</body>\r\n";

echo "<h1>PostgreSQL-Verbindungstest</h1>\r\n";
echo "Die Verbindung wird zu folgender Datenbank aufgebaut:<br/>\r\n";
echo "<ul>\r\n";
echo "<li>Host: " . $host . "</li>\r\n";
echo "<li>Port: " . $port . "</li>\r\n";
echo "<li>Datenbank: " . $databaseName . "</li>\r\n";
echo "<li>Benutzername: " . $userName . "</li>\r\n";
echo "<li>Relation: " . $tableName . "</li>\r\n";
echo "</ul>\r\n";

echo "<h2>1. Aufbau der Verbindung</h2>\r\n";
$db_handle = pg_connect("host=" . $host . " port=" . $port . " dbname=" . $databaseName . " user=" . $userName . " password=" . $password) or die("Die Verbindung konnte nicht aufgebaut werden.");

if(pg_connection_status($db_handle) === PGSQL_CONNECTION_OK)
{
  echo "Die Verbindung zur Datenbank wurde aufgebaut.<br/>\r\n";
  echo "Inhalt des Datenbank-Handles:<br />\r\n";
  echo $db_handle;
}

echo "<h2>2. Ausfuehren der Anfrage</h2>\r\n";
$result = pg_query($db_handle, "SELECT * FROM " . $tableName);

$result_status = pg_result_status($result);
if($result_status === PGSQL_COMMAND_OK || $result_status === PGSQL_TUPLES_OK)
{
  $numfields = pg_num_fields($result);
  $numrows = pg_num_rows($result);
  echo "Die Anfrage wurde erfolgreich ausgefuehrt.<br/>\r\n";
  echo "Anzahl der Elemente: " . $numfields . "<br/>\r\n";
  echo "Anzahl der Tupel: " . $numrows . "<br/>\r\n";
}
else
{
  $numrows = 0;
  $numfields = 0;
  echo "Fehler beim Ausfuehren der Anfrage.<br/>";
  echo "Fehlermeldung: " . pg_last_error($db_handle) . "<br/>\r\n";
}

echo "<h2>3. Ergebnis holen</h2>\r\n";
echo "<table>\r\n";
echo "<thead><tr>";
for($fi = 0; $fi < $numfields; $fi++)
  echo "<th>" . pg_field_name($result, $fi) . "</th>";
echo "</tr></thead>\r\n";

for($ri = 0; $ri < $numrows; $ri++)
{
  echo "<tr>";
  foreach(pg_fetch_row($result, $ri) as $value)
    echo "<td>" . $value . "</td>";
  echo "</tr>\r\n";
}
echo "</table>\r\n";

echo "<h2>4. Beenden der Verbindung</h2>\r\n";
if(pg_close($db_handle))
  echo "Die Verbindung wurde erfolgreich beendet.<br/>";
else
  echo "Fehler beim Beenden der Verbindung.<br/>";
echo "</body>\r\n";
echo "</html>";
?>

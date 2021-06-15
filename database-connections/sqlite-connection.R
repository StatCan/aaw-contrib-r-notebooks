### This is an example of how to connect to a database.

### You'll want to create a new database, instead of using this
### database of latin expressions, but you
### can copy-paste this example with a new database.
library(DBI)

if (file.exists("/home/jovyan/R-notebooks/database-connections/latin_phrases.db")) {
  
  con <- dbConnect(RSQLite::SQLite(), "/home/jovyan/R-notebooks/database-connections/latin_phrases.db")
  dbGetQuery(con, "SELECT * FROM latin_phrases LIMIT 5")
  
} else {
  warning("I can't find the database file.")
  warning("Are you running this from the correct directory?") 
}

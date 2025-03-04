// Table names to watch for and their schemas
.dive.schemas.revenues:([]sym:`symbol$();revenue:`float$());
.dive.schemas.employeecounts:([]sym:`symbol$();employeecount:`int$());

// Dictionary mapping table names to column type characters (for casting csv columns)
.dive.datatypes:{"*"^ upper .Q.ty each value flip x} each `_ .dive.schemas;

// Function to use in filealerter.csv
// Reads the file, splays it to HDB directory, reloads HDBs, triggers DIVE
dive:{[path;file]
  // Drop .csv suffix
  tabname:`$ -4_ file;
  if[not tabname in key .dive.schemas;.lg.o[`dive;"ignoring unknown table name ", string tabname];:0b];
	.lg.o[`dive;"reading data for table ", string tabname];
  tab:.dive.schemas[tabname] upsert (.dive.datatypes[tabname];enlist csv) 0: hsym `$ path, file;
  .lg.o[`dive;"writing data for table ", string tabname];
  hdb:hsym `$ getenv `KDBHDB;
  (` sv hdb, tabname, `) set .Q.en[hdb] tab;
  // Need to reload HDB(s) for DIVE to see this new data
  // Reload all HDBs so DIVE can use any of them
  h:exec w from .servers.getservers[`proctype;`hdb;()!();1b;0b];
  if[0=count h;.lg.w[`dive;"no HDBs available"];:0b];
  .lg.o[`dive;"reloading HDBs"];
  // Sync because trigger should wait until reload is complete
  h @\: (`reload;`);
  // Trigger DIVE
  triggername:`$ "_" sv string `filedrop, tabname;
  /.dive.trigger[`dive;triggername;()!()];      // trigger DIVE directly
  .dive.triggerevent[`dive;triggername;()!()];  // trigger DIVE via dive_event_triggers table
  }

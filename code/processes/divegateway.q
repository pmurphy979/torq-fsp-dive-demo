// API for the divegateway process; the access point for DIVE to query a HDB
// Modified version of dive-demo/kdbdq/data_layer/gw.q
// Instead of hardcoding a HDB connection, it uses the discovery service to find available HDBs
// Note: Connected HDB processes must load divehdb.q

// Alternatively set .servers.CONNECTIONS:`hdb and .servers.STARTUP:1b in a settings/divegateway.q file
/.servers.CONNECTIONS:`hdb
/.servers.startup[]

logquery:{`queries upsert `handle`guid`qtime`callback`usercallback!(.z.w;id:rand 0Ng;.z.P;x;y);id}

queries:([]handle:"i"$(); guid:"g"$(); qtime:"p"$();rtime:"p"$();callback:`$();usercallback:`$());

/TODO add query validation (zero priority)
hget:{[d;c]
  dc::(d;c);
  d:$[(99h<>type d)&c in `getcounts`getmeta`gettables;d:()!();d];
  cb:$[`id in key d;d`id;`];
  id:logquery[c;cb];
  // Return empty result if no HDB is available
  h:first .servers.gethandlebytype[`hdb;`any];
  $[null h;return[();id];neg[h](c;d,enlist[`id]!enlist id)];
  id}

return:{[r;id]
  -1@"returning ",string id;
  rd:exec handle,callback,usercallback from queries where guid=id;
  res:`callback`result`id!(rd`callback;r;rd`usercallback);
  neg[rd[`handle]0](res);
  /delete from `queries where guid=id;
  }

getdata:hget[;`getdata]
gettables:hget[;`gettables]
getcounts:hget[;`getcounts]
getmeta:hget[;`getmeta]

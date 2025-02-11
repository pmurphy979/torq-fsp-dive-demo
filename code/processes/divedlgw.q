// DIVE data layer gateway
// Access point for DIVE to query a data layer HDB
// Modified version of dive-demo/kdbdq/data_layer/gw.q
// Note: Connected HDB processes must load divedlhdb.q

// Instead of hardcoding a HDB connection, use the TorQ discovery service to find available HDBs
// Alternatively set .servers.CONNECTIONS:`hdb and .servers.STARTUP:1b in a settings/divedlgw.q file
/.servers.CONNECTIONS:`hdb
/.servers.startup[]

// Implementation note: could simply hardcode and open HDB port here, e.g.
// .dive.hdbhandle:hopen 9999

.dive.logquery:{`.dive.queries upsert `handle`guid`qtime`callback`usercallback!(.z.w;id:rand 0Ng;.z.P;x;y);id}

.dive.queries:([]handle:"i"$(); guid:"g"$(); qtime:"p"$();rtime:"p"$();callback:`$();usercallback:`$());

.dive.hget:{[d;c]
  d:$[(99h<>type d)&c in `.dive.getcounts`.dive.getmeta`.dive.gettables;d:()!();d];
  cb:$[`id in key d;d`id;`];
  id:.dive.logquery[c;cb];
  .lg.o[`dive;string[c],": submitting query ID ",string[id]," for rulename \"",d[`rulename],"\""];
  // Get HDB handle
  // Implementation note: use a hardcoded handle or your implementation's preferred "get handle" function here if one exists
  h:first .servers.gethandlebytype[`hdb;`any];
  // Return empty result if no HDB is available
  if[null h;
    .lg.e[`dive;string[c],": error submitting query ID ",string[id],": hdb unavailable"];
    return[();id];
    :id;
    ];
  neg[h](c;d,enlist[`id]!enlist id);
  id
  }

.dive.return:{[r;id]
  rd:exec handle,callback,usercallback from .dive.queries where guid=id;
  .lg.o[`dive;string[rd[`callback]0],": returning result for query ID ",string id];
  res:`callback`result`id!(rd`callback;r;rd`usercallback);
  neg[rd[`handle]0](res);
  }

.dive.getdata:.dive.hget[;`.dive.getdata]
.dive.gettables:.dive.hget[;`.dive.gettables]
.dive.getcounts:.dive.hget[;`.dive.getcounts]
.dive.getmeta:.dive.hget[;`.dive.getmeta]

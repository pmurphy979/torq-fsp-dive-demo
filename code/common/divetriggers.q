// DIVE trigger functions
// Used by processes to tell DIVE to run rules listening for certain trigger names
// Typically needed after a data layer HDB update, e.g. EOD or a file drop
// Args:
//   funcname: name of calling function as a symbol; used for logging only
//   triggername: trigger name as a symbol; one or more DIVE rules should be listening for it

// Use this trigger if you don't want an events table or want to bypass it (see below)
// This trigger an be run by any process connected to the divetrigger process
.dive.trigger:{[funcname;triggername]
  h:first .servers.gethandlebytype[`divetrigger;`any];
  if[null h;
    .lg.w[`dive;"failed to call trigger ", string[triggername], " from function ", string[funcname], ": divetrigger process unavailable"];
    :0b;
    ];
  .lg.o[`dive;"calling trigger ", string[triggername], " from function ", string funcname];
  neg[h](`.dive.triggerrules;.proc.procname;funcname;triggername);
  1b
  }

// Same as above, but also populates a table of trigger events:
// divetrigger process subscribes to dive_trigger_events, upd function calls .dive.triggerrules
// This trigger can be run by any process connected to the segmentedtickerplant process
.dive.triggerevent:{[funcname;triggername]
  h:first .servers.gethandlebytype[`segmentedtickerplant;`any];
  if[null h;
    .lg.w[`dive;"failed to log trigger event ", string[triggername], " from function ", string[funcname], ": tickerplant unavailable"];
    :0b;
    ];
  .lg.o[`dive;"logging trigger event ", string[triggername], " from function ", string funcname];
  neg[h](`.u.upd;`dive_trigger_events;(triggername;.proc.procname;funcname));
  1b
  }

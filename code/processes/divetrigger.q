// DIVE trigger process
// Relays triggers from processes and/or dive_trigger_events table to external DIVE gateway process

// Subscribe to dive_trigger_events from tickerplant
.dive.subscribe:{[]
  s:.sub.getsubscriptionhandles[`segmentedtickerplant;();()!()];
  if[0=count s;
    .lg.w[`dive;"tickerplant unavailable"];
    :0b;
    ];
  .lg.o[`dive;"subscribing to dive_trigger_events"];
  .sub.subscribe[`dive_trigger_events;`;0b;0b;first s];
  1b
  }

// Tell DIVE to run rules based on a trigger name
.dive.triggerrules:{[procname;funcname;triggername;overrides]
  h:first .servers.gethandlebytype[`divegateway;`any];
  if[null h;
    .lg.w[`dive;"failed to call trigger ", string[triggername], " from function ", string[funcname], " in process ", string[procname], ": divegateway process unavailable"];
    :0b;
    ];
  .lg.o[`dive;"calling trigger ", string[triggername], " from function ", string[funcname], " in process ", string procname];
  neg[h](`.api.triggerrules;triggername;overrides);
  1b
  }

// Trigger from events table
upd:{[x;y]
  if[x=`dive_trigger_events;
    (.dive.triggerrules') . (update -9!/: overrides from y)[`procname`funcname`sym`overrides]
    ]
  }

.servers.startup[];
.dive.subscribe[];

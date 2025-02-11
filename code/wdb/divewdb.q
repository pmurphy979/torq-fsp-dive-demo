// Overwrite postreplay hook to run DIVE after EOD
// e.g. to run a DIVE rule immediately on the new date partition, it should listen for this trigger and have targetdate=-1
.save.postreplay:{[d;p]
  .dive.trigger[`.save.postreplay;`wdbpostreplay];        // trigger DIVE directly
  /.dive.triggerevent[`.save.postreplay;`wdbpostreplay];  // trigger DIVE via dive_event_triggers table
  }

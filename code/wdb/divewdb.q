// Overwrite postreplay hook to run DIVE after EOD
// To run a DIVE rule immediately on the new date partition, it should listen for this trigger
// targetdate parameter is overridden so rules always look at date just written
.save.postreplay:{[d;p]
  .dive.trigger[`.save.postreplay;`wdbpostreplay;enlist[`targetdate]!enlist[-1]];        // trigger DIVE directly
  /.dive.triggerevent[`.save.postreplay;`wdbpostreplay;enlist[`targetdate]!enlist[-1]];  // trigger DIVE via dive_event_triggers table
  }

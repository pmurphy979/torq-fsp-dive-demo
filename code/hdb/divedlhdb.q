// DIVE data layer HDB functions
// Modified version of dive-demo/kdbdq/data_layer/hdb.q
// These functions must be loaded by a HDB process to make it queryable by a divedlgw (DIVE data layer gateway) process
// E.g. add to code/hdb/ directory to be loaded by all HDB processes

.dive.getdata:{[d]
  v:@[(1b;).dive.getdatae@;d;(0b;)];
  r:$[v 0;v 1;enlist[`error]!enlist v 1];
  neg[.z.w](`.dive.return;r;d`id)
  }

.dive.getdatae:{[d]
  agg:$[all null d`aggBy;0b;{first'[` vs/:x]!value last parse "select ",raze[string x]," from t"} (),d`aggBy];
  precol:$[10h=type d`cols;last parse "select ",d[`cols]," from t";d`cols];
  d[`filter]:$[10h=type d`filter;$[count d`filter;first parse["select from t where ",d`filter]2;()];d`filter];
  colnames:(),$[99h=type precol;key precol;d`cols];
  col:$[null d`aggFuncs;::;enlist'[d`aggFuncs;]] precol;
  filter:$[null d`date;();enlist(=;`date;d`date)],$[0=count d`filter;();d`filter];
  filter:filter where 1<count'[filter];
  .lg.o[`dive;"getdata: rulename \"",d[`rulename],"\": select ",.Q.s1[col]," by ",.Q.s1[agg]," from ",string[d`table]," where ",.Q.s1[filter]];
  r:?[d`table;filter;agg;col];
  r
  }

.dive.gettables:{[d]
  neg[.z.w](`.dive.return;tables[];d`id);
  }

.dive.getcounts:{[d]
  r:flip (enlist[`date]!enlist[date]),tables[]!{.Q.cn value x}each tables[];
  neg[.z.w](`.dive.return;r;d`id)
  }

.dive.getmeta:{[d]
  r:update sourceTable:d`table from 0!meta d`table;
  neg[.z.w](`.dive.return;r;d`id);
  }

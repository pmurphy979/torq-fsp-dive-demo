// Modified version of dive-demo/kdbdq/data_layer/hdb.q
// These functions must be loaded by a HDB process to make it queryable by a divegateway process
// E.g. add to code/hdb/ directory to be loaded by all HDB processes

.error.m:{@[(1b;)x .;y;(0b;)]};
.error.s:{@[(1b;)x@;y;(0b;)]};

getdata:{[d]
  v:.error.s[getdatae;d];
  r:$[v 0;v 1;enlist[`error]!enlist v 1];
  neg[.z.w](`return;r;d`id)
  }

getdatae:{[d]
  /query dict
  /table 
  /aggBy
  /aggFuncs - can be either atom or same length as cols
  /cols
  /filter
  -1@"getting data for:";
  -1@.Q.s d;
  D::d;
  agg:$[all null d`aggBy;0b;{first'[` vs/:x]!value last parse "select ",raze[string x]," from t"} (),d`aggBy];
  precol:$[10h=type d`cols;last parse "select ",d[`cols]," from t";d`cols];
  d[`filter]:$[10h=type d`filter;first parse["select from t where ",d`filter]2;d`filter];
  colnames:(),$[99h=type precol;key precol;d`cols];
  /aggfuncs:
  col:$[null d`aggFuncs;::;enlist'[d`aggFuncs;]] precol;
  filter:enlist[(=;`date;d`date)],$[0=count d`filter;();d`filter];
  filter:filter where 1<count'[filter];
  r:?[d`table;filter;agg;col];
  r
  }

gettables:{[d]
  neg[.z.w](`return;tables[];d`id);
  }

getcounts:{[d]
  r:flip (enlist[`date]!enlist[date]),tables[]!{.Q.cn value x}each tables[];
  neg[.z.w](`return;r;d`id)
  }

getmeta:{[d]
  r:update sourceTable:d`table from 0!meta d`table;
  neg[.z.w](`return;r;d`id);
  }

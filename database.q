quote:([]time:`timestamp$(); sym:`g#`symbol$(); bid:`float$(); ask:`float$(); bsize:`long$(); asize:`long$(); mode:`char$(); ex:`char$(); src:`symbol$())
trade:([]time:`timestamp$(); sym:`g#`symbol$(); price:`float$(); size:`int$(); stop:`boolean$(); cond:`char$(); ex:`char$();side:`symbol$())
quote_iex:([]time:`timestamp$(); sym:`g#`symbol$(); bid:`float$(); ask:`float$(); bsize:`long$(); asize:`long$(); mode:`char$(); ex:`char$(); srctime:`timestamp$())
trade_iex:([]time:`timestamp$(); sym:`g#`symbol$(); price:`float$(); size:`int$(); stop:`boolean$(); cond:`char$(); ex:`char$(); srctime:`timestamp$())
packets:([] time:`timestamp$(); sym:`symbol$(); src:`symbol$(); dest:`symbol$(); srcport:`long$(); destport:`long$(); seq:`long$(); ack:`long$(); win:`long$(); tsval:`long$(); tsecr:`long$(); flags:(); protocol:`symbol$(); length:`long$(); len:`long$(); data:())
dive_trigger_events:([]time:`timestamp$(); sym:`symbol$(); procname:`symbol$(); funcname:`symbol$(); overrides:())



Session.page_tree = {}
_.each(Meteor.stocks, (s)->Session.page_tree[s]="graph")

Meteor.startup ->
  Tracker.autorun ->
    Meteor.call("getQuandlDataSet","WIKI",Session.get("cur_page").pop())

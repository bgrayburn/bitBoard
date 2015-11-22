Meteor.startup ->
  Session.page_tree = {}
  _.each(stocks, (s)->Session.page_tree[s]="graph")

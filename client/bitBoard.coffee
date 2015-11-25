Session.page_tree = {}
_.each(Meteor.stocks, (s)->Session.page_tree[s]="graph")

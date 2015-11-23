Session.page_tree = {'bitBoard':{}}
_.each(Meteor.stocks, (s)->Session.page_tree['bitBoard'][s]="graph")

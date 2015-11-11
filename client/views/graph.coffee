Template.graph.onCreated ->
  this.id = Math.random().toString(36).substr(2, 5)

Template.graph.onRendered ->
  ReactDOM.render(
    React.createElement(Meteor.components.linechart,null),
    document.getElementById('graph-'+this.id.toString())
  )

Template.graph.helpers
  id: -> Template.instance().id

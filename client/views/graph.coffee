Template.graph.onCreated ->
  this.id = Math.random().toString(36).substr(2, 5)

Template.graph.onRendered ->
  console.log("rendering graph-"+this.id.toString())
  ReactDOM.render(
    React.createElement(Meteor.components.linechart,{width:500, height:500, collection:Data}),
    document.getElementById('graph-'+this.id.toString())
  )

Template.graph.helpers
  id: -> Template.instance().id

Template.graph.onCreated ->
  this.id = Math.random().toString(36).substr(2, 5)
  #if data not in mongo, get data
  Meteor.call("getQuandlDataSet","WIKI",this.data_name)

Template.graph.onRendered ->
  console.log("rendering graph-"+this.id.toString())

Template.graph.helpers
  id: -> Template.instance().id

  render: ->
    Meteor.call("getQuandlDataSet","WIKI",Session.get("cur_page").pop())
    panel = document.getElementById("panel")
    data_name = Session.get("cur_page").pop()
    if panel
      width = panel.offsetWidth
      ReactDOM.render(
        React.createElement(Meteor.components.linechart,{
          width:width, height:500, cursor: Data.find({name:"WIKI.#{data_name}.close"})
        }),
        document.getElementById('graph-'+Template.instance().id.toString())
      )

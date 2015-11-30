Template.graph.onCreated ->
  this.id = Math.random().toString(36).substr(2, 5)

Template.graph.onRendered ->
  console.log("rendering graph-"+this.id.toString())

Template.graph.helpers
  id: -> Template.instance().id

  render: ->
    reactD3 = Browserify["react-d3"];
    data_name = Session.get("cur_page").pop()
    if data_name != 'test' then Meteor.call("getQuandlDataSet","WIKI",Session.get("cur_page").pop())
    panel = document.getElementById("panel")
    if panel
      width = panel.offsetWidth
      if data_name!= 'test'
        name = "WIKI.#{data_name}.close"
      else
        name = 'test'

      graphEl = document.getElementById('graph-'+Template.instance().id.toString())

      #ReactDOM.render(
      #  React.createElement(Meteor.components.linechart,{
      #    width:width, height:500, name:name, cursor: Data.find({name:"WIKI.#{data_name}.close"})
      #  }), graphEl
      #)
      rawData = Data.findOne({name:name})
      formattedData = _.map _.keys(rawData.data), (k)->
        values = rawData.data[k]
        #values = _.map(values, (v)->
        #  dateObj = new Date(v[x])
        #  {x:dateObj, y:v[y]})

        {name: k, values: values}

      ReactDOM.render(
        React.createElement(reactD3.LineChart,
          {
            legend: true,
            data: formattedData
            width: width,
            height: 500
          }
        ),
        graphEl
      )

if (!(Meteor.components)){
  Meteor.components = {};
}

Meteor.components.linechart = React.createClass({
  mixins: [ReactMeteorData],

  getMeteorData() {
    return {
      data: _.omit(this.props.collection.findOne({}), "_id")
    }
  },

  updateChart: function(props) {
    var data = props.data;
    var margin = {top: 20, right: 80, bottom: 30, left: 50},
      width = props.width - margin.left - margin.right,
      height = props.height - margin.top - margin.bottom;

    var parseDate = d3.time.format("%Y").parse;
    
    var svg = d3.select("svg")

    var x = d3.time.scale().range([0, width]);
    var y = d3.scale.linear().range([height, 0]);
    var color = d3.scale.category10();
    var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
   
    var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")

    var line = d3.svg.line()
      .interpolate("basis")
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; });    
  
    svg.append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    color.domain(d3.keys(data)); 

  },

  componentDidMount: function(){
    var el = ReactDOM.findDOMNode(this);
    var svg = d3.select(el)
      .append("svg")
      .attr("width", this.props.width)
      .attr("height", this.props.height);

    this.updateChart(this.props);
  },

  componentWillUpdate: function(nextProps) {
    this.updateChart(nextProps)
  },

  render: function() {
    return (
      <div className="linechart">
        
      </div>
    )
  }

})

if (!(Meteor.components)){
  Meteor.components = {};
}

Meteor.components.linechart = React.createClass({
  mixins: [ReactMeteorData],

  getMeteorData: function() {
    return _.omit(this.props.collection.findOne({}), "_id")
  },

  updateChart: function(props) {
    console.log("updatingChart");
    Meteor.testProps = props;
    var data = this.getMeteorData();
    var margin = {top: 20, right: 80, bottom: 30, left: 50},
      width = props.width - margin.left - margin.right,
      height = props.height - margin.top - margin.bottom;

    var svg = d3.select("svg")

    var x = d3.scale.linear().range([0, width]);
    var y = d3.scale.linear().range([height, 0]);
    var color = d3.scale.category10().domain(d3.keys(data));

    var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")

    var yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")

    var line = d3.svg.line()
      .interpolate("basis")
      .x(function(d) { return x(d.x); })
      .y(function(d) { return y(d.y); });

    chart = svg.append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var series = color.domain().map(function(name) {
      return {
        name: name,
        values: data[name]
      }
    });

    Meteor.testSeries = series

    x.domain([
       d3.min(series, function(s) { return d3.min(s.values, function(v) { return v.x;}); }),
       d3.max(series, function(s) { return d3.max(s.values, function(v) { return v.x;}); })
    ]);
    
    y.domain([
       d3.min(series, function(s) { return d3.min(s.values, function(v) { return v.y;}); }),
       d3.max(series, function(s) { return d3.max(s.values, function(v) { return v.y;}); })
    ]);

    chart.append("g")
      .attr("class", "x_axis")
      .attr("transform", "translate( 0," + height + ")")
      .call(xAxis);

    chart.append("g")
      .attr("class", "y_axis")
      .call(yAxis)
          
    var singleSeries = chart.selectAll(".series")
      .data(series).enter().append("g").attr("class", "series");

    singleSeries.append("path")
      .attr("class", "line")
      .attr("d", function(d) { return line(d.values); })
      .style("stroke", function(d) { return color(d.name); })
  },

  componentDidMount: function(){
    var el = this.getDOMNode();
    this.updateChart(this.props);
  },

  componentWillUpdate: function(nextProps) {
    this.updateChart(nextProps)
  },

  render: function() {
    return (
      <div className="linechart">
        <svg height={this.props.height} width={this.props.width} />
      </div>
    )
  }

})

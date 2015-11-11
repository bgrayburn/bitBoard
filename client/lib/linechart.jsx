if (!(Meteor.components)){
  Meteor.components = {};
}

Meteor.components.linechart = React.createClass({
  mixins: [ReactMeteorData],

  getMeteorData() {
    return {
      data: Data.find({}).fetch()
    }
  },

  render: function() {
    return (
      <div className="linechart">
      </div>
    )
  }

})

Meteor.startup ->
  testData = {
    lineA: [
      { x: 1990, y: 1 }
      { x: 1991, y: 2 }
      { x: 1992, y: 3 }
      { x: 1993, y: 4 }
    ]
    lineB: [
      { x: 1990, y: 4 }
      { x: 1991, y: 3 }
      { x: 1992, y: 2 }
      { x: 1993, y: 1 }
    ]
  }
  Data.remove({})
  Data.insert(testData)

Meteor.methods
  getQuandlDataSet: (source, table, num_of_data_points = 30)->
    dateX = true
    name = "#{source}.#{table}"
    data_doc = {name:table, data:{}}
    series = Meteor.series[0]
    datasetExists = Data.find({name:name}).count()>0
    out = false
    if datasetExists
      Winston.info("found data already in mongo for #{source}/#{table}")
      out = true
    else
      Winston.info("getting Quandl dataset at #{source}/#{table}")
      url = "https://www.quandl.com/api/v3/datasets/#{source}/#{table}.json?auth_token=#{Meteor.settings.quandl_auth_token}"
      response = HTTP.get(url)
      Meteor.testResponse = response
      column_names = _.map(response.data.dataset.column_names, (n)->n.toLowerCase())
      Meteor.testDatas = []
      for series in Meteor.series
        series_ind = _.indexOf(column_names, series.toLowerCase())
        raw_data = _.map(
          response['data']['dataset']['data'],
          ((d) ->
            out = {}
            if dateX
              date = d[0] #date string
            else
              date = moment(d[0]).unix() #unix epoch
            out[date]=d[series_ind]
            return out
          )
        )
        if dateX
          data = _.map(raw_data, (d)->{x:_.keys(d)[0], y:_.values(d)[0]})
        else
          data = _.map(raw_data, (d)->{x:parseInt(_.keys(d)[0]), y:_.values(d)[0]})
        first_point = data.length-num_of_data_points
        last_point = data.length
        data = _.sortBy(data, (d)->d.x).slice(first_point, last_point)
        Meteor.testDatas.push(data)
        data_doc.data[series] = data
      Meteor.testDataDoc = data_doc
      Data.remove({name:name})
      Data.insert(data_doc)
      out = true
    out

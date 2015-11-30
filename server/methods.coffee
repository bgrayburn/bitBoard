Meteor.methods
  getQuandlDataSet: (source, table, num_of_data_points = 30)->
    series = ["close","open"]
    name_base = "#{source}.#{table}."
    name = name_base + series[0]
    datasetExists = Data.find({name:name}).count()>0
    out = false
    if datasetExists
      Winston.info("found data already in mongo for #{source}/#{table}")
      out = true
    else
      Winston.info("getting Quandl dataset at #{source}/#{table}")
      url = "https://www.quandl.com/api/v3/datasets/#{source}/#{table}.json?auth_token=#{Meteor.settings.quandl_auth_token}"
      response = HTTP.get(url)
      raw_data = _.map(
        response['data']['dataset']['data'],
        ((d) ->
          out = {}
          date = moment(d[0]).unix() #unix epoch
          #date = d[0] #date string
          out[date]=d[4]
          return out
        )
      )
      data = _.map(raw_data, (d)->{x:parseInt(_.keys(d)[0]), y:_.values(d)[0]})
      Meteor.testData = data
      data = _.sortBy(data, (d)->d.x).slice(0,num_of_data_points)
      data_doc = {name:name, data:{series[0]:data}}
      Data.remove({name:name})
      Data.insert(data_doc)
      out = true
    out

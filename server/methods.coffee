Meteor.methods
  getQuandlDataSet: (source, table)->
    Winston.info("getting Quandl dataset at #{source}/#{table}")
    url = "https://www.quandl.com/api/v3/datasets/#{source}/#{table}.json?auth_token=#{Meteor.settings.quandl_auth_token}"
    response = HTTP.get(url)
    Meteor.testResponse = response
    name = "#{source}.#{table}.close"
    data = _.map(response['data']['dataset']['data'], ((d) -> out = {}; out[d[0]]=d[4]; return out))
    Meteor.testData = data
    data_doc = {name:name, data:data}
    Data.remove({name:name})
    Data.insert(data_doc)

    response

// Initialize MongoDB replica cluster.
var client = new Mongo('mongo-db-1:7000');
var database = client.getDB('admin');
var status = null;
try {
  status = rs.status();
  print('MongoDB replica cluster already initialized.');
} catch(exception) {
  if(exception['codeName']=='NotYetInitialized') {
    print('Initializing MongoDB replica cluster...');
    rs.initiate({
      '_id':'main',
      'members':[
        {'_id':1,'host':'mongo-db-1:7000'},
        {'_id':2,'host':'mongo-db-2:7000'},
        {'_id':3,'host':'mongo-db-3:7000'}
      ]
    });
    print('MongoDB replica cluster initialized.');
  }
}

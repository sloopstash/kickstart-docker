# import community modules. 
import sys
from flask import Flask,request,render_template
from werkzeug.exceptions import NotFound
import argparse
import json
import redis

# initialize redis connector.
redis_engine = redis.Redis(connection_pool=redis.ConnectionPool(host='demo-redis',port=6379,max_connections=10,db=0))

# intialize flask app.
app = Flask('demo app',template_folder='templates')

# create ticket.
@app.route('/ticket/create',methods=['GET','POST'])
def ticket_create():
  vars = {}
  if request.method=='GET':
    return render_template('ticket/create.html')
  elif request.method=='POST':
    data = {}
    data['subject'] = request.form['subject']
    data['description'] = request.form['description']
    id = redis_engine.incr('tc')
    redis_engine.set('t:'+str(id),json.dumps(data))
    vars['id'] = id
    vars['data'] = json.loads(redis_engine.get('t:'+str(id)))
    return render_template('ticket/view.html',vars=vars)
  else:
    return render_template('error.html')

# view ticket.
@app.route('/ticket/<id>',methods=['GET'])
def ticket_view(id):
  vars = {}
  if request.method=='GET':
    if redis_engine.exists('t:'+str(id)) is True:
      vars['id'] = id
      vars['data'] = json.loads(redis_engine.get('t:'+str(id)))
      return render_template('ticket/view.html',vars=vars)
    else:
      raise NotFound()
  else:
    return render_template('error.html')


if __name__ == '__main__':
  try:
    parser = argparse.ArgumentParser(description='demo app')
    parser.add_argument('--port','-P',type=int,default=80)
    parser.add_argument('--host','-H',default='0.0.0.0')
    args = parser.parse_args()
    print 'starting demo app'
    app.run(debug=True,host=args.host,port=args.port)
  except KeyboardInterrupt:
    print 'stopping demo app'
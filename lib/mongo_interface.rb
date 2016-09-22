require 'mongo'

class MongoInterface

  def initialize(dbname, collectionname)
    @dbname = dbname
    @collectionname = collectionname
    @collection = connectMongo
  end

  def connectMongo
    client = Mongo::Client.new(['127.0.0.1'], :database => @dbname)
    db = client.database
    db[@collectionname]
  end

  def save posts
    @collection.insert_many posts
  end

end

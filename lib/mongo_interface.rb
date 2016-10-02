require 'mongo'

class MongoInterface

  MaxBSONSize = 16777216
    
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

  def get_all_docs_by field
    @collection.find.map{ |doc| doc[field]}
  end
end

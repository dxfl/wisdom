
require_relative 'pdf_interface'
require_relative 'mongo_interface'
require 'logger'

LOG = Logger.new($stderr)
LOG.level = Logger.const_get(ENV.fetch("LOG_LEVEL", "INFO"))

class Wisdom

  def initialize options
    @main_dir = checked_dir options[:directory]
    @db_name = options[:database]
    @collection_name = options[:collection]
  end

  #need "/" at the end
  def checked_dir directory
    directory[-1] == "/" ? directory : directory + "/"
  end
  
  Pdf_file = Struct.new(:filename, :path) do
    def to_s
      "#{path + filename}"
    end
  end
  
  def delete_dots list
    list.delete(".")
    list.delete("..")
    list
  end

  def get_directories directory
    delete_dots Dir.entries(directory)
  end

  alias get_files get_directories

  #def get_files folder
  #  delete_dots Dir.entries(folder)
  #end

  def check_post post
    post_size = post.map{ |_, value| value.size }.reduce(:+)
    if post_size >= MongoInterface::MaxBSONSize
      max_size = MongoInterface::MaxBSONSize - post_size - 10000 #10k max size for the rest of fields?
      post[:body] = post[:body][0...max_size]
    end
    LOG.debug "post size = #{post_size}"
    post
  rescue => exception
    post[:body] = "PDF_Error: #{exception.message}"
    post
  end

  #connect mongo
  def connect_mongo
    @mongo = MongoInterface.new(@db_name, @collection_name)
  end
  
  #get pdfs already in mongo
  def get_pdfs_in_mongo
    @mongo.get_all_docs_by :filename
  end

  def extract_pdf pdf_file
    pdf = PDFInterface.new(pdf_file.to_s)
    pdf.process
    post = {filename: pdf_file.filename, #pdf.filename includes path
            title: pdf.title,
            authors: pdf.authors,
            abstract: pdf.abstract,
            body: pdf.body}
    [check_post(post)]
  end

  def with_error_handling
    yield
  rescue => exception
    LOG.debug "PDF_Error: #{exception.message}"
  end  

  def get_files_to_process
    pdf_files = []
    pdfs_in_mongo = get_pdfs_in_mongo
    get_directories(@main_dir).each do |dir|
      path = @main_dir + dir + "/"
      get_files(path).each{ |f| pdf_files << Pdf_file.new(f, path) unless pdfs_in_mongo.include?(f) }
    end
    LOG.info "All files processed (already in mongo)" if pdf_files.size <= 0
    pdf_files 
  end

  def process pdf_files
    pdf_files.each do |file|
      posts = extract_pdf(file)      
      with_error_handling{ @mongo.save(posts) }
      LOG.info "Processed paper: #{file.filename}"
    end
  end
  
  def init
    connect_mongo
    pdf_files_to_process = get_files_to_process
    process pdf_files_to_process
  end
end

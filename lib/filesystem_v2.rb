# Redis data schema
# Directories SET
# key => path, members => file_names
# File HASH
# key => file_path value => data

# Example:
# "tmp" => [ 'server.pid', 'server2.pid'.. ]
# "logs" => [ 'log1.log' ....]
# "tmp/server.pid" => "DANE PLIKU"
# "logs/log1.log" => "DANE PLIKU"
# "tmp/server2.pid" => "DANE PLIKU"
# "logs/apache" => [ 'access.log', 'error.log']
# "logs/apache/error.log" => "DANE PLIKU"


require "redis" 

module FileSystem
  def self.redis
    @redis ||= Redis.new
  end

  class File
    # f = File.new
    # f.path = "/tmp/foo.txt"
    # f.data = "Bar"

    include Persistence

    attr_reader :path, :file_name, :directory_path
    attr_accessor :data

    def initialize(path = nil)
      self.path = path if path
    end

    def path=(path)
      @path = path
      full_path = Path.new(path)
      @directory_path, @file_name = full_path.directory_path, full_path.file_name
    end

    # Returns new or overwritten file
    def self.write(path, data)
      file = File.new(path)
      raise InvalidPathError, "Directory does not exist" if file.directory.exists?
      file.path = path
      file.data = data
      file.save
      file
    end

    # Returns File object from given path
    def self.read(path)
      file = File.new(path)
      raise InvalidPathError, "File does not exists" unless file.exists?
      file.data = load_data
      file
    end

    def save
      if new_record?
        directory.add_new_file(@file_name)
      end
      redis.set(path, data)
    end

    def destroy
      directory.remove_file @file_name
      super
    end

    def directory
      @directory ||= Directory.new(@directory_path)
    end

    # Should raise error if file persists, to change files directory FileUtils class should be used
    def directory=(directory_path)
      # .....
    end
  end

  class Directory
    # d = Directory.new("/tmp/foo.txt")

    include Persistence

    attr_reader :path
    
    def initialize(path)
      @path = path
    end

    def self.find(path)
      # ......
    end

    def add_subdirectory(subdirectory_name)
      subdirectory = Directory.new("#{path}/#{subdirectory_name}")
      subdirectory.save
      subdirectory
    end

    def subdirectories
      # ......
    end

    def files
      # ......
    end

    def add_file(file_name)
      # ......      
    end

    def remove_file(file_name)
      # ......
    end

    def save
      raise InvalidPathError, "Directory exists" if exists?
      redis.sadd path, nil
    end

    def destroy
      subdirectories.each(&:destroy)
      super
    end
  end

  module Persistence
    
    def exists?
      redis.exists @path
    end

     def new_record?
      !exists?
    end

    def destroy
      redis.del path
    end

    def load_data
      redis.get path
    end

    def redis
      FileSystem.redis
    end

    # template method
    def save
      raise NotImplementedError
    end
  end

  class Path
    def initialize(path)
      # ......
    end

    def valid?
      # ......
    end

    def file_name
      # ......
    end

    def directory_path
      # ......
    end
  end

  class FileUtils
    class FileUtils
      class << self
        # Moves file to other directory
        def mv(from_path, to_path)        
          # .....
        end

        # Makes copy of file in other directory
        def cp(from_path, to_path)      
          # .....
        end
      end
    end
  end
end


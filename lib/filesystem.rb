# Redis data schema
# path => array_of_serialized_files
# {
# 	"var" => [ File, File, File ...],
# 	"tmp" => [ File, File ...],
# 	"var/logs" => [ File, File ....],
# 	"var/logs/nginx" => [ File, File, File ...] 
# }

module FileSystem
	class File
		attr_reader :data, :path, :file_name

		def initialize(path, file_name, data)
			@path, @file_name, @data = path, file_name, data
		end

		# Returns new or overwritten file
		def self.write(path, file_name, data)
			raise InvalidPathError, "Directory does not exist" if DirectoryUtils.path_exists?(path)
			file = File.new(path, file_name, data)
		  file.save
		  file
		end

		# Returns File object from given path with given name
		def self.read(path, file_name)
		end

		# Removes file from directory files array
		def destroy
		end

		# Adds new file to directory files array
		def save
		end

		# Returns Directory object
		def directory
			Directory.new(path)
		end
	end


	class Directory
		attr_reader :path

		def initialize(path)
			@path = path
		end

		def self.create(path)
			raise InvalidPathError, "Directory already exists" if DirectoryUtils.path_exists?(path)
			dir = Directory.new(path)
			dir.save
			dir
		end

		def self.destroy(path)
			raise InvalidPathError, "Directory does not exist" if DirectoryUtils.path_exists?(path)
			Directory.new(path).destroy
		end

		# Adds new key to redis, with empty value (no files)
		def save	
		end

		# Removes path from redis (remove key)
		# Removes all subdirectories
		def destroy	
		end

		# Returns array od Directory objects
		# Uses Redis keys matching pattern to fetch paths.
		def subdirectories	
		end

		# Returns array of File objects
		def files		
		end
	end

	class DirectoryUtils
		# Checks if key exists in Redis
		def self.path_exists?(path)
		end
	end

	class FileUtils
		class << self
			# Moves file to other path
			def mv(from_path, to_path)				
			end

			# Makes copy of file in other directory
			def cp(from_path, to_path)			
			end
		end
	end
	
	class InvalidPathError < ArgumentError
	end
end

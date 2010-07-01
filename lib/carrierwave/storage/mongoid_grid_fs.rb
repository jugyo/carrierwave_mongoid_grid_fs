# encoding: utf-8

module CarrierWave
  module Storage

    # The GridFS store uses MongoDB's GridStore file storage system to store files
    class MongoidGridFS < Abstract

      class File < GridFS::File

        def io
          grid.open(@path, 'r')
        end

        def md5
          io[:md5]
        end

        # override CarrierWave::Storage::GridFS#write
        def write(file)
          grid_to_write.open(@uploader.store_path, 'w', :content_type => file.content_type) do |f| 
            f.write(file.read)
          end
        end

      protected

        def grid
          @grid ||= Mongo::GridFileSystem.new(::Mongoid.slaves || ::Mongoid.master)
        end

        def grid_to_write
          @grid_to_write ||= Mongo::GridFileSystem.new(::Mongoid.master)
        end

      end

      # Store the file in MongoDB's GridFS GridStore
      def store!(file)
        stored = CarrierWave::Storage::MongoidGridFS::File.new(uploader, uploader.store_path)
        stored.write(file)
        stored
      end

      # Retrieve the file from MongoDB's GridFS GridStore
      def retrieve!(identifier)
        CarrierWave::Storage::MongoidGridFS::File.new(uploader, uploader.store_path(identifier))
      end

    end
  end
end

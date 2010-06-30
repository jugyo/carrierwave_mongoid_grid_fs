require 'carrierwave/orm/mongoid'
require 'carrierwave/storage/mongoid_grid_fs'

CarrierWave.configure do |config|
  config.storage_engines[:mongoid_grid_fs] = 'CarrierWave::Storage::MongoidGridFS'
end

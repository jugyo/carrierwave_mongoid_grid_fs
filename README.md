CarrierwaveMongoidGridFs
====

CarrierWave storage using Mongoid and GridFS

Example
----

Uploader:

    class AvatarUploader < CarrierWave::Uploader::Base
      storage :mongoid_grid_fs
      ...
    end

Model:

    class User
      ...
      mount_uploader :avatar, AvatarUploader
    end

Controller:

    class UsersController < ApplicationController
      ...
      def avatar
        avatar = User.find(params[:id]).avatar
        response.etag = [avatar.file.md5]
        if request.fresh?(response)
          head :not_modified
        else
          send_data avatar.read
        end
      end
      ...
    end

Copyright (c) 2010 jugyo, released under the MIT license

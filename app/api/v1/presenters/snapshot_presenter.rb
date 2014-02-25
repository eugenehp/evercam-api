require_relative './presenter'
require 'base64'

module Evercam
  module Presenters
    class Snapshot < Presenter

      root :snapshots

      expose :camera, documentation: {
        type: 'string',
        desc: 'Unique Evercam identifier for the camera',
        required: true
      } do |s,o|
        s.camera.exid
      end

      expose :notes, documentation: {
        type: 'string',
        desc: 'Note for snapshot',
        required: false
      }

      expose :created_at, documentation: {
        type: 'string',
        desc: 'Snapshot timestamp',
        required: false
      } do |s,o|
        s.created_at.to_i
      end

      expose :data, if: { type: 'full' }, documentation: {
        type: 'file',
        desc: 'Image data',
        required: false
      } do |s,o|
        data = Base64.encode64(s.data).gsub("\n", '')
        "data:image/jpeg;base64,#{data}"
      end

    end
  end
end

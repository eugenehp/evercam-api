require_relative './presenter'

module Evercam
  module Presenters
    class Camera < Presenter

      root :cameras

      expose :id, documentation: {
        type: 'string',
        desc: 'Unqiue Evercam identifier for the camera',
        required: true
      } do |s,o|
        s.exid
      end

      expose :name, documentation: {
        type: 'string',
        desc: 'Human readable / friendly name for the camera',
        required: true
      }

      expose :is_public, documentation: {
        type: 'boolean',
        desc: 'Whether or not this camera is publically available',
        required: true
      }

      with_options(format_with: :timestamp) do

        expose :created_at, documentation: {
          type: 'integer',
          desc: 'Unix timestamp at creation',
          required: true
        }

        expose :updated_at, documentation: {
          type: 'integer',
          desc: 'Unix timestamp at last update',
          required: true
        }

        expose :polled_at, documentation: {
          type: 'integer',
          desc: 'Unix timestamp at last heartbeat poll'
        }

      end

      expose :is_online, documentation: {
        type: 'boolean',
        desc: 'Whether or not this camera is currently online'
      }

      expose :owner, documentation: {
        type: 'string',
        desc: 'Username of camera owner',
        required: true
      } do |s,o|
        s.owner.username
      end

      expose :endpoints, documentation: {
        type: 'array',
        desc: 'String array of all available camera endpoints',
        required: true,
        items: {
          type: 'string'
        }
      } do |s,o|
        s.endpoints.map(&:to_s)
      end

      expose :snapshots, documentation: {
        type: 'hash',
        desc: 'Hash of image types and paths which return snapshots',
        required: true
      } do |s,o|
        s.config['snapshots']
      end

      expose :auth, documentation: {
        type: 'hash',
        desc: 'Hash of authentication mechanisms and login details',
        required: true
      } do |s,o|
        s.config['auth']
      end

    end
  end
end


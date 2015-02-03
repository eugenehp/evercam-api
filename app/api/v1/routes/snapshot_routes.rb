require 'typhoeus'
require_relative '../presenters/snapshot_presenter'

module Evercam

  def self.get_jpg(camera)
    response = nil

    unless camera.external_url.nil?
      begin
        conn = Faraday.new(:url => camera.external_url) do |faraday|
          faraday.request :basic_auth, camera.cam_username, camera.cam_password
          faraday.request :digest, camera.cam_username, camera.cam_password
          faraday.adapter  :typhoeus
          faraday.options.timeout = Evercam::Config[:api][:timeout]           # open/read timeout in seconds
          faraday.options.open_timeout = Evercam::Config[:api][:timeout]      # connection open timeout in seconds
        end
        response = conn.get do |req|
          req.url camera.res_url('jpg')
        end
      rescue URI::InvalidURIError => error
        raise BadRequestError, "Invalid URL. Cause: #{error}"
      rescue Faraday::TimeoutError
        raise CameraOfflineError, 'We can&#39;t connect to your camera at the moment - please check your settings'
      end
      if response.success?
        response
      elsif response.status == 401
        raise AuthorizationError, 'Please check camera username and password'
      else
        raise CameraOfflineError, 'We can&#39;t connect to your camera at the moment - please check your settings'
      end
    end
  end

  class V1SnapshotJpgRoutes < Grape::API
    format :json

    namespace :cameras do
      #-------------------------------------------------------------------
      # GET /v1/cameras/:id/live/snapshot
      #-------------------------------------------------------------------
      params do
        requires :id, type: String, desc: "Camera Id."
      end
      route_param :id do
        desc 'Returns jpg from the camera'
        get '/live/snapshot' do
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::SNAPSHOT)

          unless camera.external_url.nil?
            require 'openssl'
            require 'base64'
            auth = camera.config.fetch('auth', {}).fetch('basic', '')
            if auth != '' and auth != {'username'=>'', 'password'=>''}
              auth = "#{camera.config['auth']['basic']['username']}:#{camera.config['auth']['basic']['password']}"
            end
            c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
            c.encrypt
            c.key = "#{Evercam::Config[:snapshots][:key]}"
            c.iv = "#{Evercam::Config[:snapshots][:iv]}"
            # Padding was incompatible with node padding
            c.padding = 0
            msg = camera.external_url
            msg << camera.res_url('jpg') unless camera.res_url('jpg').blank?
            msg << "|#{auth}|#{Time.now.to_s}|"
            until msg.length % 16 == 0 do
              msg << ' '
            end
            t = c.update(msg)
            t << c.final

            CameraActivity.create(
              camera: camera,
              access_token: access_token,
              action: 'viewed',
              done_at: Time.now,
              ip: request.ip
            )

            redirect "#{Evercam::Config[:snapshots][:url]}#{camera.exid}.jpg?t=#{Base64.urlsafe_encode64(t)}"
          end
        end
      end
    end

    namespace :public do
        #-------------------------------------------------------------------
        # GET /v1/public/cameras/nearest/snapshot
        #-------------------------------------------------------------------
        desc "Returns jpg from nearest publicly discoverable camera from within the Evercam system."\
             "If location isn't provided requester's IP address is used.", {
        }
        params do
          optional :near_to, type: String, desc: "Specify an address or latitude longitude points."
        end
        get 'cameras/nearest/snapshot' do
          begin
            if params[:near_to]
              location = {
                latitude: Geocoding.as_point(params[:near_to]).y,
                longitude: Geocoding.as_point(params[:near_to]).x
              }
            else
              location = {
                latitude: request.location.latitude,
                longitude: request.location.longitude
              }
            end
          rescue Exception => ex
            raise_error(400, 400, ex.message)
          end

          if params[:near_to] or request.location
            camera = Camera.nearest(location).limit(1).first
          else
            raise_error(400, 400, "Location is missing")
          end

          rights = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::SNAPSHOT)

          unless camera.external_url.nil?
            require 'openssl'
            require 'base64'
            auth = camera.config.fetch('auth', {}).fetch('basic', '')
            if auth != ''
              auth = "#{camera.config['auth']['basic']['username']}:#{camera.config['auth']['basic']['password']}"
            end
            c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
            c.encrypt
            c.key = "#{Evercam::Config[:snapshots][:key]}"
            c.iv = "#{Evercam::Config[:snapshots][:iv]}"
            # Padding was incompatible with node padding
            c.padding = 0
            msg = camera.external_url
            msg << camera.res_url('jpg') unless camera.res_url('jpg').blank?
            msg << "|#{auth}|#{Time.now.to_s}|"
            until msg.length % 16 == 0 do
              msg << ' '
            end
            t = c.update(msg)
            t << c.final

            CameraActivity.create(
              camera: camera,
              access_token: access_token,
              action: 'viewed',
              done_at: Time.now,
              ip: request.ip
            )

            redirect "#{Evercam::Config[:snapshots][:url]}#{camera.exid}.jpg?t=#{Base64.strict_encode64(t)}"
          end
        end
      end

  end

  class V1SnapshotRoutes < Grape::API

    include WebErrors
    before do
      authorize!
    end

    DEFAULT_LIMIT_WITH_DATA = 10
    DEFAULT_LIMIT_NO_DATA = 100
    MAXIMUM_LIMIT = 1000

    namespace :cameras do
      params do
        requires :id, type: String, desc: "Camera Id."
      end
      route_param :id do

        #-------------------------------------------------------------------
        # GET /v1/cameras/:id/recordings/snapshots
        #-------------------------------------------------------------------
        desc 'Returns the list of all snapshots currently stored for this camera'
        params do
          requires :id, type: String, desc: "Unique identifier for the camera"
          optional :from, type: Integer, desc: "From Unix timestamp."
          optional :to, type: Integer, desc: "To Unix timestamp."
          optional :limit, type: Integer, desc: "The maximum number of cameras to retrieve. Defaults to #{DEFAULT_LIMIT_NO_DATA}, cannot be more than #{MAXIMUM_LIMIT}."
          optional :page, type: Integer, desc: "Page number, starting from 0"
        end
        get 'recordings/snapshots' do
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::LIST)

          limit = params[:limit] || DEFAULT_LIMIT_NO_DATA
          limit = DEFAULT_LIMIT_NO_DATA if limit < 1 or limit > MAXIMUM_LIMIT

          page = params[:page].to_i || 0
          page = 0 if page < 0
          offset = (page - 1) * limit
          offset = 0 if offset < 0

          from = Time.at(params[:from].to_i).to_s
          to = Time.at(params[:to].to_i).to_s
          to = Time.now.to_s if params[:to].blank?

          query = Snapshot.where(:camera_id => camera.id).select(:notes, :created_at).order(:created_at).filter(:created_at => (from..to))

          count = query.count
          total_pages = count / limit
          total_pages += 1 unless count % limit == 0

          snapshots = query.limit(limit).offset(offset).all

          present(snapshots, with: Presenters::Snapshot).merge!({
              timezone: camera.timezone.zone, pages: total_pages
            })
        end

        #-------------------------------------------------------------------
        # GET /v1/cameras/:id/recordings/snapshots/latest
        #-------------------------------------------------------------------
        desc 'Returns latest snapshot stored for this camera', {
          entity: Evercam::Presenters::Snapshot
        }
        params do
          optional :with_data, type: 'Boolean', desc: "Should it send image data?"
        end
        get 'recordings/snapshots/latest' do
          camera = get_cam(params[:id])
          snapshot = camera.snapshots.order(:created_at).last
          if snapshot
            rights = requester_rights_for(camera)
            raise AuthorizationError.new unless rights.allow?(AccessRight::LIST)
            present(Array(snapshot), with: Presenters::Snapshot, with_data: params[:with_data]).merge!({
              timezone: camera.timezone.zone
            })
          else
            present([], with: Presenters::Snapshot, with_data: params[:with_data]).merge!({
              timezone: camera.timezone.zone
            })
          end
        end

        #-------------------------------------------------------------------
        # GET /v1/cameras/:id/snapshots/:year/:month/day
        #-------------------------------------------------------------------
        desc 'Returns list of specific days in a given month which contains any snapshots'
        params do
          requires :year, type: Integer, desc: "Year, for example 2013"
          requires :month, type: Integer, desc: "Month, for example 11"
        end
        get 'recordings/snapshots/:year/:month/days' do
          unless (1..12).include?(params[:month])
            raise BadRequestError, 'Invalid month value'
          end
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::LIST)

          days = []
          (1..Date.new(params[:year], params[:month], -1).day).each do |day|
            from = camera.timezone.time(Time.utc(params[:year], params[:month], day)).to_s
            to = camera.timezone.time(Time.utc(params[:year], params[:month], day, 23, 59, 59)).to_s
            if camera.snapshots.filter(:created_at => (from..to)).count > 0
              days << day
            end
          end

          { :days => days}
        end

        #-------------------------------------------------------------------
        # GET /v1/cameras/:id/snapshots/:year/:month/:day/hours
        #-------------------------------------------------------------------
        desc 'Returns list of specific hours in a given day which contains any snapshots'
        params do
          requires :year, type: Integer, desc: "Year, for example 2013"
          requires :month, type: Integer, desc: "Month, for example 11"
          requires :day, type: Integer, desc: "Day, for example 17"
        end
        get 'recordings/snapshots/:year/:month/:day/hours' do
          unless (1..12).include?(params[:month])
            raise BadRequestError, 'Invalid month value'
          end
          unless (1..31).include?(params[:day])
            raise BadRequestError, 'Invalid day value'
          end
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::LIST)

          hours = []
          (0..23).each do |hour|
            from = camera.timezone.time(Time.utc(params[:year], params[:month], params[:day], hour)).to_s
            to = camera.timezone.time(Time.utc(params[:year], params[:month], params[:day], hour, 59, 59)).to_s
            if camera.snapshots.filter(:created_at => (from..to)).count > 0
              hours << hour
            end
          end

          { :hours => hours}
        end

        #-------------------------------------------------------------------
        # GET /v1/cameras/:id/snapshots/:timestamp
        #-------------------------------------------------------------------
        desc 'Returns the snapshot stored for this camera closest to the given timestamp', {
          entity: Evercam::Presenters::Snapshot
        }
        params do
          requires :timestamp, type: Integer, desc: "Snapshot Unix timestamp."
          optional :with_data, type: 'Boolean', desc: "Should it send image data?"
          optional :range, type: Integer, desc: "Time range in seconds around specified timestamp. Default range is one second (so it matches only exact timestamp)."
        end
        get 'recordings/snapshots/:timestamp' do
          camera = get_cam(params[:id])

          snapshot = camera.snapshot_by_ts!(Time.at(params[:timestamp].to_i), params[:range].to_i)
          rights   = requester_rights_for(camera)
          raise AuthorizationError.new unless rights.allow?(AccessRight::LIST)

          present Array(snapshot), with: Presenters::Snapshot, with_data: params[:with_data]
        end

        #-------------------------------------------------------------------
        # POST /v1/cameras/:id/recordings/snapshots
        #-------------------------------------------------------------------
        desc 'Fetches a snapshot from the camera and stores it using the current timestamp'
        params do
          optional :notes, type: String, desc: "Optional text note for this snapshot"
          optional :with_data, type: 'Boolean', desc: "Should it return image data?"
        end
        post 'recordings/snapshots' do
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new if !rights.allow?(AccessRight::SNAPSHOT)

          outcome = Actors::SnapshotFetch.run(params)
          unless outcome.success?
            raise OutcomeError, outcome.to_json
          end

          CameraActivity.create(
            camera: camera,
            access_token: access_token,
            action: 'captured',
            done_at: Time.now,
            ip: request.ip
          )

          present Array(outcome.result), with: Presenters::Snapshot, with_data: params[:with_data]
        end

        #-------------------------------------------------------------------
        # POST /v1/cameras/:id/recordings/snapshots/:timestamp
        #-------------------------------------------------------------------
        desc 'Stores the supplied snapshot image data for the given timestamp'
        params do
          requires :timestamp, type: Integer, desc: "Snapshot Unix timestamp."
          requires :data, type: File, desc: "Image file."
          optional :notes, type: String, desc: "Optional text note for this snapshot"
          optional :with_data, type: 'Boolean', desc: "Should it return image data?"
        end
        post 'recordings/snapshots/:timestamp' do
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera)
          raise AuthorizationError.new if !rights.allow?(AccessRight::SNAPSHOT)

          outcome = Actors::SnapshotCreate.run(params)
          unless outcome.success?
            raise OutcomeError, outcome.to_json
          end

          CameraActivity.create(
            camera: camera,
            access_token: access_token,
            action: 'captured',
            done_at: Time.now,
            ip: request.ip
          )

          present Array(outcome.result), with: Presenters::Snapshot, with_data: params[:with_data]
        end

        #-------------------------------------------------------------------
        # DELETE /v1/cameras/:id/recordings/snapshots/:timestamp
        #-------------------------------------------------------------------
        desc 'Deletes any snapshot for this camera which exactly matches the timestamp'
        params do
          requires :timestamp, type: Integer, desc: "Snapshot Unix timestamp."
        end
        delete 'recordings/snapshots/:timestamp' do
          camera = get_cam(params[:id])

          rights = requester_rights_for(camera.owner, AccessRight::SNAPSHOTS)
          raise AuthorizationError.new if !rights.allow?(AccessRight::DELETE)

          CameraActivity.create(
            camera: camera,
            access_token: access_token,
            action: 'deleted snapshot',
            done_at: Time.now,
            ip: request.ip
          )

          camera.snapshot_by_ts!(Time.at(params[:timestamp].to_i)).destroy
          {}
        end
      end
    end
  end
end

Sequel.migration do

  up do
    # config = {snapshots: {jpg: "/Streaming/channels/1/picture"},
    #           auth: {basic: {username: "admin", password: "12345"}}}
    # user   = self[:users].where(username: 'evercam').first
    # if !user.nil?
    #   self[:cameras].insert(exid:        'evercam-remembrance-camera',
    #                         owner_id:    user[:id],
    #                         is_public:   true,
    #                         config:      config.to_json,
    #                         name:        'Evercam Remembrance Camera',
    #                         timezone:    'Europe/Dublin',
    #                         mac_address: '8c:e7:48:bd:bd:f5',
    #                         created_at:  Time.now,
    #                         updated_at:  Time.now)
    # else
    #   STDERR.puts "WARNING: Unable to create the evercam remembrance camera in "\
    #               "the #{self.uri} database as the evercam user could not be found."
    # end
  end

  down do
    # self[:cameras].where(exid: 'evercam-remembrance-camera').delete
  end

end

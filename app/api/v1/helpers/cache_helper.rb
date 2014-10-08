module Evercam
  module CacheHelper

    def invalidate_for_user(username)
      ['true', 'false', ''].repeated_permutation(2) do |a|
        Evercam::APIv1::dc.delete("user/cameras/#{username}/#{a[0]}/#{a[1]}")
      end
    end

    def invalidate_for_camera(camera)
      camera_sharees = CameraShare.where(camera_id: camera.id)
      if camera_sharees.blank?
        camera_sharees.each do |user|
          username = User[user.user_id].username
          invalidate_for_user(username)
        end
      end
    end

  end
end

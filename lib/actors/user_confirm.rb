module Evercam
  module Actors
    class UserConfirm < Mutations::Command

      required do
        string :username
      end

      def validate
        unless user = User.by_login(username)
          add_error(:username, :exists, 'Username does not exist')
        end

        if user && user.confirmed_at
          add_error(:username, :confirmed, 'Username is already confirmed')
        end
      end

      def execute
        User.by_login(username).
          update(confirmed_at: Time.now)
      end

    end
  end
end


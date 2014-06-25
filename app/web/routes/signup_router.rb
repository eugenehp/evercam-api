require_relative "./web_router"

module Evercam
  class WebSignupRouter < WebRouter

    get '/signup' do
      @countries = Country.all

      signup = session[:signup] || {}     
      session[:signup] = {}

      erb :signup, :locals => {:signup => signup}
    end

    post '/signup' do
      if (outcome = Actors::UserSignup.run(params)).success?
        redirect '/login', success:
          %(Congratulations, we've sent you a confirmation email to complete the next step in the process)
      else

        session[:signup] = { firstname: params[:firstname], lastname: params[:lastname], country: params[:country], username: params[:username], email: params[:email] }

        redirect '/signup', error:
          outcome.errors
      end
    end

    get '/confirm' do
      @user = confirm_validate
      erb 'confirm'.to_sym
    end

    post '/confirm' do
      @user = confirm_validate
      outcome = Actors::UserReset.run(params.merge(username: params[:u]))

      if outcome.success?
        session[:user] = @user.pk
        Actors::UserConfirm.run(username: params[:u], confirmation: params[:c])
        redirect "/users/#{@user.username}", info: 'Your account has now been confirmed'
      end

      flash.now[:error] = outcome.errors
      erb 'confirm'.to_sym
    end

    post '/interested' do
      email = params[:email]

      unless email =~ /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
        flash[:error] = 'Sorry but the email address you entered does not appear to be valid'
      else
        Mailers::UserMailer.interested(email: email, request: request)
        cookies.merge!({ email: email, created_at: Time.now.to_i })
        flash[:success] = "Thank you for your interest. We'll be in contact soon..."
      end

      redirect '/'
    end

    private

    def confirm_validate
      User.by_login(params[:u]).tap do |user|

        if user && user.confirmed?
          redirect '/login', info: 'This account has already been confirmed, you can now login'
        end

        unless user && user.password == params[:c]
          redirect '/signup', error: 'Sorry but these credentials do not appear to be valid'
        end

      end
    end

  end
end


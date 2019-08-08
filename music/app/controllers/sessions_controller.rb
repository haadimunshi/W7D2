class SessionsController < ApplicationController
    #SessionsController is for SIGNING IN

    before_action :require_logged_out, only: [:new, :create]

    def new         #renders the login form, creates a @user int var which is a new user instance
    end

    def create                                                                                  #action for persisting the potentially newly created session to the db...?
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])       #uses the method from user.rb and the params required for that method to attempt to find a user with the user-inputted credentials, sets the user to @user

        if @user                            #if we do find the user...
            login(@user)                    #log the user in....
            redirect_to user_url(@user)     #and redirect to the user's #show page
        else
            #error message
            render :new                     #render the form for login again, since the user must have inputted incorrect/incomplete credentials
        end

    end

    def destroy                                 #action for logging out a user               
        logout                                  #method from action_controller
        redirect_to new_session_url             #redirect to page with form for login
    end

end

class ApplicationController < ActionController::Base
    helper_method :current_user, :logged_in?           #any method in this file that we specify as a helper_method becomes available in our views files

    def current_user                                                                #method for setting the currently logged in user to instaance variable, if there is a currently logged in user
        @current_user = User.find_by(session_token: session[:session_token])        #checks if there is a user who has a session token equivalent to the session token in the session hash (AKA: checks if there is a user with a client-side session token that matches a session's session token. if this is the case, we know we have a currently logged in user, and therefore set the inst var as such.
    end

    def login(user)                                             #method to log a user in
        session[:session_token] = user.reset_session_token!     #sets the server-side token equal to the client-side token using the reset_session_token! method we created in user model (recall: that method generates a new client-side session token, saves the user to the db, and returns the user's newly generated session token) 
    end

    def logout                                                  #method to log a user out
        current_user.reset_session_token! if logged_in?         #use current_user method above to get @current_user and reset the user's session token (method from user model) IF we have a current_user
        session[:session_token] = nil                           #sets the server-side token to nil, so now, we have broken the server-client connection from both sides
        @current_user = nil                                     #sets the @current_user to nil
    end

    def logged_in?                    #method to check if someone is logged in (literally only implemented for use in the logout method above)
        !!@current_user              #checks if someone is logged in, returns a boolean
    end

    def require_logged_in
        redirect_to new_session_url unless logged_in?
    end

    def require_logged_out
        redirect_to users_url if logged_in?
    end
end

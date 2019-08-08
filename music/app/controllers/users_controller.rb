class UsersController < ApplicationController
    #UsersController is for SIGNING UP

    before_action :require_logged_in, only: [:new, :create, :show]

    def new                     #this is the action that renders the sign-up form, which we will create in our new.html.erb view file. Basically it just renders a form that allows a new user the ability to sign up.
        @user = User.new        #creates a user instance so and assigns it to @user so that we can use '@user' in our logic for new.html.erb...?
        render :new             #REMEMBER: render: :action in a controller executes the code in the corresponding view for the action
    end

    def create                              #this action happens after the 'new' action. it 'creates' (persists) the user to our db with their inputted params when they sign up
        @user = User.new(user_params)       #verifies that our new user has inputted the required params correctly
        if @user.save                       #if our user met our param requirements (model level validations)....
            login(@user)                   #(we get our login method from applicationcontroller) log the user in immediately...
            redirect_to user_url(@user)     #and redirect to the #show page for the @user (will need to add a #show route to routes.rb first)
        else
            render :new                     #otherwise, send the user back to the page that contains the form to sign up
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password)         #we know to permit :email and :password because those are the specific params required for a user to sign up, and this entire controller is for signing up
    end


end

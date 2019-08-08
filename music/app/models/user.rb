# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
    
    after_initialize :ensure_session_token                                      #before we even run any validations, we want to ensure that right after we initialize a new user instance, the instance has a session_token

    validates :email, :session_token, presence: true, uniqueness: true          #validates email and session_token presence/uniqueness
    validates :password_digest, presence: true                                  #validates pwd_digest presence
    validates :password, length: {minimum: 6}, allow_nil: true                  #validates password length, allows password to be nil for cases where, for ex, updating a user and don't need pwd. we get this attribute from line 39 when we initialize a user (remember, these validations run after initilization)

    attr_reader :password                                   #this is required so that we can access our password for our validations above

    def self.generate_session_token                         #class method to generate session token for a user instance
        self.session_token = SecureRandom::urlsafe_base64   #generates a random token, assigns is to the user instance's session_token
    end

    def reset_session_token!                                #method to reset the session token 
        self.generate_session_token                         #call the class method we created above to generate a new session token for a user instance
        self.save!                                          #save the user instance to the db, use ! so that we get usable errors if we hit this point in the code and something is wrong
        self.session_token                                  #return the user instance's new session token that was newly generated on line 20
    end

    def ensure_session_token                                            #method to set the user instance's session token only if it currently is nil (hasn't been generated yet for some reason)
        self.session_token ||= SecureRandom::urlsafe_base64             #returns user instance's session token if it has been generated, otherwise generates it
    end

    def password=(password)                                             #setter method for user's password
        self.password_digest = BCrypt::Password.create(password)        #creates a password_digest for the user using BCrypt (basically we create a big random hash as password_digest that corresponds to the password the user has inputted).
        @password = password                                            #assigns the user-inputted password to an instance variable
    end

    def is_password?(password)                                          #method to check if the user-inputted password is correct for the corresponding user
        BCrypt::Password.new(password_digest).is_password?(password)    #creates a BCrypt object based on the user's password_digest that corresponds to their correct password, then checks if that BCrypt object matches the correct user password (basically decrypts the hash we made in line 30 and checks if the decrypted object, which is the correct password, matches the user-inputted password)
    end

    def self.find_by_credentials(email, password)                       #class method to find a user in the db based on user-inputted credentials
        user = User.find_by(email: email)                               #attempts to find a user in the db by searching for the user-inputted email within the email col of the table. sets that user to a variable called "user"
        return nil unless user                                          #return nil if we couldn't find the user, otherwise return the user
        user.is_password?(password) ? user : nil                        #still have to check if user-inputted pwd is correct, even if we've found the user based on email so far so take our user variable we created on line 47, check if the password is correct with our is_pwd? method. return the user if the pwd is correct, otherwise return nil.
    end

end

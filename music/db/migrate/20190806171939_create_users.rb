class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, null: false              #creates email column with not-null constraint
      t.string :password_digest, null: false    #creates pwd_digest column with not-null constraint
      t.string :session_token, null: false      #creates session token column with not-null contraint
      
      t.timestamps
    end
    add_index :users, :email, :session_token, unique: true      #adds indexes to email and session_token cols, makes sure the actual emails and session_tokens are unique (indexes will already be unique bc that's the nature of what an idx is)
  end
end

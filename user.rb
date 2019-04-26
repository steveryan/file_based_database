require "pry"

class User
  attr_accessor :first_name, :last_name, :email

  def self.create(first_name:, last_name:, email:)
    if User.is_email_in_use?(email)
       return puts "Sorry this email is taken"
     else
       new_user = new(
         first_name: first_name,
         last_name: last_name,
         email: email
       )
       write_new_user_to_db(new_user)
       new_user
     end
  end

  def self.write_new_user_to_db(new_user)
    users = self.all.map(&:to_h) << new_user.to_h
    File.write("users.json", users.to_json)
  end

  def self.all
    users_json = File.exist?("users.json") ? File.read("users.json") : "[]"
    parsed_users = JSON.parse(users_json, symbolize_names: true)
    parsed_users.map do |user|
      User.new(first_name: user[:first_name], last_name: user[:last_name], email: user[:email])
    end
  end

  def self.is_email_in_use? (email)
    self.all.map(&:to_h).any? { |user| user.has_value?(email) }
  end

  def initialize(first_name:,
    last_name:,
    email:
  )
    @first_name = first_name
    @last_name = last_name
    @email = email
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def to_h
    {first_name: first_name, last_name: last_name, email: email}
  end

end

brooks = User.create(first_name: "Brooks", last_name: "Swinnerton", email: "brooks@test.com")
steve = User.create(first_name: "Steve", last_name: "Ryan", email: "steve@test.com")
binding.pry

require "pry"

class User
  @all_users = []
  attr_accessor :first_name, :last_name, :email

  def self.all
    @all_users
  end

  def self.all=(array_of_users)
    @all_users = array_of_users
  end

  def self.create(first_name:, last_name:, email:)
    if User.is_email_in_use?(email)
       raise ArgumentError "Sorry, the email #{email} is already in use"
     else
       new_user = new(
         first_name: first_name,
         last_name: last_name,
         email: email
       )
       new_user
     end
  end

  def self.write_new_user_to_db
    users = @all_users.uniq.map(&:to_h)
    File.write("users.json", users.to_json)
  end

  def self.read_file_for_users
    users_json = File.exist?("users.json") ? File.read("users.json") : "[]"
    parsed_users = JSON.parse(users_json, symbolize_names: true)
    @all_users = parsed_users.map do |user|
      User.new(first_name: user[:first_name], last_name: user[:last_name], email: user[:email])
    end
  end

  def self.is_email_in_use? (email)
    @all_users.map(&:to_h).any? { |user| user.has_value?(email) }
  end

  def self.destroy_all
    @all_users = []
    User.write_new_user_to_db
    puts "All users deleted"
  end

  def initialize(first_name:,
    last_name:,
    email:
  )
    @first_name = first_name
    @last_name = last_name
    @email = email
    User.all=( User.all << self )
    User.write_new_user_to_db
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end

  def to_h
    {first_name: first_name, last_name: last_name, email: email}
  end

  def update(first_name: @first_name, last_name: @last_name, email: @email)
    @first_name = first_name
    @last_name = last_name
    if email == @email
      @email
    elsif User.is_email_in_use?(email)
      puts "Email in use"
    else
      @email = email
    end
    User.write_new_user_to_db
    self
  end

  def destroy
    User.all.delete(self)
    User.write_new_user_to_db
    puts "User has been deleted"
  end
end
User.read_file_for_users
brooks = User.create(first_name: "Brooks", last_name: "Swinnerton", email: "brooks@test.com")
steve = User.create(first_name: "Steve", last_name: "Ryan", email: "steve@test.com")
binding.pry

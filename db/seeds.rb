# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "json"
require "open-uri"
require "faker"

User.destroy_all
Post.destroy_all
Comment.destroy_all

30.times do
url = "https://hacker-news.firebaseio.com/v0/topstories.json"
post_ids = JSON.parse(URI.parse(url).read)
  post_id = post_ids.sample
  post_url = "https://hacker-news.firebaseio.com/v0/item/#{post_id}.json"
  post_serialized = URI.parse(post_url).read
  post = JSON.parse(post_serialized)
user = User.create!(password: "azerty", email: Faker::Internet.email, username: Faker::Internet.username)
 post = Post.create!(
    title: post["title"],
    content: post["text"] || Faker::Lorem.paragraph,
    url: post["url"],
    user: user
  )
  post.liked_by(user)
user2 = User.create!(password: "azerty", email: Faker::Internet.email, username: Faker::Internet.username)
  Comment.create!(
    content: Faker::Lorem.sentence,
    user: user2,
    post: Post.last
  )

  puts "Post with ID #{post['id']} created with title '#{post['title']}'"
end

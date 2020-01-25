# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user1 = User.create!(name: "Barb E. Dahl", balance_cents: 500, account_number: '01A')
user2 = User.create!(name: "Zeke N. Yeshallfind", balance_cents: 100, account_number: '02A')

book1 = Book.create!(author: "Frank Herbert", title: "Premier")
book2 = Book.create!(author: "Frank Herbert", title: "Sayyadina")
book3 = Book.create!(author: "Frank Herbert", title: "Prince")
book4 = Book.create!(author: "Frank Herbert", title: "Prince")
book5 = Book.create!(author: "Frank Herbert", title: "Sayyadina")

transaction1 = Transaction.create!(user: user1, book: book1, returned_at: 1.month.ago)
transaction2 = Transaction.create!(user: user1, book: book2)
transaction3 = Transaction.create!(user: user2, book: book2)


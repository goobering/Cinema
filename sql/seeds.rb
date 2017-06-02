require_relative '../models/customer.rb'
require_relative '../models/film.rb'
require_relative '../models/ticket.rb'

require 'pry-byebug'

Customer.delete_all()
Film.delete_all()
Ticket.delete_all()

customer1 = Customer.new({'name' => 'Alice', 'funds' => 30})
customer1.save()
customer2 = Customer.new({'name' => 'Bob', 'funds' => 25})
customer2.save()

film1 = Film.new({'title' => 'Jaws', 'price' => 10})
film1.save()
film2 = Film.new({'title' => 'Hot Fuzz', 'price' => 8})
film2.save()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'film_id' => film1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  'customer_id' => customer2.id,
  'film_id' => film2.id
  })
ticket2.save()

binding.pry()
nil
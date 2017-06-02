require_relative '../models/customer.rb'
require_relative '../models/film.rb'

require 'pry-byebug'

Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Alice', 'funds' => 30})
customer1.save()
customer2 = Customer.new({'name' => 'Bob', 'funds' => 25})
customer2.save()

film1 = Film.new({'title' => 'Jaws', 'price' => 10})
film1.save()
film2 = Film.new({'title' => 'Hot Fuzz', 'price' => 8})
film2.save()
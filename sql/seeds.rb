require_relative '../models/customer.rb'
require_relative '../models/film.rb'
require_relative '../models/ticket.rb'
require_relative '../models/screening.rb'

require 'pry-byebug'

Customer.delete_all()
Screening.delete_all()
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

screening1 = Screening.new({
  'film_id' => film1.id,
  'start_time' => DateTime.now().to_s,
  'capacity' => 3
  })
screening1.save()

screening2 = Screening.new({
  'film_id' => film1.id,
  'start_time' => (DateTime.now() + 1).to_s,
  'capacity' => 4
  })
screening2.save()

screening3 = Screening.new({
  'film_id' => film1.id,
  'start_time' => (DateTime.now() + 2).to_s,
  'capacity' => 5
  })
screening3.save()

screening4 = Screening.new({
  'film_id' => film2.id,
  'start_time' => (DateTime.now()).to_s,
  'capacity' => 6
  })
screening4.save()

screening5 = Screening.new({
  'film_id' => film2.id,
  'start_time' => (DateTime.now() + 1).to_s,
  'capacity' => 7
  })
screening5.save()

screening6 = Screening.new({
  'film_id' => film2.id,
  'start_time' => (DateTime.now() + 2).to_s,
  'capacity' => 8
  })
screening6.save()

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'screening_id' => screening1.id
  })
ticket1.save()

ticket2 = Ticket.new({
  'customer_id' => customer1.id,
  'screening_id' => screening1.id
  })
ticket2.save()

ticket3 = Ticket.new({
  'customer_id' => customer1.id,
  'screening_id' => screening3.id
  })
ticket3.save()

ticket4 = Ticket.new({
  'customer_id' => customer2.id,
  'screening_id' => screening4.id
  })
ticket4.save()

binding.pry()
nil
require_relative '../sql/sql_runner'

class Ticket

attr_reader :id
attr_accessor :customer_id, :screening_id

def initialize(options)
  @id = options['id'].to_i 
  @customer_id = options['customer_id'].to_i
  @screening_id = options['screening_id'].to_i
end

def save()
  sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ('#{@customer_id}', '#{@screening_id}') RETURNING id;"
  ticket = SqlRunner.run(sql).first()
  @id = ticket['id'].to_i
end

def find()
  sql = "SELECT * FROM tickets WHERE tickets.id = #{@id}"
  ticket = SqlRunner.run(sql)
  return Ticket.new(ticket.first())
end

def update()
  sql = "UPDATE tickets SET (customer_id, screening_id) = ('#{@customer_id}', '#{screening_id}') WHERE id = #{@id}"
  SqlRunner.run(sql)
end

def delete()
  sql = "DELETE FROM tickets WHERE tickets.id = #{@id}"
  SqlRunner.run(sql)
end

def refund()
  # Get the relevant customer
  customer_sql = "SELECT * FROM customers where customers.id = #{@customer_id}"
  result = SqlRunner.run(customer_sql)
  customer = Customer.new(result.first())

  # Get the relevant film price via the ticket screening_id
  film_price_sql = "SELECT films.price FROM films INNER JOIN screenings ON films.id = screenings.film_id WHERE screenings.id = #{@screening_id};"
  result = SqlRunner.run(film_price_sql)

  film_price = result.first()['price'].to_i

  # Refund customer money
  customer.add_funds(film_price)
  customer.update()

  # Delete the ticket
  delete()
end

def self.refund(customer, screening)
  # Get a single ticket matching the screening id
  ticket_to_refund = customer.tickets().select { |ticket| ticket.screening_id == screening.id }.first()

  # Return nil if no ticket found
  if ticket_to_refund == nil
    return nil
  end

  ticket_to_refund.refund()
end

def self.buy(customer, screening)
  # Get the relevant film price via the ticket screening_id
  film_price_sql = "SELECT films.price FROM films INNER JOIN screenings ON films.id = screenings.film_id WHERE screenings.id = #{screening.id};"
  result = SqlRunner.run(film_price_sql)
  film_price = result.first()['price'].to_i

  # Quit early if customer doesn't have enough money
  return nil if customer.funds < film_price

  # Quit early if the screening doesn't have enough capacity
  return nil if screening.num_customers() >= screening.capacity()

  # Subtract film price from customer funds and update customer in DB
  customer.subtract_funds(film_price)

  # Create and save the new ticket
  ticket = Ticket.new({
    'customer_id' => customer.id, 
    'screening_id' => screening.id})
  ticket.save()

  # Return new ticket
  return ticket
end

def self.all()
  sql = "SELECT * FROM tickets;"
  result = SqlRunner.run(sql)
  tickets = result.map { |ticket| Ticket.new(ticket)}
  return tickets
end

def self.delete_all()
  sql = "DELETE FROM tickets;"
  SqlRunner.run(sql)
end

end
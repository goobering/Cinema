require_relative '../sql/sql_runner'

class Ticket

attr_reader :id
attr_accessor :customer_id, :film_id

def initialize(options)
  @id = options['id'].to_i 
  @customer_id = options['customer_id'].to_i
  @film_id = options['film_id'].to_i
end

def save()
  sql = "INSERT INTO tickets (customer_id, film_id) VALUES ('#{@customer_id}', '#{@film_id}') RETURNING id;"
  ticket = SqlRunner.run(sql).first()
  @id = ticket['id'].to_i
end

def find()
  sql = "SELECT * FROM tickets WHERE tickets.id = #{@id}"
  ticket = SqlRunner.run(sql)
  return Ticket.new(ticket.first())
end

def self.buy(customer, film)
  # Quit early if customer doesn't have enough money
  return nil if customer.funds < film.price

  # Subtract film price from customer funds and update customer in DB
  customer.funds -= film.price
  customer.update()

  # Create and save the new ticket
  ticket = Ticket.new({
    'customer_id' => customer.id, 
    'film_id' => film.id})
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
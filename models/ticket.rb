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
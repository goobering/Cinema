require_relative '../sql/sql_runner'

class Customer

attr_reader :id
attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i()
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ('#{@name}', '#{@funds}') RETURNING id;"
    customer = SqlRunner.run(sql).first()
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ('#{@name}', '#{@funds}') WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

  def find()
    sql = "SELECT * FROM customers WHERE customers.id = #{@id}"
    customer = SqlRunner.run(sql)
    return Customer.new(customer.first())
  end

  def films()
    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.customer_id = #{@id};"
    result = SqlRunner.run(sql)
    films = result.map { |film| Film.new(film) }
    return films
  end

  def tickets()
    sql = "SELECT * FROM tickets WHERE tickets.customer_id = #{@id}"
    result = SqlRunner.run(sql)
    tickets = result.map { |ticket| Ticket.new(ticket) }
    return tickets
  end

  def num_tickets()
    return tickets().count()
  end

  def screening_tickets()
  end

  def num_screening_tickets()
  end

  def add_funds(amount)
    @funds += amount
    update()
  end

  def subtract_funds(amount)
    @funds -= amount
    update()
  end

  def self.all()
    sql = "SELECT * FROM customers;"
    customers = SqlRunner.run(sql)
    result = customers.map { |customer| Customer.new( customer ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers;"
    SqlRunner.run(sql)
  end

end
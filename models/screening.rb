require 'date'
require_relative '../sql/sql_runner.rb'

class Screening

attr_reader :id
attr_accessor :film_id, :start_time, :capacity

def initialize(options)
  @id = options['id'].to_i
  @film_id = options['film_id'].to_i
  @start_time = DateTime.parse(options['start_time'])# .to_datetime
  @capacity = options['capacity'].to_i
end

def save()
  sql = "INSERT INTO screenings (film_id, start_time, capacity) VALUES ('#{@film_id}', '#{@start_time}', '#{@capacity}') RETURNING id;"
  screening = SqlRunner.run(sql).first()
  @id = screening['id'].to_i
end

def all()
  sql = "SELECT films.title AS Title, screenings.start_time FROM films INNER JOIN screenings on films.id = screenings.film_id;"
  result = SqlRunner.run(sql)
  return result.map { |screening| Screening.new(screening) }
end

def update()
  sql = "UPDATE screenings SET (film_id, start_time, capacity) = ('#{@film_id}', '#{@start_time}', '#{@capacity}') WHERE id = #{@id}"
  SqlRunner.run(sql)
end

def find()
  sql = "SELECT * FROM screenings WHERE screenings.id = #{@id}"
  screenings = SqlRunner.run(sql)
  return Screening.new(screenings.first())
end

def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE tickets.screening_id = #{@id};"
    result = SqlRunner.run(sql)
    customers = result.map { |customer| Customer.new(customer) }
    return customers
end

def num_customers()
  return customers().count()
end

def self.most_popular_screening_time(film)
  return nil if film.screenings() == nil

  highest_customer_num = 0
  best_screening = nil
  for screening in film.screenings
    if screening.num_customers > highest_customer_num
      best_screening = screening
      highest_customer_num = screening.num_customers()
    end
  end

  return best_screening
end

def self.all()
  sql = "SELECT * FROM screenings;"
  result = SqlRunner.run(sql)
  screenings = result.map { |screening| Screening.new(screening) }
  return screenings
end

def self.delete_all()
  sql = "DELETE FROM screenings"
  SqlRunner.run(sql)
end

end
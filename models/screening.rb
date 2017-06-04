require 'date'
require_relative '../sql/sql_runner.rb'

class Screening

def initialize(options)
  @id = options['id'].to_i
  @film_id = options['film_id'].to_i
  @start_time = options['start_time'].to_datetime
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

def num_customers()

end

def most_popular_screening_time(film)

end

def self.all()
  sql = "SELECT * FROM screenings;"
  result = SqlRunner.run(sql)
  screenings = result.map { |screening| Screening.new(screening) }
  return screenings
end

def delete_all()
  sql = "DELETE FROM screenings"
  SqlRunner.run(sql)
end

end
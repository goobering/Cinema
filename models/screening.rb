require 'date'
require_relative '../sql/sql_runner.rb'

class Screening

def initialize(options)
  @id = options['id'].to_i
  @film_id = options['film_id'].to_i
  @start_time = options['start_time'].to_datetime
end

def save()
  sql = "INSERT INTO screenings (film_id, start_time) VALUES ('#{@film_id}', '#{@start_time}') RETURNING id;"
  screening = SqlRunner.run(sql).first()
  @id = screening['id'].to_i
end

def all()
  sql = "SELECT films.title AS Title, screenings.start_time FROM films INNER JOIN screenings on films.id = screenings.film_id;"
  result = SqlRunner.run(sql)
  return result.map { |screening| Screening.new(screening) }
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
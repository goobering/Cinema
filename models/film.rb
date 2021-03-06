require_relative '../sql/sql_runner'

class Film
  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ('#{@title}', '#{@price}') RETURNING id;"
    film = SqlRunner.run(sql).first()
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ('#{@title}', '#{@price}') WHERE id = #{@id}"
    SqlRunner.run(sql)
  end

  def find()
    sql = "SELECT * FROM films WHERE films.id = #{@id}"
    film = SqlRunner.run(sql)
    return Film.new(film.first())
  end

  def screenings()
    sql = "SELECT * FROM screenings WHERE screenings.film_id = #{@id}"
    result = SqlRunner.run(sql)

    return result.map { |screening| Screening.new(screening) }
  end

  def num_screenings()
    return screenings().count()
  end

  def self.all()
    sql = "SELECT * FROM films;"
    result = SqlRunner.run(sql)
    films = result.map { |film| Film.new(film) }
    return films
  end

  def self.delete_all()
    sql = "DELETE FROM films;"
    SqlRunner.run(sql)
  end

end
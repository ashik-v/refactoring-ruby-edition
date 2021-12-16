class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_accessor :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end

  def charge(days_rented)
    result = 0
    case price_code
      when REGULAR
        result += 2
        result += (days_rented - 2) * 1.5 if days_rented > 2
      when NEW_RELEASE
        result += days_rented * 3
      when CHILDRENS
        result += 1.5
        result += (days_rented - 3) * 1.5 if days_rented > 3
    end
    result
  end

  def frequent_renter_points(days_rented)
    (price_code == NEW_RELEASE && days_rented > 1) ? 2 : 1
  end
end


class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def charge
    movie.charge(days_rented)
  end

  def frequent_renter_points
    movie.frequent_renter_points(days_rented)
  end
end

class Customer
  attr_reader :name

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(arg)
    @rentals << arg
  end

  def html_statement
  end

  def statement
    result = "Rental Record for #{@name}\n"
    @rentals.each do |rental|
      # show figures for this rental
      result += "\t" + rental.movie.title + "\t" + rental.charge.to_s + "\n"
    end
    # add footer lines
    result += "Amount owed is #{total_charge}\n"
    result += "You earned #{frequent_renter_points} frequent renter points"
    result
  end

  private

  def total_charge
    @rentals.inject(0) { |sum, rental| sum + rental.charge }
  end

  def frequent_renter_points
    @rentals.inject(0) { |sum, rental| sum + rental.frequent_renter_points }
  end
end
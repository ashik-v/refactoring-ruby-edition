class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_reader :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end

  def regular?
    price_code == Movie::REGULAR
  end

  def new_release?
    price_code == Movie::NEW_RELEASE
  end

  def childrens?
    price_code == Movie::CHILDRENS
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def frequent_renter_points
    if movie.new_release? && days_rented > 1
      2
    else
      1
    end
  end

  def rental_amount
    result = 0

    if movie.regular?
      result += 2
      result += (days_rented - 2) * 1.5 if days_rented > 2
    elsif movie.new_release?
      result += days_rented * 3
    elsif movie.childrens?
      result += 1.5
      result += (days_rented - 3) * 1.5 if days_rented > 3
    end

    result
  end

  def statement_line_item
    "\t#{movie.title}\t#{rental_amount}"
  end
end

class Customer
  attr_reader :name, :rentals

  def initialize(name)
    @name = name
    @rentals = []
  end

  def add_rental(rental)
    @rentals << rental
  end

  def statement
    [
      statement_greeting,
      statement_body,
      statement_sign_off,
    ].join("\n")
  end

  def statement_greeting
    "Rental Record for #{name}"
  end

  def statement_body
    rentals
      .map(&:statement_line_item)
      .join("\n")
  end

  def statement_sign_off
    [
      "Amount owed is #{total_amount}",
      "You earned #{total_frequent_renter_points} frequent renter points",
    ].join("\n")
  end

  def total_amount
    rentals.sum(&:rental_amount)
  end

  def total_frequent_renter_points
    rentals.sum(&:frequent_renter_points)
  end
end

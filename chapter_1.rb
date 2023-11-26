class Movie
  REGULAR = 0
  NEW_RELEASE = 1
  CHILDRENS = 2

  attr_reader :title
  attr_reader :price_code

  def initialize(title, price_code)
    @title, @price_code = title, price_code
  end
end

class Rental
  attr_reader :movie, :days_rented

  def initialize(movie, days_rented)
    @movie, @days_rented = movie, days_rented
  end

  def frequent_renter_points
    if movie.price_code == Movie::NEW_RELEASE && days_rented > 1
      2
    else
      1
    end
  end

  def rental_amount
    this_amount = 0
    case movie.price_code
    when Movie::REGULAR
      this_amount += 2
      this_amount += (days_rented - 2) * 1.5 if days_rented > 2
    when Movie::NEW_RELEASE
      this_amount += days_rented * 3
    when Movie::CHILDRENS
      this_amount += 1.5
      this_amount += (days_rented - 3) * 1.5 if days_rented > 3
    end
    this_amount
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

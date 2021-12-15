require 'minitest/autorun'
require_relative 'movie'

class MovieTest < Minitest::Test
  def setup
    @customer = Customer.new("ashik")
    @regular_movie = Movie.new("waking life", 0)
    @new_release_movie = Movie.new("dune", 1)
    @childrens_movie = Movie.new("frozen", 2)
    @long_term = 7
    @short_term = 1
  end

  def test_customer_name
    assert_equal "ashik", @customer.name
  end

  def test_rental_movie_and_days_rented
    rental = Rental.new(@regular_movie, @long_term)

    assert_equal @regular_movie, rental.movie
    assert_equal @long_term, rental.days_rented
  end

  def test_regular_movie_title_and_regular_price_code
    assert_equal "waking life", @regular_movie.title
    assert_equal 0, @regular_movie.price_code
  end

  def test_statement_regular_movie_short_term
    short_rental = Rental.new(@regular_movie, @short_term)
    @customer.add_rental(short_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \twaking life\t2
      Amount owed is 2
      You earned 1 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end

  def test_statement_regular_movie_long_term
    long_rental = Rental.new(@regular_movie, @long_term)
    @customer.add_rental(long_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \twaking life\t9.5
      Amount owed is 9.5
      You earned 1 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end

  def test_statement_childrens_movie_short_term
    short_rental = Rental.new(@childrens_movie, @short_term)
    @customer.add_rental(short_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \tfrozen\t1.5
      Amount owed is 1.5
      You earned 1 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end

  def test_statement_childrens_movie_long_term
    long_rental = Rental.new(@childrens_movie, @long_term)
    @customer.add_rental(long_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \tfrozen\t7.5
      Amount owed is 7.5
      You earned 1 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end

  def test_statement_new_release_movie_short_term
    short_rental = Rental.new(@new_release_movie, @short_term)
    @customer.add_rental(short_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \tdune\t3
      Amount owed is 3
      You earned 1 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end

  def test_statement_new_release_movie_long_term
    long_rental = Rental.new(@new_release_movie, @long_term)
    @customer.add_rental(long_rental)

    expected_statement = <<~HEREDOC.chomp
      Rental Record for ashik
      \tdune\t21
      Amount owed is 21
      You earned 2 frequent renter points
    HEREDOC

    assert_equal expected_statement,@customer.statement
  end
end
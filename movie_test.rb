require 'minitest/autorun'
require_relative 'app'

class MovieTest < Minitest::Test
  def setup
    @customer = Customer.new("ashik")
    @regular_movie = Movie.new("waking life", RegularPrice.new)
    @new_release_movie = Movie.new("dune", NewReleasePrice.new)
    @childrens_movie = Movie.new("frozen", ChildrensPrice.new)
    @long_term = 7
    @short_term = 1
  end

  def test_statement_regular_movie_short_term
    short_rental = Rental.new(@regular_movie, @short_term)
    @customer.add_rental(short_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      waking life 2
      Amount owed is 2
      You earned 1 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_regular_movie_long_term
    long_rental = Rental.new(@regular_movie, @long_term)
    @customer.add_rental(long_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      waking life 9.5
      Amount owed is 9.5
      You earned 1 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_childrens_movie_short_term
    short_rental = Rental.new(@childrens_movie, @short_term)
    @customer.add_rental(short_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      frozen 1.5
      Amount owed is 1.5
      You earned 1 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_childrens_movie_long_term
    long_rental = Rental.new(@childrens_movie, @long_term)
    @customer.add_rental(long_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      frozen 7.5
      Amount owed is 7.5
      You earned 1 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_new_release_movie_short_term
    short_rental = Rental.new(@new_release_movie, @short_term)
    @customer.add_rental(short_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      dune 3
      Amount owed is 3
      You earned 1 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_new_release_movie_long_term
    long_rental = Rental.new(@new_release_movie, @long_term)
    @customer.add_rental(long_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      dune 21
      Amount owed is 21
      You earned 2 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def test_statement_adds_multiple_movies
    long_rental = Rental.new(@regular_movie, @long_term)
    short_rental = Rental.new(@new_release_movie, @short_term)
    @customer.add_rental(long_rental)
    @customer.add_rental(short_rental)
    expected_statement = <<~HEREDOC
      Rental Record for ashik
      waking life 9.5
      dune 3
      Amount owed is 12.5
      You earned 2 frequent renter points
    HEREDOC

    statement = @customer.statement

    assert_same_string expected_statement, statement
  end

  def assert_same_string(expected, actual)
    assert_equal normalize_whitespace(expected), normalize_whitespace(actual)
  end

  def normalize_whitespace(string)
    string.gsub(/\s+/, " ").strip
  end
end
require_relative 'chapter_1'
require 'active_support/all'

describe "Customer" do
  it "generates a statement" do
    customer = Customer.new('Ashik')
    customer.add_rental(build_rental('Dune 2', Movie::NEW_RELEASE, days_rented: 1))
    customer.add_rental(build_rental("Chinatown", Movie::REGULAR, days_rented: 2))
    customer.add_rental(build_rental("Toy Story", Movie::CHILDRENS, days_rented: 3))
    expected_statement = <<~STATEMENT
      Rental Record for Ashik
         Dune 2  3
         Chinatown 2
         Toy Story 1.5
       Amount owed is 6.5
       You earned 3 frequent renter points
    STATEMENT

    statement = customer.statement

    expect(statement.squish).to eq(expected_statement.squish), statement
  end

  it "generates a statement for a regular movie greater than 2 days" do
    customer = Customer.new('Ashik')
    customer.add_rental(build_rental("Chinatown", Movie::REGULAR, days_rented: 3))
    expected_statement = <<~STATEMENT
      Rental Record for Ashik
         Chinatown 3.5
       Amount owed is 3.5
       You earned 1 frequent renter points
    STATEMENT

    statement = customer.statement

    expect(statement.squish).to eq(expected_statement.squish), statement
  end

  it "generates a statement for a childrens movie greater than 2 days" do
    customer = Customer.new('Ashik')
    customer.add_rental(build_rental("Toy Story", Movie::CHILDRENS, days_rented: 4))
    expected_statement = <<~STATEMENT
      Rental Record for Ashik
         Toy Story 3.0
       Amount owed is 3.0
       You earned 1 frequent renter points
    STATEMENT

    statement = customer.statement

    expect(statement.squish).to eq(expected_statement.squish), statement
  end

  it "gives a bonus for a new release rental of two days or more" do
    customer = Customer.new('Ashik')
    customer.add_rental(build_rental("Dune 2", Movie::NEW_RELEASE, days_rented: 3))
    expected_statement = <<~STATEMENT
      Rental Record for Ashik
         Dune 2 9
       Amount owed is 9
       You earned 2 frequent renter points
    STATEMENT

    statement = customer.statement

    expect(statement.squish).to eq(expected_statement.squish), statement
  end

  def build_rental(title, price_code, days_rented:)
    movie = Movie.new(title, price_code)
    Rental.new(movie, days_rented)
  end
end
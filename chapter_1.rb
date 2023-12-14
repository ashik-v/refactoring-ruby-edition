require 'forwardable'

class RegularRate
	def amount(days_rented)
		if days_rented > 2
			2 + (days_rented - 2) * 1.5
		else
			2
		end
	end
end

class NewReleaseRate
	def amount(days_rented)
		days_rented * 3
	end
end

class ChildrensRate
	def amount(days_rented)
		if days_rented > 3
			1.5 + (days_rented - 3) * 1.5
		else
			1.5
		end
	end
end

class Movie
	REGULAR = RegularRate.new
	NEW_RELEASE = NewReleaseRate.new
	CHILDRENS = ChildrensRate.new
	
	attr_reader :title
	attr_reader :price_code
	
	def initialize(title, price_code)
		@title, @price_code = title, price_code
	end

	def rate(days_rented)
		price_code.amount(days_rented)
	end
end

class Rental
	attr_reader :movie, :days_rented
	
	def initialize(movie, days_rented)
		@movie, @days_rented = movie, days_rented
	end

	def amount
		movie.rate(days_rented)
	end

	def frequent_renter_points
		if movie.price_code == Movie::NEW_RELEASE && days_rented > 1
			2
		else
			1
		end
	end
end


class Customer
	attr_reader :name, :rentals
	
	def initialize(name)
		@name = name
		@rentals = []
	end
	
	def add_rental(arg)
		@rentals << arg
	end
	
	def statement
		Statement.generate_for(self)
	end

	def total_amount
		rentals.sum(&:amount)
	end

	def frequent_renter_points
		rentals.sum(&:frequent_renter_points)
	end
end

class Statement
	extend Forwardable

	def self.generate_for(customer)
		new(customer).generate
	end

	attr_reader :customer
	def_delegators :customer, :rentals, :name, :total_amount, :frequent_renter_points

	def initialize(customer)
		@customer = customer
	end

	def generate
		[
			title,
			body,
			footer
		].join("\n")
	end

	def title
		"Rental Record for #{name}"
	end

	def body
		rentals.map do |rental|
			line_item_for(rental)
		end.join("\n")
	end

	def line_item_for(rental)
		"\t" + rental.movie.title + "\t" + rental.amount.to_s
	end

	def footer
		"Amount owed is #{total_amount}\n" +
			"You earned #{frequent_renter_points} frequent renter points"
	end
end

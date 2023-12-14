class RegularRate
	def amount(days_rented)
		result = 0
		result += 2
		result += (days_rented - 2) * 1.5 if days_rented > 2
		result
	end
end

class NewReleaseRate
	def amount(days_rented)
		days_rented * 3
	end
end

class ChildrensRate
	def amount(days_rented)
		result = 0
		result += 1.5
		result += (days_rented - 3) * 1.5 if days_rented > 3
		result
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

	def rental_amount(days_rented)
		price_code.amount(days_rented)
	end
end

class Rental
	attr_reader :movie, :days_rented
	
	def initialize(movie, days_rented)
		@movie, @days_rented = movie, days_rented
	end

	def amount
		movie.rental_amount(days_rented)
	end

	def frequent_renter_points
		# add bonus for a two day new release rental
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
		result = "Rental Record for #{@name}\n"
		rentals.each do |rental|
			# show figures for this rental
			result += "\t" + rental.movie.title + "\t" + rental.amount.to_s + "\n"
		end
		#add footer lines
		result += "Amount owed is #{total_amount}\n"
		result += "You earned #{frequent_renter_points} frequent renter points"
		
		result
	end

	def total_amount
		rentals.sum(&:amount)
	end

	def frequent_renter_points
		rentals.sum(&:frequent_renter_points)
	end
end
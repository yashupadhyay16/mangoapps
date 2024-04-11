require_relative 'movie'
require_relative 'booking_system'

def display_menu
  puts "\nWelcome to the Movie Ticket Booking System!"
  puts "What would you like to do?"
  puts "1. View available movies"
  puts "2. Book a ticket"
  puts "3. Display available seats"
  puts "4. Cancel a ticket"
  puts "5. Exit"
end

def view_available_movies
  @booking_system.available_movies
end

def booking_system_movie(movie_id)
  @booking_system.movies.find {|movie| movie.id == movie_id }
end

def is_valid_movie?(movie_id)
  if movie_id < 0 || movie_id > @booking_system.movies.length
    puts "Invalid movie number. Please try again."
    return false
  end

  true
end

def is_valid_show_time?(timing_index, movie_id)
  if timing_index < 0 || timing_index >= booking_system_movie(movie_id).show_timings.length
    puts "Invalid show timing number. Please try again."
    return false
  end

  true
end

def book_ticket
  view_available_movies
  print "Enter the movie number: "
  movie_id = gets.chomp.to_i
  return unless is_valid_movie?(movie_id)

  @booking_system.available_show_timings(movie_id)
  print "Enter the show timing number: "
  timing_index = gets.chomp.to_i - 1
  return unless is_valid_show_time?(timing_index, movie_id)

  @booking_system.book_ticket(timing_index, movie_id)
end

def cancel_ticket
  unless @booking_system.bookings.empty?
    @booking_system.booked_seats
    print "Enter booking number to cancel the ticket: "
    booking_id = gets.chomp
    @booking_system.cancel_ticket(booking_id)
  else
    puts "No booking found"
  end
end

def display_available_seats
  view_available_movies
  print "Enter the movie number: "
  movie_id = gets.chomp.to_i
  return unless is_valid_movie?(movie_id)

  @booking_system.available_show_timings(movie_id)
  print "Enter the show timing number: "
  timing_index = gets.chomp.to_i - 1
  return unless is_valid_show_time?(timing_index, movie_id)

  booking_system_movie(movie_id).display_available_seats(timing_index)  
end

@booking_system = BookingSystem.new

# Adding sample movies
movie1 = Movie.new(1, "The Matrix", "Action", ["10:00 AM", "1:00 PM", "4:00 PM"], 50)
movie2 = Movie.new(2, "Inception", "Sci-Fi", ["11:00 AM", "2:00 PM", "5:00 PM"], 60)

@booking_system.add_movie(movie1)
@booking_system.add_movie(movie2)

loop do
  display_menu
  print "Enter your choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    view_available_movies
  when 2
    book_ticket
  when 3
    display_available_seats
  when 4
    cancel_ticket
  when 5
    puts "Thank you for using the Movie Ticket Booking System. Have a great day!"
    break
  else
    puts "Invalid choice. Please try again."
  end
end

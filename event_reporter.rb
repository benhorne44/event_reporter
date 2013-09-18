require 'csv'

class Queue
  def initialize
    @queue = []
    @attendees = []
  end

  def run
     puts "Welcome to EventReporter!"
    while @command != 'quit'
      printf "enter command:"
      input = gets.chomp
      execute_command(input)
    end
  end

  def execute_command(input)
    parts = input.split(' ')
    @command = parts[0]
    message = parts [1..-1].join(" ")
    case @command
      when 'quit' then puts "Goodbye!"
        exit
      when 'load' then load(message)
      when 'help' then help(message)
      when 'queue' then queue(message)
      when 'find' then find(parts[-2], parts[-1])
      # when 'find' then puts 'hello'
      return self
    end

  end

  def help(input = "")
    @help_list = { "quit" => "Exits the program", 
      "<command>" => "Outputs a description of a given command.",
      "queue count" => "Output the number of records in the current queue.",
      "queue clear" => "Empties the queue.",
      "queue print" => "Print out queue data table.",
      "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
      "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV.",
      "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
    }
    
    if input == ""
      puts "\nHere are your available commands:" 
      @help_list.keys.each do |key|
        puts "\t#{key}"
      end
      puts "Type help 'command' for a more detailed description."
      return @help_list.keys

    else
      puts "\n#{@help_list[input]}"
      return @help_list[input]
    end
  end


  def load(filename="event_attendees.csv")
    if filename == ""
      filename = "event_attendees.csv"
    end
    
    @contents = CSV.read "#{filename}", headers: true, header_converters: :symbol

    puts "Loaded #{@contents.count} rows from #{filename}"   
    return @contents
  end

  def clean_phone_number(phone_number)
    clean_phone = phone_number.tr('^0-9', '')
    # puts clean_phone
    number = clean_phone.length
    if number < 10
      clean_phone = "Invalid Number"
    elsif number == 10
      clean_phone
    elsif number == 11 && phone_number[0] == 1
      clean_phone[1..10]
    elsif number == 11 && phone_number[0] != 1
      clean_phone = "Invalid Number"
    else
      clean_phone = "Invalid Number"
    end
  end



  def format_contents
    last_name_lengths = []
    first_name_lengths = []
    email_lengths = []
    city_lengths = []
    address_lengths = []
    buffer = 8

    @headers = ['last_name', 'first_name', 'email', 'zipcode', 'city', 'state', 'address', 'phone']
    @contents.each do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email_address]
      zipcode = row[:zipcode]
      clean_zipcode = zipcode.to_s.rjust(5, "0")[0..4]
      city = row[:city]
      state = row[:state]
      address = row[:street]

      phone = row[:homephone]
      clean_phone_number = clean_phone_number(phone)

      attendee = [last_name.downcase, first_name.downcase, email, clean_zipcode, city.to_s.downcase, state.to_s.downcase, address, clean_phone_number]
      h = Hash[@headers.zip(attendee)]
      @attendees.push(h)

      # column_widths = [last_name.length, first_name.length, email.length, zipcode.length, city.to_s.length, state.to_s.length, address.length, phone.length]
      # format_column_widths(last_name, first_name, email, clean_zipcode, city, state, address, phone)
          


      last_name_width = [last_name.length]
      last_name_lengths.push(last_name_width)
      ln_max = last_name_lengths.max
      @ln_max = ln_max.first + buffer
      first_name_width = [first_name.length]
      first_name_lengths.push(first_name_width)
      fn_max = first_name_lengths.max
      @fn_max = fn_max.first + buffer
      email_width = [email.length]
      email_lengths.push(email_width)
      e_max = email_lengths.max 
      @e_max = e_max.first + buffer
      city_width = [city.to_s.length]
      city_lengths.push(city_width)
      c_max = city_lengths.max 
      @c_max = c_max.first + buffer
      address_width = [address.to_s.length]
      address_lengths.push(address_width)
      a_max = address_lengths.max 
      @a_max = a_max.first + buffer
     
    end
     puts @ln_max
     puts @fn_max
     puts @e_max
     puts @c_max
     puts @a_max

    # puts @first_name_lengths.max
    # puts ""
  end

  def format_column_widths(last_name, first_name, email, clean_zipcode, city, state, address, phone)

  end

  def sort_queue(attribute)
    @queue = @queue.sort_by{|attendee| attendee[attribute]}
  end

  def queue_print
    puts "Printing Queue"
    # contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol  
    # headers = contents.first.headers.to_a
    puts "#{'LAST NAME'.ljust(@ln_max, ' ')}#{'FIRST NAME'.ljust(@fn_max, ' ')}#{'EMAIL'.ljust(@e_max, ' ')}#{'ZIPCODE'.ljust(13, ' ')}#{'CITY'.ljust(@c_max, ' ')}#{'STATE'.ljust(10, ' ')}#{'ADDRESS'.ljust(@a_max, ' ')}#{'PHONE'.ljust(18, ' ')}"
    @queue.each do |row|
      last_name = row["last_name"]
      first_name = row["first_name"]
      email = row["email"]
      zipcode = row["zipcode"]
      city = row["city"]
      state = row["state"]
      address = row["address"]
      phone = row["phone"]
      buffer = 8
      width = 

      puts "#{last_name.capitalize.ljust(@ln_max, ' ')}\t#{first_name.capitalize.ljust(@fn_max, ' ')}\t#{email.ljust(@e_max, ' ')}\t#{zipcode.ljust(13, ' ')}\t#{city.to_s.capitalize.ljust(@c_max, ' ')}\t#{state.to_s.upcase}\t#{address}\t#{phone}"
    end

  end

  def queue(input)
    parts = input.split(' ')
    attribute =parts[-1]
    message = parts[0..-1].join(" ")
    case message
      when "" then puts "Please specify your command after 'queue'"
      when 'count' then queue_count
      when 'print' then queue_print
      when 'clear' then queue_clear
      when 'print by' then queue_print_by_attribute(attribute)
      when 'save to' then queue_save_to_file(filename)
    end

  end

  def queue_clear
    @queue = []
    puts "The queue is now empty."
    return @queue
  end

  def queue_count
    puts "#{@queue.count}"
    return @queue.count
  end

  def queue_print_by_attribute(attribute)
    sort_queue(attribute)
    queue_print
   
  end

  def clean_criteria(input)
    parts = input.split(' ')
    clean = []
    parts.each do |part|
      next if part.class == Fixnum
      if part.class == String
        clean.push(part.downcase)
      end
    end
    clean_criteria = clean.join(' ')
    

  end



  def find(attribute, criteria)
    @queue = []
    @attendees = []
    format_contents
    clean_criteria = clean_criteria(criteria)
    @attendees.each do |attendee|
      if attendee[attribute] == clean_criteria
        @queue.push(attendee)
      end
    end
    puts "Found #{@queue.count} results for your search."
  end 
end

  q = Queue.new
  q.run






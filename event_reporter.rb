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

  def help(input)
    @help_list = { "quit" => "exits the program", 
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
      puts @help_list[input]
      return @help_list[input]
    end
  end


  def load(filename = "event_attendees.csv")

    if filename == ""
      filename = "event_attendees.csv"
    end
    
    @contents = CSV.read "#{filename}", headers: true, header_converters: :symbol

    puts "Loaded #{@contents.count} rows from #{filename}"   
    # parse_contents(@contents)
    return @contents
  end

  def parse_contents
    @attendees = []
    @headers = ['last_name', 'first_name', 'email', 'zipcode', 'city', 'state', 'address', 'phone']
    @contents.each do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email_address]
      zipcode = row[:zipcode]
      city = row[:city]
      state = row[:state]
      address = row[:street]
      phone = row[:homephone]

      attendee = [last_name, first_name, email, zipcode, city, state, address, phone]
      
      h = Hash[@headers.zip(attendee)]
      @attendees << h
    end
  end

  def queue_print
    puts "Printing Queue"
    # contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol  
    # headers = contents.first.headers.to_a
    puts "LAST NAME\tFIRST NAME\tEMAIL\tZIPCODE\tCITY\tSTATE\tADDRESS\tPHONE"
    @queue.each do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email_address]
      zipcode = row[:zipcode]
      city = row[:city]
      state = row[:state]
      address = row[:street]
      phone = row[:homephone]
      puts "#{last_name}\t#{first_name}\t#{email}\t#{zipcode}\t#{city}\t#{state}\t#{address}\t#{phone}"
    end
  end
  
  def queue(input)

    parts = input.split(' ')
    attribute =parts[-1]
    message = parts[1..-1]
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
    # puts "#{attribute}"
    # @queue[attribute]
    @contents.each do |row|
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email_address]
      zipcode = row[:zipcode]
      city = row[:city]
      state = row[:state]
      address = row[:street]
      phone = row[:homephone]
      puts "#{attribute}"
    end
   
    # sorted_friends = @friends.sort_by{ |friend| friend.screen_name.downcase }

  end

  def clean_criteria(input)
    parts = input.split(' ')
    parts.each do |part|
      next if part.class == Fixnum
      if part.class == String
        part.downcase
      end
      clean_criteria = parts.join(' ')
    end
    

  end

  # def format
    
  # end

  # def column_widths(fields)
  #   widths = {}
  #   fields.each do |field|
  #     widths[field.downcase] = longest_value(field.downcase) + gutter
  #   end
  #   widths
  # end

  # def longest_value(field)
  #   value = []
  #   @queue.each do |person|
  #   value.push(person[field].length)
  #     end
  #     value.max
  # end

  def find(attribute, criteria)
    parse_contents
    
    # clean_criteria = clean_criteria(criteria)
    @attendees.each do |attendee|
      if attendee[attribute] == criteria
        @queue.push(attendee)
      end
    end
    # return self
  end
# @contents[:zipcode] = criteria

 
end

q = Queue.new
# q.run
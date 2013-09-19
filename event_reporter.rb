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
      when 'quit' then puts "\tGoodbye!"
        exit
      when 'load' then load(message)
      when 'help' then help(message)
      when 'queue' then queue(message)
      when 'find' then find(parts[1], parts[2..-1].join(" "))
      return self
    end

  end

  def load(filename="event_attendees.csv")
    if filename == ""
      filename = "event_attendees.csv"
    end
    @queue = []
    @contents = CSV.read "#{filename}", headers: true, header_converters: :symbol

    puts "Loaded #{@contents.count} rows from #{filename}"   
    return @contents
  end

  def help(input = "")
    @help_list = { "quit" => "Exits the program", 
      "<command>" => "Outputs a description of a given command.",
      "queue count" => "Output the number of records in the current queue.",
      "queue clear" => "Empties the queue.",
      "queue print" => "Print out queue data table.",
      "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
      "queue save to file" => "Export the current queue to the specified filename and file type. \n\tSupported filename extensions: csv, txt, json and xml.\n\tex: queue save to eventreporter.txt",
      "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
    }
    
    if input == ""
      puts "\nHere are your available commands:" 
      @help_list.keys.each do |key|
        puts "\t#{key}"
      end
      puts "\tType help 'command' for a more detailed description."
      return @help_list.keys

    else
      puts "\n#{@help_list[input]}"
      return @help_list[input]
    end
  end

  def find(attribute, criteria)
    if @contents.nil?
      puts "\tPlease load a file."
    else
      @queue = []
      @attendees = []
      format_contents
      clean_criteria = clean_criteria(criteria)
      @attendees.each do |attendee|
        if attendee[attribute] == clean_criteria
          @queue.push(attendee)
        end
      end
      puts "\tFound #{@queue.count} results for your search."
    end
  end 

  def format_contents
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

    end
  end

  def clean_phone_number(phone_number)
    clean_phone = phone_number.to_s.tr('^0-9', '')
    # puts clean_phone
    number = clean_phone.length
    if number < 10
      clean_phone = ""
    elsif number == 10
      clean_phone
    elsif number == 11 && phone_number[0] == 1
      clean_phone[1..10]
    elsif number == 11 && phone_number[0] != 1
      clean_phone = ""
    else
      clean_phone = ""
    end
  end

  def queue(input)
    parts = input.split(' ')
    attribute =parts[-1]
    message = parts[0..-1].join(" ")
    output = parts[0..-2].join(" ")
    filename = attribute
    case message
      when "" then puts "\tPlease specify your command after 'queue'"
      when 'count' then queue_count
      when 'print' then queue_print
      when 'clear' then queue_clear
    end
    case output
      when 'print by' then queue_print_by_attribute(attribute)
      when 'save to' then queue_save_to_file(filename)
    end

  end

  def queue_print
    if @contents.nil?
      puts "\tPlease load a file first."
    else
      max_column_width
      puts "Printing Queue"
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
        puts "#{last_name.capitalize.ljust(@ln_max, ' ')}#{first_name.capitalize.ljust(@fn_max, ' ')}#{email.to_s.ljust(@e_max, ' ')}#{zipcode.ljust(13, ' ')}#{city.to_s.ljust(@c_max, ' ')}#{state.to_s.upcase.ljust(10, ' ')}#{address.to_s.ljust(@a_max, ' ')}#{phone.ljust(18, ' ')}"
      end
    end
    return nil
  end

  def max_column_width
    buffer = 8

    ln_values = @queue.collect do |name|
      name['last_name'].to_s.length
    end
    @ln_max = ln_values.max + buffer

    fn_values = @queue.collect do |name|
      name['first_name'].to_s.length
    end
    @fn_max = fn_values.max + buffer

    e_values = @queue.collect do |name|
      name['email'].to_s.length
    end
    @e_max = e_values.max + buffer

    c_values = @queue.collect do |name|
      name['city'].to_s.length
    end
    @c_max = c_values.max + buffer

    a_values = @queue.collect do |name|
      name['address'].to_s.length
    end
    @a_max = a_values.max + buffer

  end

  def queue_clear
    if @contents.nil?
      puts "\tThe queue is already empty. Please load a file."
    else
      @queue = []
      puts "\tThe queue is now empty."
    end
    return @queue
  end

  def queue_count
    puts "\tQueue count = #{@queue.count}"
    return @queue.count
  end

  def queue_format_people
    @people = []
    @queue.each do |row|
      last_name = row["last_name"]
      first_name = row["first_name"]
      email = row["email"]
      zipcode = row["zipcode"]
      city = row["city"]
      state = row["state"]
      address = row["address"]
      phone = row["phone"]

      person = ["#{last_name}", "#{first_name}", "#{email}", "#{zipcode}", "#{city}", "#{state}", "#{address}", "#{phone}"]
      people = CSV.generate do |csv|
        csv << person
      end
      @people.push(people)
    end
  end

  def queue_save_to_file(input)
    if @contents.nil?
      puts "\tThere is nothing to save, please load a file."  
    else
      parts = input.split('.')
      filename = parts[0]
      type = parts[-1]
      queue_format_people
      output_filename = "#{filename}.#{type}"

      puts "\tSaving your file..."
      headers = CSV.generate do |csv|
          csv << @headers
        end
      out = File.open(output_filename, "w")
      out.write(headers)
        @people.each do |person|
          out.write(person)
        end
      out.close
    end
  end


  def sort_queue(attribute)
    @queue = @queue.sort_by{|attendee| attendee[attribute]}
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


end

  q = Queue.new
  # q.run






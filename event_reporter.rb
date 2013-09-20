require 'csv'
require './lib/help_message'
require './lib/find_attribute'
require './lib/format_contents'

class EventReporter
  def initialize
    queue = []
  end

  def run
     puts "Welcome to EventReporter!"
    while @command != 'quit'
      printf "enter command:"
      input = gets.chomp
      execute_command(input)
    end
  end

  def queue
    @queue
  end

  def check_if_file_loaded
    if @contents.nil?
      puts "\tPlease load a file."
    end
  end

  def execute_command(input)
    parts = input.split(' ', 3)
    @command = parts[0]
    message = parts [1, 2].join(" ")
    attribute = parts[1]
    criteria = parts[2]
    send_inputs(message, attribute, criteria)
  end

  def send_inputs(message, attribute, criteria)
    case @command
      when 'quit' then puts "\tGoodbye!"
        exit
      when 'load' then load(message)
      when 'help' then HelpMessage.for(message)
      when 'queue' then queue(message)
      # when 'find' then find(parts[1], parts[2..-1].join(" "))
      when 'find' then find(attribute, criteria)
      return self
    end
  end

  def load(filename="event_attendees.csv")
    queue_clear
    check_filename(filename)
    format_and_save_file_contents(filename)
  end

  def check_filename(filename)
    if filename == ""
      filename = "event_attendees.csv"
    end
  end

  def format_and_save_file_contents(filename)
    contents = CSV.read "#{filename}", headers: true, header_converters: :symbol
    @formatted_contents = FormatContents.new(contents).format_contents
    puts "Loaded #{@formatted_contents.count} rows from #{filename}"   
  end

  def find(attribute, criteria)
    check_if_file_loaded
    FindAttribute.new(attribute, criteria)
  end

  # def find(attribute, criteria)
  #   check_if_file_loaded
  #   # if @contents.nil?
  #   #   puts "\tPlease load a file."
  #   # else
  #     queue = []
  #     @attendees = []
  #     format_contents
  #     clean_criteria = clean_criteria(criteria)
  #     @attendees.each do |attendee|
  #       if attendee[attribute] == clean_criteria
  #         queue.push(attendee)
  #       end
  #     end
  #     puts "\tFound #{queue.count} results for your search."
  #   # end
  # end 

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
    check_if_file_loaded
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
    # end
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
      queue = []
    return queue
  end

  def queue_count
    puts "\tQueue count = #{queue.count}"
    return queue.count
  end

  def queue_format_people
    @people = []
    queue.each do |row|
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
    queue = queue.sort_by{|attendee| attendee[attribute]}
  end


  def queue_print_by_attribute(attribute)
    sort_queue(attribute)
    queue_print
   
  end

  


end

  q = EventReporter.new
  # q.run






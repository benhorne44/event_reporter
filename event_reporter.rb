require 'csv'
# require './lib/help_message'
# require './lib/find_attribute'
# require './lib/format_contents'
# require './lib/queue_class'
# require './lib/printer'
# require './lib/file_saver'
# require './lib/attendees'

require 'pry'
class EventReporter

  def initialize
    @queue = []
  end

  def run
     puts "Welcome to EventReporter!"
    until @command == 'quit'
      printf "enter command:"
      input = gets.chomp
      parse_and_send(input)
    end
  end


  def parse_and_send(input)
    split_input = parse_input(input)
    message = split_input[1, 2].join(' ')
    execute_command(*split_input, message)
  end

  def parse_input(input)
    input.split(' ', 3)
  end

  def execute_command(command, attribute, criteria, message)
binding.pry
    
    case command
      when 'quit' then puts "\tGoodbye!"
      when 'load' then load(message)
      when 'help' then HelpMessage.for(message)
      when 'queue' then parse_and_execute_queue_message(message)
      when 'find' then find_and_load_queue(attribute, criteria)
    end
  end

  def load(filename="event_attendees.csv")
    check_filename(filename)
    formatted_data = load_file_and_format_contents(filename)
    organize_attendees(formatted_data)
  end

  def check_filename(filename)
    if filename == ""
      filename = "event_attendees.csv"
    end
  end

  def load_file_and_format_contents(filename)
    contents = CSV.read "#{filename}", headers: true, header_converters: :symbol
    formatted_contents = FormatContents.new(contents)
    puts "Loaded #{@formatted_contents.count} rows from #{filename}" 
    return formatted_contents  
  end

  def organize_attendees(data)
    @attendees = Attendees.new(data)
  end

  def find_and_load_queue(attribute, criteria)
    @queue = []
    check_if_file_loaded
    found_contents = FindAttribute.for(attribute, criteria, @attendees)
    load_queue(found_contents)
  end

  def check_if_file_loaded
    if @contents.nil?
      puts "\tPlease load a file."
    end
  end


  def load_queue(contents)
    @queue = QueueClass.new(contents)
  end

  def parse_and_execute_queue_message(input)
    parts = input.split(' ')
    attribute =parts[-1]
    message = parts[0..-1].join(" ")
    output = parts[0..-2].join(" ")
    case message
      when "" then puts "\tPlease specify your command after 'queue'"
      when 'count' then @queue.count
      when 'print' then Printer.new(@queue)
      when 'clear' then @queue.clear
    end
    case output
      when 'save to' then FileSaver.new(@queue, attribute)
      when 'print by' then Printer.new(@queue.sort_by(attribute))
    end

  end

end

  q = EventReporter.new
  q.parse_and_send('find first_name john')
  # q.run






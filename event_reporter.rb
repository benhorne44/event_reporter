require 'csv'

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol  

# contents[0] = :last_name
# contents[1] = :first_name
# contents[2] = :email
# contents[3] = :zipcode
# contents[4] = :city
# contents[5] = :state
# contents[6] = :address
# contents[7] = :phone

class Queue
  def initialize
    @queue = []
    # @contents = load(filename)
  end

  def run
     puts "Welcome to EventReporter!"
    while @input != 'quit'
      printf "enter command:"
      input = gets.chomp
      execute_command(input)
    end
  end

  def execute_command(input)
    case input
      when 'quit' then puts "Goodbye!"
        exit
      when 'load' then puts "Enter Filename:"
        input = gets.chomp
        load(input)
      return self
    end
  end

  def load(filename = "event_attendees.csv")
    
    @contents = []
    
    @contents = CSV.open "#{filename}", headers: true, header_converters: :symbol  
    
    @contents.each do |row|
      name = row[:first_name]
    end

  end

  def help
    help_list
  end

  def help_list
    {"quit" => "exits the program", "help" => "outputs a description of given command"}
    # hash
    # output a listing of available commands
    # output a description of command
  end

  def queue_count
    @queue.count
  end

  def queue_clear
    @queue = []
  end

  def queue_print
    # Print out a tab-delimited data table with a header row following this format:
  end

  def queue_print(attribute)
    
  end

  def queue_save_file
    output = File.open(filename, 'w')
  end

end

q = Queue.new
q.run
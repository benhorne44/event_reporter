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
    while @command != 'quit'
      printf "enter command:"
      input = gets.chomp
      execute_command(input)
    end
  end

  def help(input)
    @help_list = { "quit" => "exits the program", 
      "help <command>" => "Outputs a description of a given command.",
      "help list" => "List the available individual commands.",
      "queue count" => "Output the number of records in the current queue.",
      "queue clear" => "Empties the queue.",
      "queue print" => "Print out queue data table.",
      "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
      "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV.",
      "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
    }
    if input == ""
      puts "Please enter a command after 'help', or type 'help list' for more options."
    elsif input == 'list'
      puts "#{@help_list.keys}"
    else
      puts "#{@help_list[input]}"
    end


    # hash
    # output a listing of available commands
    # output a description of command
  end

  def execute_command(input)
    parts = input.split(' ')
    @command = parts[0]
    @message = parts [1..-1].join(" ")

    # if @message == "" && @command != 'help' && @command != 'quit'
    #   puts "Please enter a message with your command."
    case @command
      when 'quit' then puts "Goodbye!"
        exit
      when 'load' then load(@message)
      when 'help' then help(@message)
      when 'queue' then queue(@message)
      return self
    end
  end

  def load(filename)
    if filename == ""
      filename = "event_attendees.csv"
    end
    @contents = CSV.open "#{filename}", headers: true, header_converters: :symbol  
    
    @contents.each do |row|
      first_name = row[:first_name]

      puts first_name
    end

  end

  
  def queue(input)
    case input 
      when "" then puts "Please specify your command after 'queue'"
      when 'count' then puts @queue.count
      when 'print' then 
        @contents.each do |row|
          first_name = row[:first_name]

          puts name
        end
      end

    # def queue_clear
    #   @queue = []
    # end

    # def queue_print
    #   # Print out a tab-delimited data table with a header row following this format:
    # end

    # def queue_print(attribute)
      
    # end

    # def queue_save_file
    #   output = File.open(filename, 'w')
    # end
  end

end

q = Queue.new
q.run
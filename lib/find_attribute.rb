# require './queue'

class FindAttribute

  def initialize(attribute, criteria)
    @attribute = attribute
    @criteria = criteria
  end



  def find(attribute, criteria)
      clean_criteria = clean_criteria(criteria)
      @attendees.each do |attendee|
        if attendee[attribute] == clean_criteria
          queue.push(attendee)
        end
      end
      puts "\tFound #{queue.count} results for your search."
    # end
  end 

  def clean_criteria(criteria)
    parts = criteria.split(' ')
    clean = parts.collect do |part|
      next if part.class == Fixnum
      part.class == String
      part.downcase
    end
    puts clean
    clean_criteria = clean.join(' ')
    return clean_criteria
  end
  # def self.for(attribute, criteria)
  #   puts help_list[message.to_s]
  # end


  # def self.help_list
  #   @help_list = { "quit" => "Exits the program", 
  #     "command" => "Outputs a description of a given command.",
  #     "queue count" => "Output the number of records in the current queue.",
  #     "queue clear" => "Empties the queue.",
  #     "queue print" => "Print out queue data table.",
  #     "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
  #     "queue save to file" => "Export the current queue to the specified filename and file type. 
  #       \n\tSupported filename extensions: csv, txt, json and xml.\n\tex: queue save to event_reporter.txt",
  #     "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
  #   }

  #   @help_list[""] = "\nHere are your available commands:\n#{@help_list.keys.join("\n")}"

  #   @help_list
  # end

  # def self.for(message)
  #   puts help_list[message.to_s]
  # end


end

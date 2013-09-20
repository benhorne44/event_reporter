
class HelpMessage

  def self.help_list
    list = { "quit" => "Exits the program", 
      "command" => "Outputs a description of a given command.",
      "queue count" => "Output the number of records in the current queue.",
      "queue clear" => "Empties the queue.",
      "queue print" => "Print out queue data table.",
      "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
      "queue save to file" => "Export the current queue to the specified filename and file type. 
        \n\tSupported filename extensions: csv, txt, json and xml.\n\tex: queue save to event_reporter.txt",
      "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
    }

    list[""] = "\nHere are your available commands:\n#{@list.keys.join("\n")}"

    list
  end

  def self.for(message)
    puts help_list[message.to_s]
  end

end


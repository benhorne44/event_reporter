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

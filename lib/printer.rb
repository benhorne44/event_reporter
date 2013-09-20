class Printer

  def initialize(queue)
    queue_print(queue)
  end

  def queue_print(queue)
    max_column_width(queue)
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
    return nil
  end

    def max_column_width(queue)
      buffer = 8

      # Split into individual methods for each criteria
      # figure out a loop system to give respective arrays and find max values



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

end  

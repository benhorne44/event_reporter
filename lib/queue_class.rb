class QueueClass

  def initialize(queue)
    @queue = queue
  end

  

  def max_column_width
    buffer = 8

    # TO DO
    # Figure out column widths
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

  def clear
      @queue = []
    return @queue
  end

  def count
    puts "\tQueue count = #{queue.count}"
    return queue.count
  end

   def sort_by(attribute)
    @queue = @queue.sort_by{|attendee| attendee[attribute]}
  end


  

  


  

end

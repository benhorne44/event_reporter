
class FindAttribute

  def self.for(attribute, criteria, attendees)
    clean_criteria = clean_criteria(criteria)
    find_and_load_queue(attribute, clean_criteria, attendees)
  end

  def self.find_and_load_queue(attribute, clean_criteria, attendees)
      found_contents = attendees.select { |attendee| attendee[attribute] == clean_criteria }
      puts "\tFound #{queue.count} results for your search."
    return found_contents
  end 

  def self.clean_criteria(criteria)
    parts = criteria.split(' ')
    clean = parts.collect do |part|
      next if part.class == Fixnum
      part.class == String
      part.downcase
    end
    clean_criteria = clean.join(' ')
  end

end

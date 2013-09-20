class Attendees

  def initialize(attendee_data)
    assign_data_tags_and_create_attendee_hash(attendee_data)
  end

  def assign_data_tags_and_create_attendee_hash(attendee_data)
    tags = ['last_name', 'first_name', 'email', 'zipcode', 'city', 'state', 'address', 'phone', 'reg_date']

    attendee_hash = attendee_data.collect { |row| Hash[tags.zip[row]] }
    return attendee_hash        
  end

end

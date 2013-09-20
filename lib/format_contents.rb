class FormatContents

  def initialize(contents)
    @contents = contents
  end

  def headers
    ['last_name', 'first_name', 'email', 'zipcode', 'city', 'state', 'address', 'phone']
  end


  def format_contents
    formatted_contents = @contents.collect do |row|
      reg_date = row[:regdate]
      first_name = row[:first_name]
      last_name = row[:last_name]
      email = row[:email_address]
      zipcode = row[:zipcode]
      city = row[:city]
      state = row[:state]
      address = row[:street]
      phone = row[:homephone]

      clean_phone_number = clean_phone_number(phone)
      clean_zipcode = zipcode.to_s.rjust(5, "0")[0..4]
      puts clean_phone_number
      [last_name.downcase, first_name.downcase, email, clean_zipcode, city.to_s.downcase, state.to_s.downcase, address, clean_phone_number]
    end
    return formatted_contents
  end

  def clean_phone_number(phone_number)
    clean_phone = phone_number.to_s.tr('^0-9', '')
    number = clean_phone.length
    if number < 10
      clean_phone = "0000000000"
    elsif number == 10
      clean_phone
    elsif number == 11 && phone_number[0] == 1
      clean_phone[1..10]
    elsif number == 11 && phone_number[0] != 1
      clean_phone = "0000000000"
    else
      clean_phone = "0000000000"
    end
  end



end

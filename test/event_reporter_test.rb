require 'minitest'
require 'minitest/autorun'
require './event_reporter'
require 'csv'

class QueueTest < Minitest::Test

  def test_it_exists
    q = Queue.new
    assert_kind_of Queue, q
  end

  # def test_it_is_initial_queue_empty
  #   q = Queue.new
  #   assert_equal [], q
  # end

  def test_it_does_it_load_a_file
    q = Queue.new
    filename = "event_attendees.csv"
    contents = CSV.read "#{filename}", headers: true, header_converters: :symbol

    assert_equal contents, q.load('event_attendees.csv')
  end

  def test_it_does_help_list_produce_a_list_of_commands
    help_list = { "quit" => "exits the program", 
      "<command>" => "Outputs a description of a given command.",
      "queue count" => "Output the number of records in the current queue.",
      "queue clear" => "Empties the queue.",
      "queue print" => "Print out queue data table.",
      "queue print by <attribute>" => "Print the data table sorted by specified attribute.",
      "queue save to <filename.csv>" => "Export the current queue to the specified filename as a CSV.",
      "find" => "Load the queue with all records matching the criteria for the given attribute. \n\t'find <attribute> <criteria>'"
    }
    q = Queue.new
    assert_equal help_list.keys, q.execute_command('help')
  end

  def test_it_does_help_command_produce_a_description_of_specified_command
    help_list = {"queue count" => "Output the number of records in the current queue."}
    q = Queue.new
    assert_equal help_list["queue count"], q.execute_command('help queue count')
  end

  def test_it_does_queue_count_output_number_or_records_in_current_queue
    q = Queue.new
    assert_equal 0, q.queue_count
  end

  def test_it_does_queue_clear_empty_the_current_queue
    q = Queue.new
    assert_equal [], q.queue_clear
  end

end
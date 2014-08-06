require 'miniparser/version'
require 'ostruct'

class Miniparser
  attr_accessor :config_file,
                :return_type

  def initialize config_file, return_type = :open_struct
    @config_file = config_file
    @return_type = return_type
  end

  def parse
    if File.readable? config_file
      import_file
    else
      raise Errno::EACCES, "Can't read the config file: #{config_file}"
    end
  end

  private

  def import_file
    result_object = create_return_object

    # Open the file
    open(config_file) do |f|
      # Looping through each line of the file
      f.each do |line|
        # Getting rid of empty spaces at the beginning and end of the line
        line.strip!

        # Skip the whole line if it's a comment or empty line
        unless is_a_comment?(line) or line.empty?
          # Continue if the line is a variable assignment
          if is_assignment?(line)
            # Extract the data
            variable, value = extract_data(line)

            # Skip if the variable or the value is empty
            # Note: probably we need to check for nil here?
            unless variable.empty? or value.empty?
              result_object[variable.to_sym] = parse_value(value)
            end
          end
        end
      end
    end

    result_object
  end

  # If we have a # sign at the beginning of the line
    # we will consider it a comment
  def is_a_comment? line
    /^\#/.match line
  end

  # If we have some string then an equal sign and then more string
    # we will consider it a variable assignment
  def is_assignment? line
    /\s*=\s*/.match line
  end

  # Split the line into two values cutting it from the first = sign
  def extract_data line
    line.split(/\s*=\s*/, 2)
  end

  # Returns true if it was able to parse it as Float and false if not
  def is_numeric? value
    Float(value) != nil rescue false
  end

  # Returns true if it was able to parse it as Integer and false if not
  def is_integer? value
    Integer(value) != nil rescue false
  end

  # Returns true if the value is detected as boolean and fals if not
  def is_boolean? value
    /(true|yes|on|false|no|off)$/.match value
  end

  # It parses a value to boolean or it will raise an exception
  def to_boolean value
    return true if value == true || value =~ (/(true|yes|on)$/i)
    return false if value == false || value =~ (/(false|no|off)$/i)

    raise ArgumentError.new("Invalid value for Boolean: \"#{value}\"")
  end

  # It parses a value to Integer or Float
  def to_number value
    is_integer?(value) ? Integer(value) : Float(value)
  end

  # This will parse the value, if it's a number, a boolean or a string
  def parse_value value
    if is_numeric? value
      to_number(value)
    elsif is_boolean? value
      to_boolean(value)
    else
      value
    end
  end

  # This create an instance of the return type that we choose to return
  def create_return_object
    case return_type
    when :open_struct
      OpenStruct.new config_file: config_file
    when :hash
      { config_file: config_file }
    end
  end
end

require 'miniparser/version'
require 'ostruct'

class Miniparser

  # Note: The initial idea was to create a sigleton class and to just call
  # Miniparser.parse sending the file but this is turning out to be a bit messy.
  # Analyse the posibility of creating a Miniparse instance instead
  # of being singleton, this will result more object oriented.

  def self.parse config_file, return_type = :open_struct
    if File.readable? config_file
      import_file config_file, return_type
    else
      raise Errno::EACCES, "Can't read the config file: #{config_file}"
    end
  end

  def self.import_file config_file, return_type
    result_object = create_return_object(config_file, return_type)

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
  def self.is_a_comment? line
    /^\#/.match line
  end

  # If we have some string then an equal sign and then more string
    # we will consider it a variable assignment
  def self.is_assignment? line
    /\s*=\s*/.match line
  end

  # Split the line into two values cutting it from the first = sign
  def self.extract_data line
    line.split(/\s*=\s*/, 2)
  end

  # Returns true if it was able to parse it as Float and false if not
  def self.is_numeric? value
    Float(value) != nil rescue false
  end

  # Returns true if it was able to parse it as Integer and false if not
  def self.is_integer? value
    Integer(value) != nil rescue false
  end

  # Returns true if the value is detected as boolean and fals if not
  def self.is_boolean? value
    /(true|yes|on|false|no|off)$/.match value
  end

  # It parses a value to boolean or it will raise an exception
  def self.to_boolean value
    return true if value == true || value =~ (/(true|yes|on)$/i)
    return false if value == false || value =~ (/(false|no|off)$/i)

    raise ArgumentError.new("Invalid value for Boolean: \"#{value}\"")
  end

  # It parses a value to Integer or Float
  def self.to_number value
    is_integer?(value) ? Integer(value) : Float(value)
  end

  # This will parse the value, if it's a number, a boolean or a string
  def self.parse_value value
    if is_numeric? value
      to_number(value)
    elsif is_boolean? value
      to_boolean(value)
    else
      value
    end
  end

  # This create an instance of the return type that we choose to return
  def self.create_return_object config_file, return_type
    case return_type
    when :open_struct
      OpenStruct.new config_file: config_file
    when :hash
      { config_file: config_file }
    end
  end
end

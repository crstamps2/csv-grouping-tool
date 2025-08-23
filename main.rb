# The main executable for the CSV grouping tool.

# By requiring 'fileutils', we get access to helpful file-related methods.
require 'fileutils'

# We need to tell Ruby where to find our service files.
# This adds the 'services' directory to Ruby's load path.
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'services'))

# Now we can require the services we've built.
require 'csv_reader'
require 'csv_writer'
require 'data_processor'

# --- 1. Argument Parsing and Validation ---

# ARGV is an array containing the command-line arguments.
input_path = ARGV[0]
grouping_method_str = ARGV[1]

# Check if the user provided the two required arguments.
unless input_path && grouping_method_str
  puts "❗️ Error: Missing arguments."
  puts "Usage: ruby main.rb <path_to_input.csv> <grouping_method>"
  puts "Example: ruby main.rb ./input1.csv :both"
  exit 1
end

# Check if the input file actually exists.
unless File.exist?(input_path)
  puts "❗️ Error: Input file not found at '#{input_path}'"
  exit 1
end

# Convert the grouping method string (e.g., ":email") into a real symbol (:email).
# Also, validate that it's one of the allowed options.
allowed_methods = [:email, :phone, :both]
grouping_method = grouping_method_str.delete(':').to_sym

unless allowed_methods.include?(grouping_method)
  puts "❗️ Error: Invalid grouping method '#{grouping_method_str}'."
  puts "Allowed methods are: :email, :phone, :both"
  exit 1
end

# --- 2. Define Output Path ---

# Get the directory of the input file.
input_dir = File.dirname(input_path)
# Create the full path for the output file in the same directory.
output_path = File.join(input_dir, 'output.csv')

# --- 3. Execute the Services ---

begin
  puts "▶️ Starting process..."
  
  # Step 1: Read the input CSV.
  puts "   1. Reading data from '#{input_path}'..."
  reader_result = CsvReader.call(input_path)
  initial_data = reader_result[:data]
  original_headers = reader_result[:original_headers]

  if initial_data.empty?
    puts "⚠️  Warning: Input file is empty. No output will be generated."
    exit 0
  end
  
  # Step 2: Process the data.
  puts "   2. Processing data with grouping method ':#{grouping_method}'..."
  processed_data = DataProcessor.call(initial_data, grouping_method)
  
  # Step 3: Write the new data.
  puts "   3. Writing processed data to '#{output_path}'..."
  CSVWriter.call(processed_data, original_headers, output_path)
  
  puts "✅ Success! File has been processed and saved."

rescue StandardError => e
  puts "❗️ An unexpected error occurred: #{e.message}"
  exit 1
end

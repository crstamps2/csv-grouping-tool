# CSV Grouping Tool

This is a command-line tool written in Ruby that processes a CSV file to identify and group records that likely belong to the same entity. It reads an input CSV, adds a unique `id` column to each row, and saves the result to a new `output.csv` file.

The grouping logic can be based on matching email addresses, phone numbers, or both simultaneously. The tool is designed to handle records with multiple email or phone number columns (e.g., `email1`, `email2`).

## Prerequisites

* **Ruby**: You must have Ruby installed on your machine.

## How to Run the Program

You can run the tool from your terminal by navigating to the project's root directory. The script requires two arguments: the path to the input CSV file and the grouping method.

### Command Structure

```
ruby main.rb <path_to_input.csv> <grouping_method>
```

### Arguments

1. **`<path_to_input.csv>`**: The full or relative path to the CSV file you want to process.

2. **`<grouping_method>`**: A symbol indicating how to group records. The available options are:

   * `:email`: Groups records that share any common email address.

   * `:phone`: Groups records that share any common phone number.

   * `:both`: (Default) Groups records that share either a common email OR a common phone number.

### Examples

**Example 1: Grouping by both email and phone**

This command will process `input1.csv` and group records that have either a matching email or a matching phone number.

```
ruby main.rb ./input1.csv :both
```

**Example 2: Grouping by email only**

```
ruby main.rb ./data/customers.csv :email
```

## Output

The program will generate a new file named `output.csv` in the **same directory** as your input file. This new file will contain all the original data plus a new `id` column at the beginning. The original header casing from the input file will be preserved.

## How to Run the Tests

The project includes a full test suite using RSpec.

1. **Install RSpec** (if you haven't already):

   ```ruby
   gem install rspec
   ```

2. **Run the test suite** from the project's root directory:

   ```ruby
   rspec
   ```

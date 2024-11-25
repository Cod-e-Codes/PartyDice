import os

def count_lines_in_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return len(file.readlines())

def count_lines_in_directory(directory):
    total_lines = 0
    for root, dirs, files in os.walk(directory):
        for file in files:
            # Count lines in .dart, .yaml, and .json files (adjust extensions as needed)
            if file.endswith(('.dart', '.yaml', '.json')):
                file_path = os.path.join(root, file)
                total_lines += count_lines_in_file(file_path)
    return total_lines

if __name__ == "__main__":
    # Replace '.' with the path to your Flutter project folder if not running in the project directory
    project_directory = '.'
    total_lines_of_code = count_lines_in_directory(project_directory)
    print(f"Total lines of code: {total_lines_of_code}")
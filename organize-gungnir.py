import os

def read_file(file_path):
    """Reads lines from a file and returns them as a list."""
    with open(file_path, 'r') as file:
        return [line.strip() for line in file]

def find_program(subdomain, program_directories):
    """Finds which program a subdomain belongs to by comparing it to roots.txt files."""
    parts = subdomain.split('.')
    if len(parts) < 2:
        return None
    
    # Create the indices to compare
    indices = [
        '.'.join(parts[-2:]),    # last 2 parts
        '.'.join(parts[-3:]) if len(parts) > 2 else None   # last 3 parts if available
    ]

    for program_dir in program_directories:
        roots_file = os.path.join(program_dir, 'roots.txt')
        if os.path.exists(roots_file):
            root_domains = read_file(roots_file)
            for root_domain in root_domains:
                if root_domain in indices:
                    return program_dir
    return None

def main(subdomains_file, programs_root):
    subdomains = read_file(subdomains_file)
    program_directories = [os.path.join(programs_root, d) for d in os.listdir(programs_root) if os.path.isdir(os.path.join(programs_root, d))]

    for subdomain in subdomains:
        program_dir = find_program(subdomain, program_directories)
        if program_dir:
            # Dynamically set the subdomain file path for each program directory
            output_file = os.path.join(program_dir, 'subdomains.txt')
            with open(output_file, 'a') as file:
                file.write(subdomain + '\n')
            print(f"Subdomain {subdomain} written to {output_file}")
        else:
            print(f"Subdomain {subdomain} does not match any program roots.")

if __name__ == '__main__':
    programs_root = '/home/un1tycyb3r/bugbounty'                # The root directory containing program folders
    subdomains_file = f'{programs_root}/results.txt'  # Path to your subdomains file
    main(subdomains_file, programs_root)



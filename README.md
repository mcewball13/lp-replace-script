# Markdown Content Replacement Script

This script is a utility for replacing content between two specific sections in Markdown files. The script prompts for the starting and ending section titles and the content to replace. The starting and ending titles must be preceded by triple hash (###).

## Installation

To install the script, you need to clone this repository to your local machine and give the script executable permissions.

```bash
git clone https://github.com/username/repo.git
cd repo
chmod +x replace.sh
```

To make the script globally accessible from any location, you can add it to your system's `PATH`. One way to do this is to create a symbolic link to the script in a directory that's already in your `PATH`, like `/usr/local/bin`:

```bash
sudo ln -s absolute/path/to/your/replace.sh /usr/local/bin/replace
```

Now you can run the script from anywhere by typing `replace` in the terminal.

You may need to add the `PATH` to your `.bash_profile`, `.bashrc`, or `.zshrc` file. For example:

```bash
export PATH=$PATH:/usr/local/bin
```

## Usage

To use the script, you can simply run the script from the command line and follow the prompts.

```bash
replace
```

When you run the script, you'll be prompted to:

1. Navigate and select the directory of the files you want to process.
2. Enter the starting section title.
3. Enter the content to replace.
4. Enter the ending section title.

The script will then scan all the Markdown files in the chosen directory and its subdirectories, and replace the content between the starting and ending section titles with the content you specified. The starting and ending section titles will remain intact.

## Notes

- The starting and ending section titles must be unique within each file. If there are multiple sections with the same title, the script will only process the first one.
- The script does not add or remove any lines at the end of the files. If a file does not end with a newline, the script will maintain that.
- The script will provide a warning if the starting or ending title contains "Instructor Do: Stoke Curiosity". If you choose to proceed, it will perform the replacement as usual.
- At the end of its execution, the script provides a count of the total files that were changed and lists out the changed files.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)

# GitHub Repository Access List Script

This shell script lists users with specific access permissions to a GitHub repository using the GitHub API.

## Features

- List users with **maintain**, **push**, **triage**, or **pull** access to a specific GitHub repository.
- Uses colored output to enhance readability.
- Provides a menu-driven interface for ease of use.

## Prerequisites

- **GitHub Personal Access Token**: You need to generate a GitHub Personal Access Token with the appropriate scopes (e.g., `repo`) to access the repository information.
- **`jq`**: The script uses `jq` to parse JSON responses from the GitHub API. Install it using your package manager, for example:
  ```bash
  sudo apt-get install jq
  ```

## Setup

1. **Export GitHub Username and Token**:
   Before running the script, make sure to export your GitHub username and personal access token as environment variables:
   ```bash
   export GITHUB_USERNAME="your_github_username"
   export GITHUB_TOKEN="your_personal_access_token"
   ```

2. **Clone the Repository**:
   Clone this repository to your local machine:
   ```bash
   git clone https://github.com/iam-kishoret/shell-scripts.git
   cd shell-scripts
   ```

3. **Make the Script Executable**:
   If needed, make the script executable:
   ```bash
   chmod +x github_access_list.sh
   ```

## Usage

Run the script with the following command:

```bash
./github_access_list.sh <repo_owner> <repo_name>
```

- **`<repo_owner>`**: The username or organization that owns the repository.
- **`<repo_name>`**: The name of the repository.

### Example

```bash
./github_access_list.sh octocat Hello-World
```

### Script Menu

The script provides a menu to choose the type of access you want to list:

```
***MENU - CHOOSE AN OPTION TO LIST THE USERS HAVING GITHUB ACCESS***
====================
1. maintain
2. push
3. triage
4. pull
5. Exit the script
====================
```

After selecting an option, the script will display the list of users with the specified access level. You can then choose to continue searching or exit the script.

### Output Example

```bash
========================================
***** FOUND BELOW LIST OF USERS *****
========================================
Users with push access to octocat/Hello-World:
user1
user2
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or features you'd like to add.

## Support

If you encounter any issues or have questions, feel free to open an issue on GitHub or contact me directly.

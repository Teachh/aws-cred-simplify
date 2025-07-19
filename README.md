# AWS Profile Switcher

This script allows you to quickly switch the `[default]` AWS CLI profile in your `~/.aws/credentials` file to another one of your configured profiles.

It performs the following actions:

1. Checks if a `[default]` profile already exists.
   - If a comment is directly above `[default]`, it assumes it's a previously used profile, uncommenting it and removing `[default]`.
   - If not, it renames `[default]` to `[default-old-<random>]` to preserve the old profile.
2. Lists all available AWS profiles from the credentials file.
3. Prompts you to select one of the available profiles by number.
4. Comments out the selected profile header and creates a new `[default]` entry in its place.

## Requirements

- Bash
- A valid `~/.aws/credentials` file with multiple named profiles.
- Sudo permissions

## Usage

Install the script, make sure to have sudo permissions:

```
sudo bash install.sh
```

## Example Output

```
🎨 Available profiles:
1) [project-dev]
2) [project-prod]
3) [admin-account]

🛠️  Select a profile by number: 2
✨ You selected: [project-prod]
📢 [default] exists in file, renaming it to [default-old-723]
```

## Notes

- This script assumes the AWS credentials file is located at `~/.aws/credentials`.
- It uses inline editing with `sed`, so make sure you have a backup if you're concerned about losing data.

## Troubleshooting

If you see:

```
⛔ Credentials file does not exists in ~/.aws/credentials
```

Ensure you have AWS CLI credentials configured:

```
aws configure --profile your-profile-name
```

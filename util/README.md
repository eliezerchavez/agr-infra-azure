<a name="readme-top"></a>

# Utility Scripts

- [Utility Scripts](#utility-scripts)
  - [Description](#description)
  - [Requirements](#requirements)
  - [Scripts Overview](#scripts-overview)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [Credits](#credits)

---

## Description

The `util` folder contains utility scripts designed to streamline environment setup and Terraform state management. These scripts simplify the process of configuring environment variables and managing Terraform state files, ensuring consistency and reducing manual effort.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Requirements

- **Operating System**: The scripts are compatible with both Windows and Unix-based systems.
- **Shell**:
  - For Windows: PowerShell (recommended version >= 5.1).
  - For Unix-based systems: Bash (recommended version >= 4.0).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Scripts Overview

### `setenv.ps1`

This PowerShell script is used to configure environment variables required for Terraform operations. It ensures that all necessary variables are set correctly before running Terraform commands.

#### Key Features:
- Sets environment variables such as `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, and `ARM_TENANT_ID` for Azure authentication.
- Validates the presence of required variables and prompts the user if any are missing.
- Supports customization by allowing users to define additional variables as needed.

#### Example Usage:
```powershell
# Run the script to set environment variables
.\setenv.ps1

# Verify that the variables are set
Get-ChildItem Env: | Where-Object { $_.Name -like "ARM_*" }
```

---

### `setenv.sh`

This Bash script serves the same purpose as `setenv.ps1` but is designed for Unix-based systems. It configures environment variables required for Terraform operations and ensures compatibility with Azure authentication.

#### Key Features:
- Exports environment variables such as `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, and `ARM_TENANT_ID`.
- Includes error handling to check for missing variables and provides instructions for setting them.
- Allows users to extend the script by adding custom variables.

#### Example Usage:
```bash
# Make the script executable
chmod +x setenv.sh

# Run the script to set environment variables
./setenv.sh

# Verify that the variables are set
env | grep ARM_
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Usage

To use the utility scripts, follow these steps:

1. Ensure that the required tools (PowerShell or Bash) are installed on your system.
2. Navigate to the `util` folder in your terminal or PowerShell.
3. Run the appropriate script for your operating system:
   - For Windows: `setenv.ps1`
   - For Unix-based systems: `setenv.sh`
4. Verify that the environment variables have been set correctly by using the provided commands in the script examples.

These scripts are particularly useful when working with Terraform configurations that require Azure authentication. They help avoid manual errors and ensure a consistent setup across different environments.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Contributing

Contributions to improve the utility scripts or documentation are welcome. Please open an issue or submit a pull request with your suggestions. Ensure that your changes are tested on both Windows and Unix-based systems.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## Credits

- [Eliezer Chavez](https://github.com/eliezerchavez) - _Initial Work, Documentation_

<p align="right">(<a href="#readme-top">back to top</a>)</p>
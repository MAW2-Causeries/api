# Causerie Messages Service API
## Description

This project is a Ruby on Rails API designed to manage messages for the Causerie application.

## Getting Started

### Prerequisites

- Ruby 3.4.7 or higher
- Rails 8.1.3 or higher

### Configuration

```shell
bundle # it will install the gems specified in the Gemfile
rails db:migrate # it will run the database migrations
```

### On dev environment

#### Local deployment

```shell
bin/dev
# or
rails server
```

#### Running tests

```shell
rails test # it will run the tests
```

#### Running linters

```shell
rubocop # it will run the rubocop linter
```

### On integration environment

TODO

PS: i didn't deploy it yet, but i will deploy it soon.

### Setting Up ScyllaDB
#### Docker Installation (Recommended)

To set up a ScyllaDB instance using Docker, run the following command:
```bash
docker run -d --name scylla \                                           
  -p 9042:9042 \      
  -e SCYLLA_PASSWORD=your_password \
  -e SCYLLA_USER=your_username \
  scylladb/scylla
```
You can create a keyspace and the software will automatically create the necessary tables on startup.
```sql
CREATE KEYSPACE app WITH replication = {'class': 'NetworkTopologyStrategy', 'replication_factor': 1 };
```

#### Local Installation

Follow the instructions on the [ScyllaDB official website](https://www.scylladb.com/download/) to install ScyllaDB locally.

## Directory structure

```bash
.
├── app/                  # Application code
│   ├── controllers/      # Controllers for handling API requests
│   │   └── api/          # API controllers
│   ├── models/           # Data models and database interactions
│   ├── helpers/          # Helper functions and utilities
│   └── jobs/             # Background jobs and workers
├── config/               # Configuration files
│   ├── initializers/     # Initializer scripts for setting up the application
│   ├── environments/     # Environment-specific configuration files (e.g., development, production)
│   └── locales/          # Localization files for internationalization (i18n)
├── db/                   # Database-related files
│   └── migrate/          # Database migration scripts
├── lib/                  # Custom libraries and modules
├── test/                 # Test files and test-related resources
│   ├── controllers/      # Tests for controllers
│   ├── models/           # Tests for models
│   └── fixtures/         # Test fixtures and sample data
├── Dockerfile            # Dockerfile for containerizing the application
├── Gemfile               # Gemfile for managing Ruby dependencies
├── README.md             # Project documentation
└── config.ru             # Rack configuration file for the application
```

## Collaborate
### Commit Guidelines

Use conventional commit messages to describe your changes. 
- https://www.conventionalcommits.org/en/v1.0.0/
- https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13#file-conventional-commits-cheatsheet-md

Current commit types include:
Changes relevant to the API or UI:
- `feat`: Commits that add, adjust or remove a new feature to the API or UI
- `fix`: Commits that fix an API or UI bug of a preceded feat commit
- `refactor`: Commits that rewrite or restructure code without altering API or UI behavior
- `perf`: Commits are special type of refactor commits that specifically improve performance
- `style`: Commits that address code style (e.g., white-space, formatting, missing semi-colons) and do not affect application behavior
- `test`: Commits that add missing tests or correct existing ones
- `docs`: Commits that exclusively affect documentation
- `build`: Commits that affect build-related components such as build tools, dependencies, project version, ...
- `ops`: Commits that affect operational aspects like infrastructure (IaC), deployment scripts, CI/CD pipelines, backups, monitoring, or recovery procedures, ...
- `chore`: Commits that represent tasks like initial commit, modifying .gitignore, ...

### How to propose a new feature (issue, pull request)

1. Create an issue describing the feature you want to propose, including the problem it solves and any relevant details.
2. If you want to implement the feature yourself, create a new branch from the main branch and name it appropriately (e.g., `feature/new-feature-name`) or fork the repository if you don't have write access to the main repository.
3. Implement the feature in your branch, following the commit guidelines for any commits you make.
4. Once your implementation is complete, push your branch to the repository and create a pull request (PR) against the main branch.

### Branching Strategy

We follow a simple branching strategy:
- `main`: The main branch contains the stable codebase that is ready for production.
- `feature/*`: Feature branches are created for developing new features or making significant changes. They are merged back into the main branch once the feature is complete and has been reviewed.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
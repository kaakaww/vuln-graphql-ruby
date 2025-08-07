# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a vulnerable Ruby GraphQL application designed for security testing with StackHawk's HawkScan. It's a Rails 6.0 application using Ruby 2.7.8 that implements a GraphQL API for managing links, users, and votes.

## Architecture

The application follows standard Rails conventions with a GraphQL layer:

- **Rails Application**: Located in `app/` directory using Rails 6.0.2.1
- **GraphQL Schema**: Defined in `app/app/graphql/graphql_tutorial_schema.rb`
- **GraphQL Types**: Located in `app/app/graphql/types/` - includes base types, link, user, vote types
- **Mutations**: Located in `app/app/graphql/mutations/` - handles create operations for links, users, votes, and authentication
- **Resolvers**: Located in `app/app/graphql/resolvers/` - complex query logic, particularly search functionality
- **Models**: Standard Rails models in `app/app/models/` - User, Link, Vote, AuthToken
- **Controllers**: `app/app/controllers/graphql_controller.rb` serves as the GraphQL API endpoint
- **Database**: SQLite3 with migrations in `app/db/migrate/`
- **Tests**: Located in `app/test/` using Rails minitest framework with FactoryBot

## Common Development Commands

### Local Development (within app/ directory)
```bash
# Install dependencies
bundle install

# Setup database
rails db:setup

# Start development server
rails server

# Run tests
rails test

# Access GraphQL playground
open http://localhost:3000/graphiql
```

### Docker Development
```bash
# Build the application
docker-compose build
# or
docker build -t stackhawk/vuln-graphql-ruby .

# Run the application
docker-compose up
# or
docker run --name gql-ruby --rm -ti -p 3000:3000 stackhawk/vuln-graphql-ruby
```

### Security Scanning
```bash
# Run StackHawk security scan (requires AUTH_TOKEN file)
./run_hawkscan.sh

# Manual HawkScan execution
source ./AUTH_TOKEN && docker run -e APP_HOST=http://127.0.0.1:3000 --rm -v $(pwd):/hawk:rw -ti --name hawkscan stackhawk/hawkscan:latest example-stackhawk-config.yml
```

## Key Files and Structure

- `app/app/controllers/graphql_controller.rb` - Main GraphQL API endpoint
- `app/app/graphql/graphql_tutorial_schema.rb` - GraphQL schema definition
- `app/app/graphql/types/query_type.rb` - Root queries including allLinks search
- `app/app/graphql/types/mutation_type.rb` - Root mutations
- `app/app/graphql/resolvers/links_search.rb` - Complex search functionality with filtering
- `app/config/application.rb` - Rails configuration with CORS enabled for all origins
- `example-stackhawk-config.yml` - StackHawk security scanning configuration
- `docker-entrypoint.sh` - Container startup script

## GraphQL API

The application exposes a GraphQL endpoint at `/graphql` with:

### Key Queries
- `allLinks` - Search and filter links with pagination
- User and vote data through link relationships

### Key Mutations  
- `createUser` - User registration with email/password
- `signinUser` - Authentication returning JWT token
- `createLink` - Create new links (requires authentication)
- `createVote` - Vote on links (requires authentication)

### Authentication
Uses JWT tokens via `Authorization` header. Tokens are generated through `signinUser` mutation.

## Security Context

This is intentionally vulnerable application for security testing. The CORS configuration allows all origins (`origins '*'`) and the application may contain other security vulnerabilities by design for testing purposes.
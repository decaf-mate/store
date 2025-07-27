# Store

A toy store application.

## Assumptions

This projects solves only the problems proposed. Which the reading of author was *how to structure discounts in a way that it can scale* and *money conversion without losing money*.

It doesn't tries to solve a miriad of problems that comes with building an ecommerce.

- Stock
- Product Variants
- Multi Currency
- Cart project

## Prerequisites

### Option 1: Native Development (without Docker)

Choose one of the following version managers:

#### Using asdf
- [asdf](https://asdf-vm.com/) version manager
- Install required plugins:
  ```bash
  asdf plugin add erlang
  asdf plugin add elixir
  ```

#### Using mise
- [mise](https://mise.jdx.dev/) version manager
- Install required plugins:
  ```bash
  mise plugin install erlang
  mise plugin install elixir
  ```

### Option 2: Docker Development

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup & Running

### Native Development (without Docker)

1. **Install dependencies using your chosen version manager:**

   **With asdf:**
   ```bash
   asdf install
   ```

   **With mise:**
   ```bash
   mise install
   ```

2. **Get dependencies:**
   ```bash
   mix deps.get
   ```

3. **Compile the project:**
   ```bash
   mix compile
   ```

4. **Run tests:**
   ```bash
   mix test
   ```

5. **Start interactive Elixir shell:**
   ```bash
   iex -S mix
   ```

### Docker Development

1. **Start the application:**
   ```bash
   docker-compose up
   ```
   This will:
   - Pull the Elixir 1.18.3 image
   - Install dependencies
   - Compile the project
   - Start an interactive Elixir shell

2. **Run tests in Docker:**
   ```bash
   docker-compose exec store mix test
   ```

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

4. **Rebuild if needed:**
   ```bash
   docker-compose up --build
   ```

## Usage

Once the application is running (either natively or in Docker), you can test it:

```elixir
iex> Store.hello()
:world
```

## Development

- **Version Management:** This project uses asdf or mise with versions specified in `.tool-versions`
- **Elixir Version:** 1.18.3
- **Erlang/OTP Version:** 27.1.2
- **CI/CD:** GitHub Actions automatically runs tests and format checks on push/PR

### Running Tests

**Native:**
```bash
mix test
```

**Docker:**
```bash
docker-compose exec store mix test
```

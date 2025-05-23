# Define global arguments
ARG ELIXIR_VERSION=1.14
ARG BUILDER_IMAGE="elixir:${ELIXIR_VERSION}-slim"
ARG RUNNER_IMAGE="debian:bookworm-slim"

FROM ${BUILDER_IMAGE} AS builder

# Install build dependencies
RUN apt-get update -y && \
    apt-get install -y build-essential git curl libpq-dev \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set up build environment
ARG MIX_ENV="prod"
ENV MIX_ENV=${MIX_ENV}

WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy application source
COPY . .

# Fetch and compile dependencies
RUN mix deps.get --only prod
RUN mix deps.compile

# Compile assets (if any - typically handled by esbuild in newer Phoenix)
# If you have custom asset build steps, add them here.
# Example for esbuild (if configured in mix.exs assets.deploy):
# RUN mix assets.deploy

# Compile the application
RUN mix compile

# Generate the release
RUN mix release

# --- Runner Stage ---
FROM ${RUNNER_IMAGE}

ARG MIX_ENV="prod"
ENV MIX_ENV=${MIX_ENV}
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install runtime dependencies
RUN apt-get update -y && \
    apt-get install -y libssl-dev libpq5 openssl \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

WORKDIR /app

# Copy the release from the builder stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/chat_app ./

# Set user
USER nobody

# Expose port (as defined in config/prod.exs or endpoint.ex)
EXPOSE 4000

# Define the entrypoint
ENTRYPOINT ["/app/bin/chat_app"]

# Define the default command (e.g., start the server)
CMD ["start"]

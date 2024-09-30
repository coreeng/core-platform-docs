FROM alpine:3.20

# The Hugo version
ARG HUGO_VERSION=0.132.1

# Add a non-root user
RUN addgroup -S hugo && adduser -S -G hugo hugo

# Download and extract Hugo
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz && \
    rm -f hugo.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    chmod +x /usr/local/bin/hugo

# We add git to the build stage, because Hugo needs it with --enableGitInfo
# hadolint ignore=DL3018
RUN apk add --no-cache git

# Set the working directory
WORKDIR /site

# Copy the source files
COPY . .

# Run the linter, but don't add it to the build
RUN apk add --no-cache npm && \
    npm install markdownlint-cli2 --global && \
    markdownlint-cli2 && \
    npm uninstall markdownlint-cli2 --global && \
    apk del npm

# Set ownership and permissions
RUN chown -R hugo:hugo /site

# Set the non-root user
USER hugo

# Run Hugo
ENTRYPOINT ["/site/run.sh"]

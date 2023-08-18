FROM cecg/knowledge-platform

COPY logo.png /site/static/images/logo.png
COPY content/cecg-idp content/cecg-idp
COPY config.toml /site/

FROM cecg/knowledge-platform

COPY images/  /site/static/images/
COPY content/cecg-idp content/cecg-idp
COPY config.toml /site/
COPY layouts/shortcodes/* /site/layouts/shortcodes/
COPY data/* /site/data/
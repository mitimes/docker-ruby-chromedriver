FROM ruby:2.6.5-slim

# Install dependencies:
# - build-essential: To ensure certain gems can be compiled
# - nodejs: Compile assets
# - libpq-dev: Communicate with postgres through the postgres gem
# - postgresql-client-9.4: In case you want to talk directly to postgres
# - gnupg2: needed to get google.com key
# - locales: set the locale for brakeman
# - libcurl4: needed by amplitude-api gem
RUN \
  apt-get update && \
  apt-get install -qq -y \
    build-essential \
    git \
    wget \
    unzip \
    nodejs \
    libpq-dev \
    gnupg2 \
    locales \
    libcurl4 \
    --fix-missing --no-install-recommends

# All these additional things to get capybara with chromedriver running...
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# chrome is 85.0.4183.83
RUN \
 apt-get update && \
 apt-get install -qq -y \
   google-chrome-stable xvfb \
     --fix-missing --no-install-recommends

RUN \
  cd /usr/local/bin && \
  wget https://chromedriver.storage.googleapis.com/85.0.4183.83/chromedriver_linux64.zip && \
  unzip chromedriver_linux64.zip && \
  chmod a+x chromedriver

# set the locale for brakeman
RUN set -ex && \
    apt-get update -qq && apt-get install -y -qq locales && \
    echo "en_US UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM ruby:2.6.4-slim

RUN set -ex && \
    apt-get update && \
    apt-get install -qq -y \
      build-essential \
      gnupg2 \
      git \
      wget \
      unzip \
      nodejs \
      libpq-dev \
      --fix-missing --no-install-recommends && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
      >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && \
    apt-get install -qq -y \
      google-chrome-stable \
      xvfb \
      --fix-missing --no-install-recommends

RUN set -ex && \
    cd /usr/local/bin && \
    wget https://chromedriver.storage.googleapis.com/77.0.3865.40/chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    chmod a+x chromedriver

# Set the locale for brakeman
RUN set -ex && \
    apt-get update -qq && apt-get install -y -qq locales && \
    echo "en_US UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

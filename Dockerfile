FROM ubuntu:trusty

MAINTAINER https://github.com/reactjs/react-rails

ARG RUBY_VERSION=2.5.0

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      apt-transport-https \
      software-properties-common \
      curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install yarn and nodejs
RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
    echo "deb https://deb.nodesource.com/node_8.x trusty main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src https://deb.nodesource.com/node_8.x trusty main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
      nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | \
      tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
      yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install Google Chrome
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list && \
    apt-get update && \
    apt-get install -y \
      google-chrome-stable && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install RVM
# https://github.com/rvm/ubuntu_rvm
RUN apt-add-repository -y \
      ppa:rael-gc/rvm && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
      rvm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install Ruby via RVM
RUN /bin/bash --login -c \
    "rvm install ${RUBY_VERSION} --disable-binary && \
    rvm use ${RUBY_VERSION} --default"

# update Gems, install chromedriver and update it
RUN /bin/bash --login -c \
    "gem update --system && gem install chromedriver-helper && chromedriver-update"

# copy current app to /srv/app
RUN mkdir /srv/app
COPY . /srv/app

ENTRYPOINT ["/bin/bash","--login"]

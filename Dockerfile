FROM ubuntu:trusty

ARG RUBY_VERSION=2.5.0

RUN apt-get update && \
    apt-get install -y \
     curl && \
    apt-get clean

# install yarn and nodejs
RUN apt-key adv --fetch-keys http://dl.yarnpkg.com/debian/pubkey.gpg &&\
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | \
      tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y \
      yarn && \
    apt-get clean

# install Google Chrome
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google.list && \
   apt-get update && \
   apt-get install -y \
     google-chrome-stable && \
   apt-get clean

# install RVM
RUN apt-get update && \
    apt-get install -y \
      libgdbm-dev \
      libncurses5-dev \
      automake \
      libtool \
      bison \
      libffi-dev && \
    apt-get clean && \
    gpg --keyserver hkp://keys.gnupg.net \
        --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
                    7D2BAF1CF37B13E2069D6956105BD0E739499BDB && \
    curl -sSL https://get.rvm.io | bash -s stable

# install Ruby via RVM
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && \
    rvm install ${RUBY_VERSION} --disable-binary && \
    rvm use ${RUBY_VERSION} --default"

# update Gems, install chromedriver and update it
RUN /bin/bash -l -c ". /etc/profile.d/rvm.sh && gem update --system && gem install chromedriver-helper && chromedriver-update"

# copy current app to /srv/app
RUN mkdir /srv/app
COPY . /srv/app

ENTRYPOINT ["/bin/bash","--login"]

# syntax=docker/dockerfile:1
FROM ruby:3.1

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq\
  && apt-get install -y nodejs postgresql-client\
  && apt install --no-install-recommends yarn

ARG USERNAME=ror_app_user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV USERNAME=$USERNAME
ENV USER_UID=$USER_UID
ENV USER_GID=$USER_GID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # Add sudo support.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /myapp
RUN chown -R $USER_UID:$USER_GID /myapp

# Set the default user.
USER $USERNAME

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# check versions
RUN ruby --version
RUN rails --version
RUN node --version
RUN yarn --version

# RUN rails webpacker:install # Run in container's console.

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN sudo chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
# CMD ["ruby", "-v"]

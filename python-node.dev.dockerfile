FROM ubuntu:22.04 as base

# Let scripts know we're running in Docker (useful for containerised development)
ENV RUNNING_IN_DOCKER true

#########################
# Setup ubuntu packages #
#########################
RUN apt-get update -qq && apt-get install -y -qq curl git zsh make

# Install python requirements
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y -qq --no-install-recommends build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev llvm \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# create user
RUN useradd -ms /bin/zsh main
# set password
RUN echo 'main:passwd' | chpasswd
WORKDIR /home/main
USER main

###################
# Setup Oh My Zsh #
###################
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
COPY .dockershell.sh .zshrc

# Install Oh My Zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/clarketm/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

##############
# Setup ASDF #
##############
# https://hub.docker.com/r/hirocaster/alpine-asdf-elixir/dockerfile/

COPY .tool-versions .
COPY .default-python-packages .
RUN git clone https://github.com/asdf-vm/asdf.git .asdf --branch v0.10.0 \
  && PATH=$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH \
  && asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
  && ASDF_PYTHON_PATCH_URL="https://github.com/python/cpython/commit/8ea6353.patch?full_index=1" \
  && asdf plugin-add python \
  && asdf install

#####################
# Finishing touches #
#####################

# change default shell to zsh
USER root
RUN chsh -s $(which /bin/zsh)

# Fix permissions
RUN chown -R main:main /home/main/

# Setup user environment
USER main
WORKDIR /home/main/project
ENTRYPOINT [ "/bin/zsh" ]

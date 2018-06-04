FROM ubuntu

RUN apt-get -qq update

# Install basic development tools.
RUN apt-get -qq -y install git curl

# Install neovim with python support.
RUN apt-get -qq -y install python-neovim

# Install plug for managing vim plugins.
RUN curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Needed for auto-completion plugin.
# https://github.com/Shougo/deoplete.nvim
RUN apt-get -qq -y install python-pip
RUN apt-get -qq -y install python3-pip
RUN pip install --upgrade neovim
RUN pip3 install --upgrade neovim

# Setup golang development environment.
WORKDIR /tmp
RUN curl -O https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.10.2.linux-amd64.tar.gz && rm go1.10.2.linux-amd64.tar.gz
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /go

# Copy our neovim config.
COPY init.vim /root/.config/nvim/init.vim

# Install vim plugins.
RUN nvim +PlugInstall +qall

# ZSH!
RUN apt-get -qq -y install zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN chsh -s /bin/zsh

WORKDIR /work


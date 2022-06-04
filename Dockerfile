FROM archlinux:base-devel

RUN pacman -Syu --noconfirm --needed docker curl wget zsh python python-pip exa neovim nodejs ncmpcpp sed openssh git base-devel man neofetch imagemagick cmatrix # install dependencies via pacman

RUN pip3 install pynvim neovim-remote --upgrade # install dependencies via pip3

# create and switch to user (dev)
RUN useradd -m dev
RUN chsh -s /usr/bin/zsh dev # change dev's shell to zsh (container needs to be run with `/usr/bin/zsh`)
RUN echo "dev:123" | chpasswd # set dev's password
RUN echo -e "\n# give dev sudo permissions, no password\ndev ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers # give dev sudo permissions, no password
USER dev

# navigate to dev's home directory
WORKDIR "/home/dev"

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true # install oh-my-zsh

RUN git clone https://gitlab.com/nickgirga/bash-config.git # clone 'nickgirga/bash-config'
WORKDIR "/home/dev/bash-config"
RUN git checkout zsh # switch to zsh branch (temporary)

RUN git submodule init nvim-config # initialize Neovim config submodule
RUN git submodule update nvim-config # update contents of Neovim config submodule

RUN mkdir -p "/home/dev/.config/nvim" # make Neovim config directory
RUN cp /home/dev/bash-config/nvim-config/.config/nvim/init.vim /home/dev/.config/nvim/init.vim # copy Neovim config file from 'nickgirga/nvim-config'
RUN cp /home/dev/bash-config/nvim-config/.config/nvim/coc-settings.json /home/dev/.config/nvim/coc-settings.json # copy Coc config file from 'nickgirga/nvim-config'

RUN git submodule init nvim-edit # initialize 'nickgirga/nvim-edit'
RUN git submodule update nvim-edit # update contents of 'nickgirga/nvim-edit'

RUN mkdir -p "/home/dev/.local/bin" # make local bin directory
RUN cp /home/dev/bash-config/nvim-edit/nvim-edit /home/dev/.local/bin/nvim-edit # copy 'nickgirga/nvim-edit' into local bin directory

RUN mkdir -p "/home/dev/.local/share/nvim/site/autoload" # make Neovim autoload directory
RUN wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O /home/dev/.local/share/nvim/site/autoload/plug.vim # download vim-plug

RUN if [ -f /home/dev/.zshrc ]; then rm -f /home/dev/.zshrc; fi # remove original user zshrc file if needed
RUN cp /home/dev/bash-config/config/arch.zshrc /home/dev/.zshrc # copy zshrc file from 'nickgirga/bash-config'

RUN if [ -f /etc/bash.bashrc ]; then sudo rm -f /etc/bash.bashrc; fi # remove original /etc/bash.bashrc file if needed
RUN sudo cp /home/dev/bash-config/config/etc/arch.bashrc /etc/bash.bashrc # copy /etc/bash.bashrc file from 'nickgirga/bash-config'

RUN cp /home/dev/bash-config/.neofetch_art /home/dev/.neofetch_art # copy Neofetch art

RUN mkdir -p /home/dev/.config/neofetch # make Neofetch config directory
RUN cp /home/dev/bash-config/config/arch.neofetch /home/dev/.config/neofetch/config.conf.yorha # copy Neofetch config

WORKDIR "/home/dev"
RUN rm -rf "/home/dev/bash-config" # delete 'nickgirga/bash-config' directory

# install Neovim plugins
RUN [ "/bin/bash", "-c", "nvim -n -S <(echo -e 'silent! PlugInstall\n\nUpdate\nqall')" ]

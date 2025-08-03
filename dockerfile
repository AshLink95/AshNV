FROM archlinux:base-devel

# setup
WORKDIR /root
COPY ./nvim /root/.config/nvim
ENV RUSTUP_HOME=/root/.rustup
ENV CARGO_HOME=/root/.cargo
ENV PATH="/root/.cargo/bin:/root/.local/bin:$PATH"

# Installations
RUN pacman -Syu --noconfirm git curl npm python-pipx neovim \
    gcc go python gcc-fortran \
    make cmake ninja scons \
    clang gopls \
    tree-sitter
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && rustup component add rust-src rust-analyzer
RUN npm install -g pyright
RUN pipx install fortls

# Host
EXPOSE 2004
ENTRYPOINT ["nvim"]

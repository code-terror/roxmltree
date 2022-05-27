# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang curl git-all build-essential
RUN curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN ${HOME}/.cargo/bin/rustup default nightly
RUN ${HOME}/.cargo/bin/cargo install afl
RUN git clone https://github.com/RazrFalcon/roxmltree.git
WORKDIR /roxmltree/testing-tools/afl-fuzz/
RUN ${HOME}/.cargo/bin/cargo afl build
WORKDIR /
COPY Mayhemfile Mayhemfile
ENTRYPOINT ["cargo", "afl", "fuzz", "-i", "/roxmltree/testing-tools/afl-fuzz/in", "-o", "/roxmltree/testing-tools/afl-fuzz/out"]
CMD ["/roxmltree/testing-tools/afl-fuzz/target/debug/afl-fuzz"]

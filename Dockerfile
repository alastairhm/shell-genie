FROM ubuntu:23.10 as base

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y upgrade && apt-get -y install --no-install-recommends curl git build-essential python3 pip neovim pipx && \
    rm -rf /var/lib/apt/lists/* 

FROM base
RUN groupadd -r shellgenie && \
    useradd -m -d /home/shellgenie -r -g shellgenie shellgenie

USER shellgenie
WORKDIR /home/shellgenie

RUN pipx install shell-genie && \
    mkdir -p /home/shellgenie/.config/.shell_genie && \
    echo '{"backend": "free-genie", "os": "Linux", "os_fullname": "Ubuntu 23.10", "shell": "bash", "training-feedback": true}' > /home/shellgenie/.config/.shell_genie/config.json && \
    echo 'export PATH=$PATH:/home/shellgenie/.local/bin' >> /home/shellgenie/.bashrc

ENTRYPOINT ["/home/shellgenie/.local/bin/shell-genie","ask"]


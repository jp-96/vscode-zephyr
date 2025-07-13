# See here for image contents: https://github.com/devcontainers/images/tree/main/src/python
# Available image variants: https://github.com/devcontainers/templates/blob/main/src/python/devcontainer-template.json
ARG VARIANT="3"
FROM mcr.microsoft.com/devcontainers/python:1-${VARIANT}

# # [Optional] Allow the vscode user to pip install globally w/o sudo
# RUN pip3 --disable-pip-version-check --no-cache-dir install --upgrade pip
# ENV PIP_TARGET=/usr/local/pip-global
# # ENV PYTHONPATH=${PIP_TARGET}:${PYTHONPATH}
# ENV PYTHONPATH=${PIP_TARGET}
# ENV PATH=${PIP_TARGET}/bin:${PATH}
# RUN if ! cat /etc/group | grep -e "^pip-global:" > /dev/null 2>&1; then groupadd -r pip-global; fi \
#     && usermod -a -G pip-global vscode \
#     && umask 0002 && mkdir -p ${PIP_TARGET} \
#     && chown :pip-global ${PIP_TARGET} \
#     && ( [ ! -f "/etc/profile.d/00-restore-env.sh" ] || sed -i -e "s/export PATH=/export PATH=\/usr\/local\/pip-global:/" /etc/profile.d/00-restore-env.sh )

# [Option] Install Node.js
# ARG INSTALL_NODE="true"
# ARG NODE_VERSION="lts/*"
# RUN if [ "${INSTALL_NODE}" = "true" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

# [Optional] Uncomment this line to install global node packages.
# RUN su vscode -c "source /usr/local/share/nvm/nvm.sh && npm install -g <your-package-here>" 2>&1

# Create directory and set permission.
RUN mkdir -p /home/vscode/zephyr \
    && mkdir -p /home/vscode/zephyr/dev \
    # && mkdir -p /home/vscode/zephyr/dev/.vscode \
    # && mkdir -p /home/vscode/zephyr/dev/.vscode-server \
    && chown -R vscode:vscode /home/vscode/zephyr

# Developing with Zephyr >> Getting Started Guide
# https://docs.zephyrproject.org/latest/develop/getting_started/index.html

# Install Zephyr SDK dependencies.
# https://docs.zephyrproject.org/latest/develop/getting_started/index.html#install-dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends git cmake ninja-build gperf \
        ccache dfu-util device-tree-compiler wget \
        python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
        make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
RUN pip3 --disable-pip-version-check --no-cache-dir install --upgrade west

# Download and install a packaged cmake from the CMake project site.
# https://docs.zephyrproject.org/latest/develop/getting_started/installation_linux.html#cmake
# Available CMake versions: https://github.com/Kitware/CMake/releases
ARG CMAKE_VERSION="3.21.1"
RUN mkdir -p /tmp/cmake-tmp \
    && cd /tmp/cmake-tmp \
    && wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
    && chmod +x cmake-${CMAKE_VERSION}-Linux-x86_64.sh \
    && ./cmake-${CMAKE_VERSION}-Linux-x86_64.sh --skip-license --prefix=/usr/local \
    && hash -r \
    && rm -rf /tmp/cmake-tmp
    
WORKDIR /home/vscode/zephyr

# Get Zephyr and install Python dependencies
# https://docs.zephyrproject.org/latest/develop/getting_started/index.html#get-zephyr-and-install-python-dependencies
RUN su vscode -c "west init && west update && west zephyr-export"
RUN su vscode -c "west packages pip --install --ignore-venv-check"
# RUN west packages pip --install --ignore-venv-check
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r zephyr/scripts/requirements.txt

# Install Zephyr SDK
# https://docs.zephyrproject.org/latest/develop/getting_started/index.html#install-the-zephyr-sdk
RUN su vscode -c "cd zephyr && west sdk install -d /home/vscode/zephyr-sdk"

# Install Node.js and microbit-universal-hex
ARG NODE_VERSION="lts/*"
RUN su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"
RUN su vscode -c "npm install @microbit/microbit-universal-hex"

# Setup tools for USB access and permission control in WSL2 with usbipd-win
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends usbutils
COPY ./dev/scripts/fix-microbit-perms.sh /home/vscode/zephyr/dev/fix-microbit-perms.sh
RUN chmod +x /home/vscode/zephyr/dev/fix-microbit-perms.sh \
    && chown vscode:vscode /home/vscode/zephyr/dev/fix-microbit-perms.sh
COPY ./dev/scripts/launch-debugserver.sh /home/vscode/zephyr/dev/launch-debugserver.sh
RUN chmod +x /home/vscode/zephyr/dev/launch-debugserver.sh \
    && chown vscode:vscode /home/vscode/zephyr/dev/launch-debugserver.sh

FROM ubuntu:latest 

ENV ANDROID_COMPILE_SDK="29" \
    ANDROID_BUILD_TOOLS="29.0.2" \
    ANDROID_SDK_TOOLS="24.4.1" \
    ANDROID_HOME=/android-sdk-linux \
    PATH="${PATH}:/android-sdk-linux/platform-tools/" \
    LANG=en_US.utf8

COPY Gemfile.lock Gemfile ./

RUN apt-get --quiet update --yes && \
    apt-get --quiet install --no-install-recommends --yes wget tar unzip lib32stdc++6 lib32z1 build-essential ruby ruby-dev smbclient openjdk-8-jdk && \
    apt-get --quiet install --no-install-recommends --yes vim-common && \
    apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    apt-get --purge autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean all && \
    wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz && \
    tar --extract --gzip --file=android-sdk.tgz && rm -rf android-sdk.tgz && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter android-${ANDROID_COMPILE_SDK}) && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter platform-tools) && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS}) && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-android-m2repository) && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-google_play_services) && \
    (echo y | android-sdk-linux/tools/android --silent update sdk --no-ui --all --filter extra-google-m2repository) && \
    gem install bundle && \
    bundle install && \
    update-ca-certificates
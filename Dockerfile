FROM ruby:alpine
MAINTAINER chroju

WORKDIR /root

ADD files/id_rsa /root/.ssh/id_rsa
RUN apk --update --no-cache add git g++ ruby-dev linux-headers icu-dev libxml2-dev libxslt-dev build-base openssh && \
ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts && \
gem install gollum github-markdown redcarpet org-ruby --no-ri --no-doc -- --use-system-libraries && \
git config --global user.email "chor.chroju@gmail.com" && git config --global user.name "chroju" && \
git clone git@github.com:chroju/gollum_articles /root/gollum && \
touch /etc/periodic/hourly/gitpush && \
echo -e "#!/bin/sh\ncd /root/gollum && git push origin master" >> /etc/periodic/hourly/gitpush && \
chmod a+x /etc/periodic/hourly/gitpush

ADD files/auth.rb /root/gollum/auth.rb

CMD crond && /usr/local/bundle/bin/gollum /root/gollum --config /root/gollum/auth.rb

EXPOSE 4567

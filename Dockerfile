########################################################################################################################

FROM nginx:alpine

########################################################################################################################

LABEL maintainer="Maxime JAUME <maxime.jaume@lpsc.in2p3.fr>"

LABEL maintainer="Jérôme ODIER <jerome.odier@lpsc.in2p3.fr>"

LABEL description="AMI Web Framework"

########################################################################################################################

ENV PYTHONUNBUFFERED="1"

ENV AMI_HOME_PAGE_TITLE=""

ENV AMI_HOME_PAGE_ENDPOINT=""

########################################################################################################################

RUN apk add --update --no-cache git

RUN apk add --update --no-cache python3

########################################################################################################################

RUN curl -L https://raw.githubusercontent.com/ami-team/awfwebpack/master/tools/awf_stub.py > /usr/share/nginx/html/awf.py

RUN chmod a+x /usr/share/nginx/html/awf.py

RUN rm /usr/share/nginx/html/index.html

########################################################################################################################

RUN sed -i "/^set .*$/a (\nexport PYTHONUNBUFFERED=1\ncd /usr/share/nginx/html/\n./awf.py --update-prod\nif [[ ! -f index.html ]]\nthen\n./awf.py --create-home-page --home-page-title=\${AMI_HOME_PAGE_TITLE} --home-page-endpoint=\${AMI_HOME_PAGE_ENDPOINT}\nfi\n) || exit 1" /docker-entrypoint.sh

########################################################################################################################

VOLUME ["/usr/share/nginx/html/"]

########################################################################################################################

EXPOSE 80

########################################################################################################################

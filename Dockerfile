########################################################################################################################

FROM nginx:alpine

########################################################################################################################

LABEL maintainer="Maxime JAUME <maxime.jaume@lpsc.in2p3.fr>"

LABEL maintainer="Jérôme ODIER <jerome.odier@lpsc.in2p3.fr>"

LABEL description="AMI Web Framework"

########################################################################################################################

ENV AMI_HOME_PAGE_TITLE="AMI"

ENV AMI_HOME_PAGE_ENDPOINT="https://localhost:8443/AMI/FrontEnd"

########################################################################################################################

RUN ["apk", "add", "--update", "--no-cache", "git", "python3"]

########################################################################################################################

RUN ["rm", "-fr", "/usr/share/nginx/html/"]

RUN ["mkdir", "/usr/share/nginx/html/"]

########################################################################################################################

RUN ["wget", "-O", "/usr/share/nginx/html/awf.py", "https://raw.githubusercontent.com/ami-team/awfwebpack/master/tools/awf_stub.py"]

RUN ["chmod", "a+x", "/usr/share/nginx/html/awf.py"]

########################################################################################################################

RUN sed -i "/^set .*$/a (\nexport PYTHONUNBUFFERED=1\ncd /usr/share/nginx/html/\n./awf.py --update-prod\nif [[ ! -f index.html ]]\nthen\n./awf.py --create-home-page --home-page-title=\${AMI_HOME_PAGE_TITLE} --home-page-endpoint=\${AMI_HOME_PAGE_ENDPOINT}\nfi\n) || exit 1" /docker-entrypoint.sh

########################################################################################################################

EXPOSE 80

########################################################################################################################

VOLUME /usr/share/nginx/html/

########################################################################################################################

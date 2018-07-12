FROM centos:centos7

LABEL name="Mistral" \
      description="Workflow Service for OpenStack" \
      maintainers="Dougal Matthews <dougal@redhat.com>"

# Default to the latest stable
ARG MISTRAL_VERSION="mistral<2015"
ARG GERRIT_REVIEW

RUN yum -y update; yum clean all;

RUN curl -s -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && rm /tmp/get-pip.py

RUN yum -y install python-devel gcc epel-release;
RUN yum -y install jq crudini git;

ENV INI_SET="crudini --set /etc/mistral/mistral.conf" \
    CONFIG_FILE="/etc/mistral/mistral.conf" \
    MESSAGE_BROKER_URL="rabbit://mistral:mistral@rabbitmq:5672/mistral" \
    DATABASE_URL="postgresql+psycopg2://mistral:mistral@postgresql:5432/mistral"

RUN pip install psycopg2
COPY ./scripts/install-gerrit-review.sh /
RUN if [ "x$GERRIT_REVIEW" != "x" ] ; then \
      ./install-gerrit-review.sh $GERRIT_REVIEW; \
    else \
      pip install $MISTRAL_VERSION ; \
    fi
RUN rm install-gerrit-review.sh;
RUN pip freeze | grep mistral
RUN mkdir /etc/mistral

RUN oslo-config-generator \
      --namespace mistral.config \
      --namespace oslo.db \
      --namespace oslo.messaging \
      --namespace oslo.middleware.cors \
      --namespace keystonemiddleware.auth_token \
      --namespace periodic.config \
      --namespace oslo.log \
      --namespace oslo.policy \
      --namespace oslo.service.sslutils \
      --output-file "${CONFIG_FILE}"

RUN ${INI_SET} DEFAULT transport_url "${MESSAGE_BROKER_URL}" \
    && ${INI_SET} database connection "${DATABASE_URL}" \
    && ${INI_SET} pecan auth_enable false

EXPOSE 8989
CMD mistral-server --config-file "${CONFIG_FILE}" --server ${MISTRAL_SERVER}

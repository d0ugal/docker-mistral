FROM centos:centos7

LABEL name="Mistral Workflow Service" \
      maintainers="Dougal Matthews <dougal@redhat.com>"

RUN yum -y update; yum clean all;

RUN curl -s -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && rm /tmp/get-pip.py

RUN yum -y install python-devel gcc epel-release;

ENV CONFIG_FILE="/etc/mistral/mistral.conf" \
    MESSAGE_BROKER_URL="rabbit://guest:guest@rabbitmq:5672/" \
    DATABASE_URL="postgresql+psycopg2://mistral:mistral@postgresql:5432/mistral" \
    UPGRADE_DB="false" \
    INI_SET="crudini --set /etc/mistral/mistral.conf"

RUN pip install psycopg2
RUN pip install "mistral<=2015"
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

RUN yum install -y crudini
RUN ${INI_SET} DEFAULT transport_url "${MESSAGE_BROKER_URL}" \
    ${INI_SET} database connection "${DATABASE_URL}" \
    ${INI_SET} pecan auth_enable false

EXPOSE 8989
CMD mistral-server --config-file "${CONFIG_FILE}" --server ${MISTRAL_SERVER}

FROM quay.io/thoth-station/s2i-minimal-f34-py39-notebook:v0.3.0
LABEL name="s2i-odh-nb-ex" \
      version="latest" \
      summary="Custom Jupyter Notebook Source-to-Image for Python 3.9 applications." \
      description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.description="Notebook image based on Source-to-Image.These images can be used in OpenDatahub JupterHub." \
      io.k8s.display-name="Custom Notebook Python 3.9 S2I" \
      io.openshift.expose-services="8888:http" \
      io.openshift.tags="python,python38" \
      io.openshift.s2i.build.commit.ref="main" \
      io.openshift.s2i.build.source-location="https://github/harshad16/s2i-odh-nb-ex"
ENV XDG_CACHE_HOME="/opt/app-root/src/.cache" \
    THAMOS_RUNTIME_ENVIRONMENT="" \
    UPGRADE_PIP_TO_LATEST="1" \
    WEB_CONCURRENCY="1" \
    THOTH_ADVISE="0" \
    THOTH_ERROR_FALLBACK="1" \
    THOTH_DRY_RUN="1" \
    THAMOS_DEBUG="0" \
    THAMOS_VERBOSE="1" \
    THOTH_PROVENANCE_CHECK="0"

USER root

# Insert your changes here.


# clean up cache
RUN rm -rf /var/cache/dnf
# Copying in override assemble/run scripts
COPY .s2i/bin /tmp/scripts
# Copying in source code
COPY . /tmp/src

# Change file ownership to the assemble user. Builder image must support chown command.
RUN chown -R 1001:0 /tmp/scripts /tmp/src
USER 1001

RUN /tmp/scripts/assemble
CMD /tmp/scripts/run

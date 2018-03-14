FROM maven:3-jdk-8
# unset the maven:3-jdk-8 entrypoint
ENTRYPOINT ["/usr/bin/env"]
# create standard Vaadin stub project
RUN mkdir /editor ; \
useradd --user-group --create-home vaadin ; \
chown vaadin:vaadin /editor

USER vaadin

RUN cd /editor ; \
curl https://codeload.github.com/Wnt/vaadin-fiddle/zip/editor-node --output vaadin-fiddle-editor-node.zip ; \
unzip vaadin-fiddle-editor-node.zip

WORKDIR /editor/vaadin-fiddle-editor-node

# compile the project
RUN mvn clean compile

# cache dependencies of jetty:run goal
RUN mvn jetty:start

# update & pre-compile Vaadin stuff
RUN mvn vaadin:update-theme vaadin:update-widgetset vaadin:compile-theme vaadin:compile

CMD ["mvn", "jetty:run"]

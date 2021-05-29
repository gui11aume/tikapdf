FROM ubuntu

# Install all necessary commands.
RUN apt-get update
RUN apt-get -y install default-jdk
RUN apt-get -y install wget
RUN apt-get -y install unzip
RUN apt-get -y install curl

# Install Maven.
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
	&& curl -fsSL -o /tmp/apache-maven.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz \
	&& tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
	&& rm -f /tmp/apache-maven.tar.gz \
	&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# Environmental variables for Maven.
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG "/root/.m2"

# Install Tika and dependencies.
RUN wget https://archive.apache.org/dist/tika/tika-1.26-src.zip
RUN unzip tika-1.26-src.zip
RUN rm tika-1.26-src.zip
RUN cd tika-1.26 && mvn clean install
RUN cd tika-1.26/tika-parsers && mvn dependency:copy-dependencies

# Point Java to Tika and its dependencies.
ENV CLASSPATH=/tika-1.26/tika-core/target/tika-core-1.26.jar:/tika-1.26/tika-parsers/target/tika-parsers-1.26.jar:/tika-1.26/tika-parsers/target/dependency/pdfbox-2.0.23.jar:/tika-1.26/tika-parsers/target/dependency/jempbox-1.8.16.jar:/tika-1.26/tika-parsers/target/dependency/commons-logging-1.2.jar:/tika-1.26/tika-parsers/target/dependency/commons-io-2.8.0.jar:/tika-1.26/tika-parsers/target/dependency/poi-4.1.2.jar:/tika-1.26/tika-parsers/target/dependency/fontbox-2.0.23.jar:.:${CLASSPATH}

# Copy source code.
COPY pdf2txt.java /bin/

# Set default volume for sharing
RUN mkdir /share && chmod 777 /share

# Create user at build time. Build as show below.
# docker build -t [image] --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) .
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

USER user
WORKDIR /share

## Allows calling as shown below (converts all pdf files in directory).
## docker run --rm  -v $(pwd):/share [image]
CMD java /bin/pdf2txt.java *.pdf

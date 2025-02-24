FROM python:3.8-slim

# Set environment variables for non-interactive setup and unbuffered output
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/app" \
    TERM=xterm
			
# Build argument for setting the main app path
ARG MAINAPPPATH=.
			
# Set working directory inside the container
WORKDIR /app
			
# Copy requirements to leverage Docker cache
COPY "${MAINAPPPATH}/requirements.txt" "${MAINAPPPATH}/requirements.txt"
			
# Install dependencies without caching
RUN apt-get update -y
RUN apt-get install curl wget git sudo apt-utils procps g++ python3-pip python3-venv -y
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash
RUN apt-get install nodejs -y
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN npm install -g configurable-http-proxy --force
RUN sudo adduser --disabled-password --gecos "Jovyan" jovyan --uid 1000
RUN python3 -m venv /opt/venv
ENV PATH /opt/venv/bin:${PATH}
RUN /opt/venv/bin/pip install -r requirements.txt --no-cache-dir
# Copy entire application into container
COPY . .
			
# Set working directory to main app path
WORKDIR "/app/${MAINAPPPATH}"

# Define the container's startup command
ENTRYPOINT ["/bin/bash", "-c", "bash start.sh"]

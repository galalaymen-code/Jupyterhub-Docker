#!/bin/bash
jupyterhub --Authenticator.allow_all=True --Spawner.notebook_dir="/home/jovyan" --Authenticator.admin_users="{'jovyan'}" --Spawner.http_timeout=180 --JupyterHub.authenticator_class="native" --NativeAuthenticator.open_signup=True --JupyterHub.hub_connect_ip="0.0.0.0" --port=8080

Ansible-CI/CD Pipeline Project
Project Overview:
This project demonstrates a complete CI/CD pipeline for a web application using Ansible for automated provisioning and deployment. It showcases how Ansible can orchestrate a multi-tier application environment – including a Python Flask web app, a PostgreSQL database, and an Nginx load balancer – as part of a continuous integration/continuous delivery process. By using Ansible in the pipeline, deployments become more consistent and automated, reducing manual errors and speeding up the release process
medium.com
redhat.com
. This README provides a detailed overview of the project structure, setup instructions, technologies used, and future improvement ideas, written to a professional standard suitable for discussion in a job interview.
Project Structure
The repository is organized into clearly defined sections to separate configuration, application code, and pipeline workflows:
Ansible/ – Contains all Ansible-related files:
ansible.cfg – Ansible configuration file (defines defaults like inventory location, remote user, etc.).
inventory – Inventory defining target hosts/groups (e.g., web, db, lb groups for web server, database, load balancer).
playbook.yml – The main Ansible playbook that orchestrates the deployment by running the relevant roles on the respective hosts.
roles/ – Ansible roles for modular deployment of each component (each role has tasks, handlers, templates, etc.):
ansible_decker – Role to prepare the web server environment (e.g. install Docker and dependencies, deploy the web application).
ansible_PostgreSQL – Role to set up the PostgreSQL database (install DB server, create database, user, tables, and configure access).
ansible_nginx_lb – Role to configure Nginx as a load balancer or reverse proxy (install Nginx and deploy a templated nginx.conf).
ansible_web_app – Role to deploy the Flask web application (e.g. configure application service, environment variables, etc.). Currently, the web app deployment tasks are handled via Docker in the ansible_decker role, but this role is scaffolded for potential use.
app/ – Contains the source code of the web application (a Python Flask app):
app/ (various Python modules and files for the Flask application, e.g. routes, models, etc.).
app/requirements.txt – Python dependencies for the application (Flask, Flask_SQLAlchemy for DB integration, Gunicorn for WSGI server, Psycopg2 for PostgreSQL connectivity, etc. – see Installation below).
run.py – Flask application entry point (used to start the Flask app, often with Gunicorn in production).
(Other application files such as routes.py, configuration, etc., are present to define the web app's behavior.)
.github/workflows/ – CI pipeline definition:
CICD.yml – GitHub Actions workflow file that automates the CI/CD process. On each push (or chosen trigger), this workflow installs required tools (like Ansible and Python), sets up an inventory, and runs the Ansible playbook to deploy the application in a controlled environment. It uses a local runner configuration (treating localhost as all target hosts for demonstration)
github.com
, which allows testing the Ansible roles in the CI environment.
requirements.txt (at repository root) – Python requirements for Ansible or project-level needs. (If the project requires any Python libraries for the Ansible control node, they would be listed here. In this project, the primary Python requirements are for the Flask application and are listed in app/requirements.txt. The Ansible execution uses standard modules and collections.)
README.md – Project documentation (you are reading it!). Explains the project setup, usage, and other details.
Below is a simplified directory tree for a high-level view of the structure:
arduino
Copy
Edit
├── Ansible/
│   ├── ansible.cfg
│   ├── inventory
│   ├── playbook.yml
│   └── roles/
│       ├── ansible_decker/
│       ├── ansible_PostgreSQL/
│       ├── ansible_nginx_lb/
│       └── ansible_web_app/
├── app/
│   ├── run.py
│   ├── routes.py
│   ├── ... (other Flask app files)
│   └── requirements.txt
├── .github/
│   └── workflows/
│       └── CICD.yml
├── requirements.txt
└── README.md
Each Ansible role contains sub-folders like tasks/ (the main automation steps), templates/ (Jinja2 templates for configuration files, e.g. Nginx config), handlers/ (to restart services after changes), defaults/vars/ (default variables), etc., following Ansible best practices for role structure
github.com
.
Installation and Setup
Follow these steps to set up the project and run the Ansible playbook on a local or remote environment:
Clone the Repository:
bash
Copy
Edit
git clone https://github.com/elayvilkom/Ansible-CICD.git
cd Ansible-CICD
Install Ansible: Ensure you have Ansible installed on the control machine (the machine from which you will run the playbook). This project was developed with Ansible 2.9+ / 2.10+ (recommended). You can install Ansible via pip:
bash
Copy
Edit
pip install ansible
Note: The Ansible playbook will target hosts defined in the Ansible/inventory. In this project’s default setup, it’s configured to use localhost for all roles (for demonstration), but you can replace localhost with actual server IPs or hostnames in the inventory.
Install Ansible Collections (if needed): The playbook uses some community modules (for example, community.postgresql for database setup, community.general for UFW firewall rules). Make sure to install the required Ansible collections:
bash
Copy
Edit
ansible-galaxy collection install community.postgresql community.general
This ensures modules like community.postgresql.postgresql_db and community.general.ufw used in the roles are available.
Prepare Target Hosts: If you intend to deploy to actual servers (not just localhost), update the Ansible/inventory with your hosts. Group them under web, db, and lb as needed. For each host, ensure:
You have SSH access from the control machine (consider using SSH keys).
Python 3 is installed on the target (Ansible uses Python on the target machine to execute tasks).
The target hosts match the expected OS (the roles assume an Ubuntu/Debian-based system for apt package management and systemd service management).
Define Variables: Review and adjust any default variables in the roles if necessary. Key variables include database credentials (in roles/ansible_PostgreSQL/vars/main.yml) and any configuration in roles/ansible_nginx_lb/templates/nginx.conf.j2 (like upstream server addresses) or application settings in roles/ansible_web_app. The project provides default values (e.g., default DB name, user, password are set for demonstration), but these should be changed for production use.
Install Application Requirements: The Flask application’s dependencies are listed in app/requirements.txt. If you plan to run the app (e.g., via Gunicorn or Flask development server) on the target host or locally for testing, install these dependencies (preferably in a virtual environment):
bash
Copy
Edit
pip install -r app/requirements.txt
This includes packages such as:
Flask 2.2.2 – The web framework for the application.
Flask-SQLAlchemy 3.0.2 – For database integration (SQLAlchemy ORM).
psycopg2-binary 2.9.5 – PostgreSQL database driver.
Gunicorn 20.1.0 – WSGI HTTP server to run the Flask app in production.
... (and others like Jinja2, Click, itsdangerous, etc. as listed in the requirements file).
Run the Ansible Playbook:
Execute the playbook to provision and deploy the application stack:
bash
Copy
Edit
ansible-playbook -i Ansible/inventory Ansible/playbook.yml
This will perform the following, in sequence:
Web Server setup (Role: ansible_decker): Install Docker and other necessary packages on the web server, and deploy the application (for example, by building or running a Docker container for the Flask app). (If not containerizing, this role would ensure Python and app requirements are present to run the app.)
Database setup (Role: ansible_PostgreSQL): Install PostgreSQL, create the application database and a user, set the password, and initialize the schema (it even creates a simple user table in the database as a demonstration). Firewall rules are adjusted (opens port 5432) and the database connection URI is prepared for the app.
Load Balancer setup (Role: ansible_nginx_lb): Install Nginx and configure it using a Jinja2 template (nginx.conf.j2). The Nginx configuration is set to route incoming traffic to the web application (for example, forwarding to the Flask app running on a certain port). It can be configured to balance between multiple web servers if extended.
Application deployment (Role: ansible_web_app): (If used) This would handle application-specific steps such as copying source code, setting up a systemd service or Docker container for the Flask app, and ensuring it’s running. In the current setup, the deployment might be handled within the ansible_decker role using Docker for simplicity.
Ansible will prompt for privilege escalation (sudo) if needed for installing packages. On success, you should have:
PostgreSQL running with the new database and user created.
The Flask application running (via Gunicorn or Docker, depending on implementation).
Nginx running and proxying requests to the Flask app.
You can then navigate to the load balancer’s address (e.g., http://<host> on port 80) to access the web application.
Note: In this project’s CI environment (GitHub Actions), the playbook is executed on the runner itself (using localhost for all roles)
github.com
. This means the CI simulates the provisioning by applying all roles on a single machine for testing. In a real deployment, these roles would target different hosts or VMs (for example: web app on one VM, DB on another, LB on a third) as specified in the inventory.
Usage of Ansible and Python in the Project
Ansible’s Role: Ansible is at the core of the CI/CD process in this project. It automates the setup of infrastructure and deployment of the app, encapsulating all operational steps in code (Infrastructure as Code). In the context of this project:
Ansible playbooks and roles define what needs to be done on each server (e.g., install packages, copy files, start services). For example, the playbook runs the ansible_PostgreSQL role on the db host to set up the database, ensuring the exact configuration and schema needed by the app is in place.
Ansible uses Python under the hood on managed nodes – all Ansible modules (like apt, service, postgresql_db) are executed via Python on the target hosts. This means the target machines need Python installed, and it allows Ansible to leverage Python libraries (for example, the community.postgresql modules use psycopg2 under the hood to communicate with PostgreSQL).
The project’s Ansible configuration (ansible.cfg) explicitly sets some parameters: the inventory path, the remote user (e.g., a user with sudo access), SSH private key for authentication, and even the Python interpreter path on hosts (to ensure Ansible runs with Python 3)
github.com
github.com
. This ensures that Ansible can run smoothly in the given environment.
Python’s Role: Python is utilized in two ways:
Application Code: The project’s Flask web application is written in Python. Flask is a lightweight Python web framework, and combined with SQLAlchemy and other libraries, it powers the application’s logic. The code (in the app/ directory) includes route definitions, database models or queries (to create the user table, etc.), and uses Gunicorn as a production server.
Scripting & Glue: While most provisioning tasks are handled by Ansible modules, any custom logic that might be needed could be implemented via Python scripts. In this project, for example, instead of writing a separate SQL migration script, Ansible directly uses the postgresql_query module to run a SQL command that creates a table
github.com
github.com
. If more complex application setup was required (like seeding the database or running a custom script), it could be done by invoking Python scripts through Ansible tasks.
By using Python for the application and Ansible for automation (which itself relies on Python), the project ensures a cohesive environment. Both the app and the automation code are in Pythonic ecosystems, making it easy for developers to reason about deployments. New team members can easily read the Ansible YAML and understand the desired state of each server (thanks to Ansible’s declarative, human-readable syntax)
redhat.com
, and they can dive into the Python application code to understand the business logic.
Technologies and Tools Used
This project brings together multiple technologies to build a functional CI/CD pipeline:
Ansible: Configuration management and automation tool used to orchestrate the entire deployment. It manages package installation, configuration file templating, service setup, and inter-service coordination (e.g., making sure the database is initialized before the app starts). Ansible roles are used to organize tasks per component, improving reusability and clarity.
GitHub Actions: Used as the CI/CD platform (via the workflow file in .github/workflows/CICD.yml). It automates running the Ansible playbook on each code push, serving as an example of continuous delivery. This ensures that any change to the repository is quickly tested in an environment that simulates deployment.
Python & Flask: Python is the programming language for the web application. Flask is the web framework used to develop a simple application (with routes defined in routes.py and an application factory or app instance in run.py). Flask, along with Flask-SQLAlchemy, provides the web and database integration layer.
PostgreSQL: The relational database used in this project. Ansible installs and configures PostgreSQL on the DB host. A new database and a user are created for the application, and a sample table is set up to demonstrate database migration or initialization via Ansible tasks.
Nginx: The web server / reverse proxy acting as a load balancer in front of the Flask app. Ansible installs Nginx on the LB host and deploys a configuration (from nginx.conf.j2 template) that forwards requests to the Flask application server. This simulates a production-like setup where Nginx can serve static files and proxy API requests to the app, or balance across multiple app servers (though in this simple project, we may have one app server instance).
Docker: Containerization technology is prepared in this project (Ansible installs Docker on the web host via the ansible_decker role). Docker is intended to containerize the Flask application for deployment. In practice, this could mean building a Docker image for the app and running a container. (If fully implemented, one could have Ansible build an image using a Dockerfile and run it, or use Docker Compose). Docker ensures that the application runs in a consistent environment across different servers or environments. In this project, installing Docker sets the stage for containerization — an aspect discussed further in future improvements.
Linux/Ubuntu (target servers): The roles assume an Ubuntu-based system (using apt package manager and UFW firewall). The project indirectly includes technologies like UFW (Uncomplicated Firewall) which is configured via Ansible to allow necessary ports (e.g., opening port 5432 for PostgreSQL access in the ansible_PostgreSQL role), and systemd (for managing services like PostgreSQL and Nginx which are installed from apt).
By leveraging these technologies, the project simulates a realistic web application deployment scenario: code is pushed to Git, CI triggers Ansible to configure servers and deploy the app, resulting in a running web service that is accessible to users.

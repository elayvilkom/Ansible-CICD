# Ansible-CI/CD Pipeline Project

## 📌 Project Overview
This project demonstrates a complete CI/CD pipeline for a web application using *Ansible* for automated provisioning and deployment. It showcases how Ansible can orchestrate a multi-tier application environment – including a *Python Flask* web app, a *PostgreSQL* database, and an *Nginx* load balancer – as part of a continuous integration/continuous delivery process.

By using Ansible in the pipeline, deployments become more *consistent and automated*, reducing manual errors and speeding up the release process.

## 📁 Project Structure

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


## ⚙ Installation and Setup

### 1. Clone the Repository
bash
git clone https://github.com/elayvilkom/Ansible-CICD.git
cd Ansible-CICD


### 2. Install Ansible
bash
pip install ansible


### 3. Install Required Collections
bash
ansible-galaxy collection install community.postgresql community.general


### 4. Install App Requirements
bash
cd app
pip install -r requirements.txt


### 5. Run the Playbook
bash
ansible-playbook -i Ansible/inventory Ansible/playbook.yml


## 🧰 Technologies Used
- Ansible
- Python & Flask
- PostgreSQL
- Nginx
- Docker
- GitHub Actions
- Ubuntu Linux

## 🚀 Future Improvements
- Full Dockerization
- Jenkins or multi-env GitHub Actions
- Kubernetes (K8s) deployment
- Terraform integration
- Secrets Management with Vault
- Monitoring (Prometheus, ELK)

## ✅ Why Ansible for CI/CD?
Ansible ensures repeatable, human-readable, automated deployments that are ideal for building scalable pipelines with minimal manual steps.

---

*This project is designed to demonstrate real DevOps principles in action, suitable for technical interviews and portfolio presentations.*

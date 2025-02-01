# CI/CD Pipeline with Jenkins, Terraform, Ansible, Docker, and GKE

This documentation outlines the complete setup of a **CI/CD pipeline** that automates the deployment of a Java-based application from **GitHub** to **Google Kubernetes Engine (GKE)**. The pipeline is managed with **Jenkins**, **Terraform**, **Ansible**, and monitored using **Prometheus** and **Grafana**.

## **1. Infrastructure Setup**

### **1.1 Created a t.micro Instance for Terraform and Ansible**
- Launched an AWS EC2 `t.micro` instance to act as the control node for running Terraform and Ansible.
- Installed **Terraform** and **Ansible** on this instance.

### **1.2 Used Terraform to Provision Jenkins Infrastructure**
- Created **one Jenkins master** and **one Jenkins worker** using Terraform.
- Configured Terraform to:
  - Set up security groups with necessary ports open (e.g., `22` for SSH, `8080` for Jenkins, `50000` for agent communication).
  - Assign public IP addresses to both instances.
- Stored the generated IP addresses for **Ansible inventory management**.

## **2. Jenkins Installation & Configuration**

### **2.1 Installed Jenkins on Master and Worker Using Ansible**
- Created an **Ansible playbook** to automatically:
  - Install **Jenkins** on both master and worker nodes.
  - Start the Jenkins service.
  - Configure **Java, Git, Docker, and Maven** on the worker node.

### **2.2 Configured Jenkins Master**
- Accessed Jenkins via `http://<jenkins-master-ip>:8080`.
- Installed necessary **Jenkins plugins**:
  - `Git Plugin`
  - `Pipeline Plugin`
  - `Docker Pipeline Plugin`
  - `Kubernetes Plugin`
- Set up the **worker node** to connect with the master using SSH.

## **3. Building and Deploying the Java Application**

### **3.1 Downloaded the Java App and Pushed it to GitHub**
- Downloaded a sample Java application from **Edureka**.
- Created a **GitHub repository** and pushed the Java application to it.

### **3.2 Created a Jenkins Pipeline to Build and Push Docker Image**
- Wrote a **Jenkinsfile** to:
  - Clone the **GitHub repo**.
  - Compile the Java application using **Maven**.
  - Package the compiled `.war` file into a **Docker image**.
  - Push the built image to **Docker Hub**.

## **4. Deploying to Google Kubernetes Engine (GKE)**

### **4.1 Created a Kubernetes Cluster in GCP**
- Provisioned a **Google Kubernetes Engine (GKE)** cluster.
- Configured `kubectl` to communicate with the cluster using:
  ```sh
  gcloud container clusters get-credentials <GKE_CLUSTER_NAME> --zone <GCP_ZONE> --project <PROJECT_ID>
  ```

### **4.2 Deployed the Docker Image to GKE**
- Created Kubernetes **Deployment and Service YAML files** to:
  - Pull the **Docker image** from **Docker Hub**.
  - Run the application in a Kubernetes pod.
  - Expose the service using a **LoadBalancer**.
- Applied the deployment using:
  ```sh
  kubectl apply -f deployment.yaml
  kubectl apply -f service.yaml
  ```

## **5. Monitoring with Prometheus and Grafana**

### **5.1 Installed Prometheus and Grafana on GKE**
- Installed **Prometheus and Grafana** using Helm:
  ```sh
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update
  helm install prometheus prometheus-community/prometheus -n monitoring
  helm install grafana grafana/grafana -n monitoring
  ```

### **5.2 Exposed Grafana and Configured Prometheus as a Data Source**
- Changed **Grafana service type** to `LoadBalancer` to get an external IP:
  ```sh
  kubectl patch svc grafana -n monitoring -p '{"spec":{"type":"LoadBalancer"}}' --type=merge
  ```
- Logged into **Grafana** at `http://<EXTERNAL-IP>`.
- Added **Prometheus** as a data source:
  - URL: `http://prometheus-server.monitoring.svc.cluster.local:80`
  - Saved and tested the connection.

## **6. Summary**

This setup successfully implements a **CI/CD pipeline** that:
- Uses **Terraform** to provision AWS instances for Jenkins.
- Uses **Ansible** to automate Jenkins setup and tool installation.
- Uses **Jenkins** to automate building and pushing the Java application to Docker Hub.
- Deploys the application to **Google Kubernetes Engine (GKE)**.
- Implements monitoring using **Prometheus** and **Grafana**.

This ensures a fully automated, scalable, and observable CI/CD workflow!


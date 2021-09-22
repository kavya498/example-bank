# example-bank terraform automation

This example automates steps mentioned - [here](https://github.com/kavya498/example-bank/tree/satellite#steps)


- [satellite.tf](https://github.com/kavya498/example-bank/blob/satellite/terraform/ibm/satellite.tf) automates following
    - [Create Satellite location](https://github.com/kavya498/example-bank/tree/satellite#create-satellite-location)
    - [Modify the server attachment script](https://github.com/kavya498/example-bank/tree/satellite#modify-the-server-attachment-script)
    - [Create an instance template in IBM-Cloud](https://github.com/kavya498/example-bank/tree/satellite#create-an-instance-template-in-gcp)
        - **NOTE: This template creates hosts in IBM-Cloud instead of GCP.**
    - [Set up firewall rules](https://github.com/kavya498/example-bank/tree/satellite#set-up-firewall-rules)
        - **TODO: As of now Allow all inbound rule is added, It has to be modified accordingly to specified rules in the above link.**
    - [Create virtual systems in the IBM location.](https://github.com/kavya498/example-bank/tree/satellite#create-virtual-systems-in-the-gcp-location)
    - [Attach control plane nodes](https://github.com/kavya498/example-bank/tree/satellite#attach-control-plane-nodes)
    - [Create the OpenShift Cluster](https://github.com/kavya498/example-bank/tree/satellite#create-the-openshift-cluster)
    - [Networking](https://github.com/kavya498/example-bank/tree/satellite#networking)

- [database.tf](https://github.com/kavya498/example-bank/blob/satellite/terraform/ibm/database.tf) automates following
    - [Set up the PostgreSQL database](https://github.com/kavya498/example-bank/tree/satellite#set-up-the-postgresql-database)
    - [Set up PostgreSQL database.](https://github.com/kavya498/example-bank/tree/satellite#set-up-postgresql-database)
        - **TODO: Create Kubernetes secret for database**
- [app.tf.tf](https://github.com/kavya498/example-bank/blob/satellite/terraform/ibm/app.tf) automates following
    - [Set up the App ID service](https://github.com/kavya498/example-bank/tree/satellite#set-up-the-app-id-service)
    - [Creating the link to App ID](https://github.com/kavya498/example-bank/tree/satellite#creating-the-link-to-app-id)
    - **TODO:** [Create Kubernetes secrets](https://github.com/kavya498/example-bank/tree/satellite#create-kubernetes-secrets)
    - ***Just Info:*** [Monitoring Link Endpoints](https://github.com/kavya498/example-bank/tree/satellite#monitoring-link-endpoints)

**TODO:**
- [Deploying Example Bank](https://github.com/kavya498/example-bank/tree/satellite#deploying-example-bank)
- [Introduction to the Mobile Simulator](https://github.com/kavya498/example-bank/tree/satellite#introduction-to-the-mobile-simulator)
- [User authentication](https://github.com/kavya498/example-bank/tree/satellite#user-authentication)
- [Database setup](https://github.com/kavya498/example-bank/tree/satellite#database-setup)
- [Loading the Database Schema](https://github.com/kavya498/example-bank/tree/satellite#loading-the-database-schema)
- [Deploying the Example Bank microservices.](https://github.com/kavya498/example-bank/tree/satellite#deploying-the-example-bank-microservices)
- [Mobile Simulator](https://github.com/kavya498/example-bank/tree/satellite#mobile-simulator)
- [Process Transaction - Serverless Application (Knative Serving)](https://github.com/kavya498/example-bank/tree/satellite#process-transaction---serverless-application-knative-serving)
- [Access the application](https://github.com/kavya498/example-bank/tree/satellite#access-the-application)
- [Erasure service](https://github.com/kavya498/example-bank/tree/satellite#erasure-service)

## Inputs

| Name                                  | Description                                                       | Type     | Default | Required |
|---------------------------------------|-------------------------------------------------------------------|----------|---------|----------|
| ibmcloud_api_key                      | IBM Cloud API Key.                                                | string   | n/a     | yes      |
| resource_group                        | Resource Group Name that has to be targeted.                      | string   | n/a     | yes       |
| region                            | The location or the region in which VM instance exists.           | string   | n/a | yes      |
| location                              | Name of the Location that has to be created                       | string   | n/a     | yes  |
| managed_from                          | The IBM Cloud region to manage your Satellite location from.      | string   | n/a     | yes      |
| resource_prefix                       | Prefix to the Names of all Resources                          | string   | n/a | yes      |
| user_email                      | Email of Application User                                             | string   | n/a     | yes      |
| user_name                      | Name of Application User                                           | string   | n/a     | yes      |
| user_password                      | Password of Application User                           | string   | n/a     | yes      |

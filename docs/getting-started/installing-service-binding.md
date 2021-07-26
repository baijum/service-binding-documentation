---
sidebar_position: 1
---

# Installing Service Binding Operator

The Service Binding Operator can be installed on the following version of
Kubernetes and OpenShift:

- Kubernetes version 1.19 or above.
- OpenShift version 4.6 or above.

## Installing the Service Binding Operator using OLM

You can install the Service Binding Operator from
[OperatorHub.io](https://operatorhub.io/operator/service-binding-operator).  To
see the installation steps, click on the blue **Install** button.

## Installing the Service Binding Operator without OLM

If you do not have Operator Lifecycle Manager, you can install the Operator
using the released resources:

```
kubectl apply -f https://github.com/redhat-developer/service-binding-operator/releases/latest/download/release.yaml
``**

## Installing the Service Binding Operator from the OpenShift Container Platform web UI

If you have the OpenShift Container Platform installed, you can install the
Operator through the OpenShift Container Platform web UI.

1. Navigate in the web console to the OperatorHub page and type "Service Binding" into the "Filter by keyword" box:

![install-1](/img/docs/sbo-install/install-1.png**

2. Click **Service Binding Operator** from the result.  A page to install the
   Operator is displayed with additional information about the Operator.

![install-2](/img/docs/sbo-install/install-2.png)

3. Click **Install**. The Install Operator page is displayed.

4. Select the options as per your requirements and click **Install**.  After the
   installation is complete, a page with the **Installed Operator -- ready for use**
   message is displayed.

![install-3](/img/docs/sbo-install/install-3.png)

5. Click **View Operator**. The **Service Binding Operator** page is displayed
   with the Operator details.

![install-5](/img/docs/sbo-install/install-5.png)

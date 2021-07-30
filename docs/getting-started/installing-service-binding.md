---
sidebar_position: 1
---

# Installing Service Binding Operator

The Service Binding Operator can be installed on the following version of
Kubernetes and OpenShift:

- [Kubernetes version 1.19 or above](#installing-the-service-binding-operator-on-kubernetes).
- [OpenShift version 4.6 or above](#installing-the-service-binding-operator-from-the-openshift-container-platform-web-ui).

## Installing the Service Binding Operator on Kubernetes

You can install the Service Binding Operator using the following methods:

1. Installing the Service Binding Operator using OLM

   a. Go to [OperatorHub.io](https://operatorhub.io/operator/service-binding-operator).

   b. Click on the blue **Install** button.

   c. Follow the instructions to install the Service Binding Operator.

2. Installing the Service Binding Operator without OLM

If you do not have Operator Lifecycle Manager, you can install the Operator
using the released resources:

```
kubectl apply -f https://github.com/redhat-developer/service-binding-operator/releases/latest/download/release.yaml
```

## Installing the Service Binding Operator from the OpenShift Container Platform web UI

Prerequisite:

* [Red Hat OpenShift Container Platform]( https://docs.openshift.com/container-platform/4.8/welcome/index.html.) installed.

1. Navigate in the web console to the OperatorHub page and type "Service Binding" into the "Filter by keyword" box:

![ocp_operathub](/img/docs/sbo-install/ocp_operathub.png)

2. Click **Service Binding Operator** from the result.  A page to install the
   Operator is displayed with additional information about the Operator.

![sbo_intall_landing](/img/docs/sbo-install/sbo_intall_landing.png)

3. Click **Install**. The Install Operator page is displayed.

4. Select the options as per your requirements and click **Install**.  After the
   installation is complete, a page with the **Installed Operator -- ready for use**
   message is displayed.

![sbo_install_options](/img/docs/sbo-install/sbo_install_options.png)

5. Click **View Operator**. The **Service Binding Operator** page is displayed
   with the Operator details.

![sbo_post_install](/img/docs/sbo-install/sbo_post_install.png)

---
sidebar_position: 1
---

# Installing Service Binding

The Service Binding Operator can be installed on the following version of Kubernetes and OpenShift.

- Kubernetes version 1.19 or above.
- OpenShift version 4.6 or above.

## Installing Operator using OLM

You can install ServiceBinding from
[OperatorHub.io](https://operatorhub.io/operator/service-binding-operator).  To
see the installation steps, click on the blue _Install_ button.

## Installing Operator without OLM

If you don't have OLM, you can install the operator using the released resources:

```
kubectl apply -f https://github.com/redhat-developer/service-binding-operator/releases/latest/download/release.yaml
```

## Installing Operator from OpenShift UI

If you have OpenShift installed, you can instal the operator through the UI.

First navigate to OperatorHub and search for "Service Binding":

![install-1](/img/docs/sbo-install/install-1.png)

Once you select and click the "Service Binding Operator" from the result, it will show the page to install.

![install-2](/img/docs/sbo-install/install-2.png)

After click on install, it will show a page with few options.  You can click on the "Install" button again:

![install-3](/img/docs/sbo-install/install-3.png)

After some time you should see a page with message: "Installed Operator -- ready for use".

![install-4](/img/docs/sbo-install/install-4.png)

If you click on the "View Operator" page, you can see more details about the
operator:

![install-5](/img/docs/sbo-install/install-5.png)

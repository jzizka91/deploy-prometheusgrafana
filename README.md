# Prometheus & Grafana deployment on AKS with Helm.

## Required tools:

* Helm - The package manager for Kubernetes.
* kubectl - Kubernetes command-line tool.
* AKS-cli - Azure command-line interface.

## Tools Installation:

**Install helm ->** https://helm.sh/docs/intro/install/ +
**Install kubectl ->** https://kubernetes.io/docs/tasks/tools/install-kubectl/ +
**Install AKS-cli ->** https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest

## Connect to AKS:

**1.** Login to your azure account:
```bash
az login
```

**2.** Set default subscription:
```bash
az account set --subscription <subscription>>
```

**3.** Get AKS ~/.kube/config:
```bash
az aks get-credentials --resource-group <resource-group> --name <name>
```

**4.** Set context to it:
```bash
kubectl config use-context <context>
```

## Deploy Prometheus & Grafana into AKS:

**1.** Clone this repository (with SSH):

```bash
git clone git@github.com:jzizka91/deploy-prometheusgrafana.git
```

**2.** Run install_prometheus script

```bash
bash install_prometheus
```
The script will create a new namespace "monitoring" if it doesn't exist yet, and deploy Prometheus and Grafana into AKS with predefined simple custom configuration by using prometheus.yaml file. The script can also be used for deploying configuration changes made to `prometheus-operator.yaml` file.

* `prometheus-operator.yaml` file is used to overwrite original configuration values with custom values. 
* All custom configuration changes can be seen in `changelog_prometheus` file.

## Usage 

**Access Grafana (internally)**

**1.** Get the Pod name and store it in the environment variable $POD_NAME:
```bash
export POD_NAME=$(kubectl get pods --namespace monitoring -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep grafana)
```

**2.** Expose grafana port within the cluster:
```bash
kubectl --namespace monitoring port-forward $POD_NAME 3000
```

**3.** Open Grafana in Browser:

```bash
127.0.0.1:3000
```

**Access Grafana (externally)**

Since Grafana was deployed with service type "LoadBalancer" we can access Grafana externally by using external IP address which was automatically assigned to Grafana.

**1.** Get Grafana assigned external IP address:
```bash
export EXT_IP=$(kubectl get services --namespace monitoring prometheus-grafana --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}") && echo "Grafana external IP address is: $EXT_IP"
```

**2** Copy external IP address and use it to access Grafana via Browser.

Login: admin | admin

**Grafana Dashboards**

There is many Dashboards you can choose from -> link:https://grafana.com/grafana/dashboards?direction=asc&orderBy=name&dataSource=prometheus[Grafana Dashboards] +
Grafana is currenty using this Dashboard -> link:https://grafana.com/grafana/dashboards/11074[Node Exporter for Prometheus Dashboard]

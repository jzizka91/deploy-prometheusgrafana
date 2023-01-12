#!/bin-bash
# Delete Prometheus-operator
echo "Deleting Prometheus"
helm uninstall prometheus --namespace monitoring
kubectl -n monitoring delete crd --all
kubectl delete namespace monitoring --cascade=true
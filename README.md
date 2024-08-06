# Create kubernetes Cluster

## export civo token

first make sure to delete any existing cluster details, network, firewall then;


```
export CIVO_TOKEN=<token>
```

## first create the cluster and create config file to access it

```
terraform apply -target=civo_kubernetes_cluster.kubefirst
```

### apply the rest of the plan

```
terraform apply
```
The details of login into argocd will be in the output of the script


### to interact with the cluster from the command line

```
export KUBECONFIG=./kubeconfig
```

The details of login into argocd will be in the output of the script

you can then install the rest of it

```
kubectl apply -f kafka-application.yaml
```

then the rest of linkerd;

```
kubectl apply -f ../../istio-1.22.3/samples/addons/
```

then you can start port forwarding

```
kubectl port-forward kiali-db7b677-r5bdz 20001 -n istio-system
```


# To Destroy

# list all resources
terraform state list

# remove that resource you don't want to destroy
# you can add more to be excluded if required
terraform state rm local_file.kubeconfig 

# destroy the whole stack except above excluded resource(s)
terraform destroy 

# setting up terraform

firstly do auto sidecar injection
```
kubectl label namespace default istio-injection=enabled
kubectl label namespace snowplow istio-injection=enabled
kubectl label namespace web istio-injection=enabled
kubectl get ns -Listio-injection
```

Get ingress gateway

```
export GATEWAY_IP=$(kubectl get svc -n istio-system gateway \  
    -ojsonpath='{.status.loadBalancer.ingress[0].ip}')
```

now first create a ingress gateway. The selector istio: 'gateway' selects the Envoy gateway workload to be configured, the one residing in the istio-system namespace.

```
kubectl apply -f gateway.yaml
```

then the virtual services

```
kubectl apply -f web-virtualservice.yaml
kubectl apply -f websocket-virtualservice.yaml

```
## P.S to configure certs : https://tetratelabs.github.io/istio-0to60/ingress/#create-a-virtualservice-resource

# lets enablre observability

```
kubectl apply -f addons/
kubectl apply -f addons/extras/zipkin.yaml
```

followed by some configs to enable the tracing:

```
istioctl install -f trace-config.yaml

kubectl apply -f enable-tracing.yaml
```

then let the fun begin

```
istioctl dashboard kiali
istioctl dashboard zipkin
istioctl dashboard prometheus
istioctl dashboard grafana
```
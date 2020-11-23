// main template for coredns
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.coredns;

local configmap = kube.ConfigMap(params.configMapName) {
  metadata+: {
    namespace: params.namespace,
    labels+: {
      'app.kubernetes.io/component': 'coredns',
      'app.kubernetes.io/managed-by': 'commodore',
    },
  },
  data: {
        "Corefile": ".:53 {\n    errors\n    health\n    ready\n    kubernetes cluster.local in-addr.arpa ip6.arpa {\n      pods insecure\n      upstream\n      fallthrough in-addr.arpa ip6.arpa\n    }\n    hosts /etc/coredns/NodeHosts {\n      reload 1s\n      fallthrough\n    }\n    prometheus :9153\n    forward . /etc/resolv.conf\n    cache 30\n    loop\n    reload\n    loadbalance\n    k8s_external ext.cluster.local\n}\n",
        "NodeHosts": "192.168.176.2 k3d-haproxy-test-server-0\n192.168.176.1 host.k3d.internal\n"
    },
};

// Define outputs below
{
    '10_custom_config': configmap,
}

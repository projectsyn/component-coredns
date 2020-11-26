local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.coredns;
local instance = inv.parameters._instance;

local configmap = kube.ConfigMap(params.configMapName) {
  metadata+: {
    namespace: params.namespace,
    labels+: {
      'app.kubernetes.io/component': 'coredns',
      'app.kubernetes.io/instance': instance,
      'app.kubernetes.io/managed-by': 'commodore',
    },
  },
  data: {
    Corefile: params.baseConfig % params.extraConfig,
  },
};

{
  '10_coredns_config': configmap,
}

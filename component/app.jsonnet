local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.coredns;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('coredns', params.namespace, secrets=false);

{
  coredns: app,
}

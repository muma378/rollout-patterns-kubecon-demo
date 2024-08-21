# Dubbo Spring Boot Sample CD

This repo demonstrates how to continuos deploy a service consists of multiple versioned microservices.

The application consists of 2 microservices: `provider` and `consumer`, both are implemented using [zhuohao.li/dubbo-spring-boot-samples-upgrade](https://gitlab.daocloud.cn/zhuohao.li/dubbo-spring-boot-samples-upgrade).

They talk in the following way:

client -> gateway -> consumer -> provider

We have 3 branches:

1. `release-v1.0`: the initial version of the service, with `provider` version `1.0` and `consumer` version `1.0`.
2. `release-v2.0`: the upgraded version of the service, with newly created version `2.0` respectively;
3. `release-v3.0`: the upgraded version of the service, with newly created version `3.0` respectively, and removed the old version `1.0`;

gateway的实例是由管理员提前在集群中部署好的，provider和consumer服务以及相应的策略通过 gitops 部署。

还需要创建如下Service和AuthorizationPolicy

```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: istio-ingressgateway
    istio: ingressgateway
  name: istio-ingressgateway
  namespace: istio-system
spec:
  ports:
    - name: dubbo-boot
      nodePort: 31381
      port: 9090
      protocol: TCP
      targetPort: 9090
  selector:
    app: istio-ingressgateway
    istio: ingressgateway
  type: NodePort
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: dubbo
  namespace: istio-system
spec:
  rules:
  - to:
    - operation:
        paths:
        - /hello*
  - from:
    - source:
        requestPrincipals:
        - '*'
  selector:
    matchLabels:
      app: istio-ingressgateway
```

## How to validate？

假设gateway通过NodePort访问，节点IP是 `172.30.40.54`，打开浏览器访问:

http://172.30.40.54:31381/hello?name=test-v1

返回provider/consumer 都是 v1 版本的Pod

访问 http://172.30.40.54:31381/hello?name=test-v2

返回provider/consumer 都是 v2 版本的Pod


#### legacy/v1


（不能通过浏览器访问）
curl -s "http://172.30.40.52:32583/hello"  -H "lane: test-v2" | jq '.provider.hostname, .hostname'

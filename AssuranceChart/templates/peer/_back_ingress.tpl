{{- define "back.ingress" }}
{{- $orgName := .orgName }}
{{- $orgNameLower := $orgName | lower}}
{{- $tag := .tag }}
{{- $ingressHost := .ingressHost -}}

apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: back-{{$orgNameLower}}
  labels:
    tag: {{ $tag }}
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/proxy-connect-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/send-timeout: "3600"
    ingress.kubernetes.io/add-base-url: "true"
{{ toYaml . | indent 4 }}
spec:
  rules:
    - host: www.{{$orgNameLower}}.{{ $tag}}.{{ $ingressHost }}
      http:
        paths:
        - path: /api
          backend:
            serviceName: "back-{{$orgNameLower}}"
            servicePort: 4000
---
{{- end }}

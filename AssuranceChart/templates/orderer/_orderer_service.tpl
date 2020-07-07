{{ define "orderer.service" }}

{{- $app := .app }}

{{- $orgNameLower := .orgName | lower}}

apiVersion: v1
kind: Service
metadata:
  name: orderer0
spec:
 selector:
      app: {{ $app }}
      role: orderer
      orderer-id: "{{ $orgNameLower }}0"
 ports:
   - name: listen-endpoint
     protocol: TCP
     port: 7050
     targetPort: 7050
---
{{ end }}
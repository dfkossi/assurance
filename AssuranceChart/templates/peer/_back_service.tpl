{{- define "back.service" }}

{{- $app := .app }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}

apiVersion: v1
kind: Service
metadata:
  name: back-{{ $orgNameLower }}
spec:
  selector:
    app: {{ $app }}
    role: back
    org: {{ $orgNameLower }}
  type: NodePort
  ports:
    - name: backend-peer
      protocol: TCP
      port: 4000
      targetPort: 4000
    - name: ws
      protocol: TCP
      port: 7000
      targetPort: 7000
---
{{- end }}
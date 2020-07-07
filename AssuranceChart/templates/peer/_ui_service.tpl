{{- define "ui.service" }}

{{- $app := .app }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}

apiVersion: v1
kind: Service
metadata:
  name: ui-{{ $orgNameLower }}
spec:
  selector:
    app: {{ $app }}
    role: ui
    org: {{ $orgName | lower }}
  type: NodePort
  ports:
    - name: ui-peer
      protocol: TCP
      port: 3000
      targetPort: 3000
---
{{- end }}
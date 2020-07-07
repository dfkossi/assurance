
{{ define "back.postgres" }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}

apiVersion: kubedb.com/v1alpha1
kind: Postgres
metadata:
  name: "postgres-{{$orgNameLower}}"
spec:
  version: '11.1'
  storageType: Durable
  storage:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: 100Mi
  terminationPolicy: Delete
  
---
{{ end }}

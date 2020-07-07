{{ define "ui.deployment" }}

{{- $app := .app }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}
{{- $orgDomainName := .orgDomainName }}
{{- $tag := .tag }}
{{- $repoUi := .repoUi}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name:	{{ "ui" }}-{{ $orgNameLower }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $app }}
      role: ui
      org: {{ $orgNameLower }}
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
       app: {{ $app }}
       role: ui
       org: {{ $orgNameLower }}
    spec:
      imagePullSecrets:
        - name: scorechain-registry
      containers:
      - name: ui
        image: "registry.scorechain.com/assurance/assurance/assurance-ui:{{ $tag }}"
        imagePullPolicy: Always
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        env:
          - name: TAG
            value: {{$tag}}
          - name: ACTOR
            value: {{ $orgNameLower }}
---
{{ end }}
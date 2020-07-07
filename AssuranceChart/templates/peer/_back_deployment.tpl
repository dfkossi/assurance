{{ define "back.deployment" }}
{{- $app := .app }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}
{{- $orgDomainName := .orgDomainName }}
{{- $tag := .tag }}

{{- $cryptoPath := "crypto-config" }}
{{- $varPath := "var" }}

{{- $orgPath := printf "%s/peerOrganizations/%s" $cryptoPath $orgDomainName }}
{{- $cryptoUserPath := printf "%s/users/Admin@%s" $orgPath $orgDomainName }}
{{- $localMSPID :=  printf "%s" $orgName }}

apiVersion: apps/v1
kind: Deployment
metadata:
  name:	{{ "back" }}-{{ $orgName | lower }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $app }}
      role: back
      org: {{ $orgName | lower }}
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
       app: {{ $app }}
       role: back
       org: {{ $orgName | lower }}
    spec:
      containers:            
      - name: backend
        image: "dfkossi/assurance/assurance-backend:{{ $tag }}"
        imagePullPolicy: Always
        volumeMounts:
          - mountPath: /cryptogen
            name: shared
        ports:
          - name: http
            containerPort: 4000
            protocol: TCP
          - name: ws
            containerPort: 7000
            protocol: TCP
        env:
          - name: TAG
            value: {{ $tag }}
          - name: CORE_USER_MSP_CONFIGPATH
            value: /etc/hyperledger/fabric/msp
          - name: CORE_PEER_LOCALMSPID
            value: {{ $localMSPID }}
          - name: POSTGRES_HOST 
            value: "postgres-{{$orgNameLower}}"
          - name: POSTGRES_PASSWORD
            valueFrom:
              secretKeyRef:
                name: "postgres-{{$orgNameLower}}-auth"
                key: POSTGRES_PASSWORD
          - name: POSTGRES_USER
            valueFrom:
              secretKeyRef:
                name: "postgres-{{$orgNameLower}}-auth"
                key: POSTGRES_USER
        volumeMounts:
         - mountPath: /etc/hyperledger/fabric/msp
           name: shared
           subPath: {{ $cryptoUserPath }}/msp
         - mountPath: /etc/hyperledger/fabric/tls
           name: shared
           subPath: {{ $cryptoUserPath }}/tls
      volumes:
        - name: shared
          persistentVolumeClaim:
             claimName: assurance-shared
---
{{ end }}
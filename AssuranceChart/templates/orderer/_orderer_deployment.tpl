{{ define "orderer.deployment" }}

{{- $app := .app }}
{{- $tag := .tag }}
{{- $fabricVersion := .fabricVersion }}
{{- $fabricSubComponentVersion := .fabricSubComponentVersion }}

{{- $orgName := .orgName }}
{{- $orgDomainName := .orgDomainName }}

{{- $cryptoPath := "crypto-config" }}
{{- $varPath := "var" }}

{{- $orgNameLower := .orgName | lower}}
{{- $orgPath := printf "%s/ordererOrganizations/%s" $cryptoPath $orgDomainName }}
{{- $cryptoOrdererPath := printf "%s/orderers/orderer.%s" $orgPath $orgDomainName }}
{{- $varOrdererPath := printf "%s/%s.%s" $varPath $orgNameLower $orgDomainName }}
{{- $peerFDQN := printf "%s.%s" "orderer0" $orgDomainName }}

{{- $localMSPID := "OrdererMSP" }}
{{- $ordererID := printf "%s.%s" "orderer0" $orgDomainName }}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: "{{ $orgNameLower }}0"
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $app }}
      role: orderer
      orderer-id: "{{ $orgNameLower }}0"
  strategy: {}
  template:
    metadata:
      labels:
        app: {{ $app }}
        role: orderer
        orderer-id: "{{ $orgNameLower }}0"
    spec:
      containers:     
      - name: {{ "orderer0" }}
        image: hyperledger/fabric-orderer:amd64-{{ $fabricVersion }}
        env:
        - name: ORDERER_GENERAL_LOGLEVEL
          value: verbose
        - name: ORDERER_GENERAL_LISTENADDRESS
          value: 0.0.0.0
        - name: ORDERER_GENERAL_GENESISMETHOD
          value: file
        - name: ORDERER_GENERAL_GENESISFILE
          value: /var/hyperledger/genesis/orderer.genesis.block
        - name: ORDERER_GENERAL_LOCALMSPID
          value: {{ $localMSPID }}
        - name: ORDERER_GENERAL_LOCALMSPDIR
          value: /var/hyperledger/orderer/msp
        - name: ORDERER_GENERAL_TLS_ENABLED
          value: "false"
        - name: ORDERER_GENERAL_TLS_PRIVATEKEY
          value: /var/hyperledger/orderer/tls/server.key
        - name: ORDERER_GENERAL_TLS_CERTIFICATE
          value: /var/hyperledger/orderer/tls/server.crt
        - name: ORDERER_GENERAL_TLS_ROOTCAS
          value: '[/var/hyperledger/orderer/tls/ca.crt]'
        ports:
         - containerPort: 7050 
        workingDir: /opt/gopath/src/github.com/hyperledger/fabric/peer
        ports:
         - containerPort: 7050
        command: ["/bin/bash", "-c", "--"]
        args: ["orderer"]
        volumeMounts:
         - mountPath: /var/hyperledger/orderer 
           name: shared
           subPath: {{ $cryptoOrdererPath }}
         - mountPath: /var/hyperledger/genesis/
           name: shared
           subPath: {{ $varOrdererPath }}/genesis/
         - mountPath: /var/hyperledger/production/
           name: shared
           subPath: {{ $varOrdererPath }}/production/
      volumes:
       - name: shared
         persistentVolumeClaim:
             claimName: assurance-shared
---
{{ end }}
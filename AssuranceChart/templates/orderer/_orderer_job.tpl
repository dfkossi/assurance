{{ define "orderer.job" }}

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

apiVersion: batch/v1
kind: Job
metadata:
  name: setup-{{ $orgNameLower }}
spec:
  template:
    spec:
      containers:     
      - name: orderer-actions
        image: hyperledger/fabric-tools:amd64-{{ $fabricVersion }}
        env:
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
        - name: CORE_PEER_MSPCONFIGPATH
          value: /cryptogen/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/
        - name: TEST
          value: {{ $orgNameLower }}

        workingDir: /cryptogen
        command: [ "/bin/bash", "-c" ]
        args: ["/cryptogen/app/configure-orderer {{ "orderer0" }} {{ $orgNameLower }}"]

        volumeMounts:
         - mountPath: /cryptogen
           name: shared 
      restartPolicy: OnFailure  
      volumes:
       - name: shared
         persistentVolumeClaim:
             claimName: assurance-shared
---
{{ end }}
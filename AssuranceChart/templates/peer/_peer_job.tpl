{{ define "peer.job" }}

{{- $app := .app }}
{{- $tag := .tag }}
{{- $fabricVersion := .fabricVersion }}
{{- $fabricSubComponentVersion := .fabricSubComponentVersion }}

{{- $orgName := .orgName }}
{{- $orgDomainName := .orgDomainName }}


{{- $cryptoPath := "crypto-config" }}
{{- $varPath := "var" }}

{{- $orgNameLower := .orgName | lower}}
{{- $peerFDQN := printf "%s.%s" "peer0" $orgDomainName }}
{{- $localMSPID :=  printf "%s" $orgName }}
{{- $orgPath := printf "%s/peerOrganizations/%s" $cryptoPath $orgDomainName }}
{{- $cryptoPeerPath := printf "%s/peers/%s" $orgPath $peerFDQN }}
{{- $cryptoUserPath := printf "%s/users/Admin@%s" $orgPath $orgDomainName }}
{{- $varPeerPath := printf "%s/%s" $varPath $peerFDQN }}

apiVersion: batch/v1
kind: Job
metadata:
  name:	setup-{{ $orgNameLower }}
spec:
  template:
    spec:
      containers:
      - name: peer-actions
        image: hyperledger/fabric-tools:amd64-{{ $fabricVersion }}                 
        env:
        - name: FABRIC_CFG_PATH
          value: /etc/hyperledger/fabric           
        - name: CORE_PEER_LOCALMSPID
          value: {{ $orgName }}
        - name: CORE_PEER_TLS_ROOTCERT_FILE
          value: {{ $cryptoPeerPath }}/tls/ca.crt
        - name: CORE_PEER_ADDRESS
          value: peer0-{{ $orgNameLower }}:7051
        - name: CORE_PEER_MSPCONFIGPATH
          value: /cryptogen/crypto-config/peerOrganizations/{{ $orgNameLower }}.example.com/users/Admin@{{ $orgNameLower }}.example.com/msp/
        workingDir: /cryptogen
        command: [ "/bin/bash", "-c" ]
        args: ["/cryptogen/app/configure-peer peer0 {{ $orgName | lower }}"]
        volumeMounts:
          - mountPath: /etc/hyperledger/fabric/msp
            name: shared
            subPath: {{ $cryptoPeerPath }}/msp
          - mountPath: /etc/hyperledger/fabric/tls
            name: shared
            subPath: {{ $cryptoPeerPath }}/tls
          - mountPath: /cryptogen
            name: shared
      restartPolicy: OnFailure
      volumes:
        - name: shared
          persistentVolumeClaim:
              claimName: "assurance-shared"
        - name: run
          hostPath:
            path: /var/run
---
{{ end }}
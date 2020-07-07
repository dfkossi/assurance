{{ define "peer.deployment" }}

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

{{- $varPeerPath := printf "%s/%s" $varPath $peerFDQN }}

apiVersion: apps/v1
kind: Deployment
metadata:
  name:	peer0-{{ $orgNameLower }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ $app }}
      role: peer
      peer-id: peer0-{{ $orgNameLower }}
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
       app: {{ $app }}
       role: peer
       peer-id: peer0-{{ $orgNameLower }}
    spec:
      containers:
      - name: couchdb
        image: hyperledger/fabric-couchdb:amd64-{{ $fabricSubComponentVersion }}
        ports:
         - containerPort: 5984
      - name: peer
        image: hyperledger/fabric-peer:amd64-{{ $fabricVersion }}
        env:
        - name: CORE_PEER_ADDRESSAUTODETECT
          value: "true"
        - name: CORE_LEDGER_STATE_STATEDATABASE
          value: "CouchDB"
        - name: CORE_LEDGER_STATE_COUCHDBCONFIG_COUCHDBADDRESS
          value: "localhost:5984"
        - name: CORE_VM_ENDPOINT
          value: "unix:///host/var/run/docker.sock"
        - name: CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE
          value: "bridge"
        - name: CORE_LOGGING_LEVEL
          value: "DEBUG"
        - name: CORE_PEER_TLS_CERT_FILE
          value: "/etc/hyperledger/fabric/tls/server.crt" 
        - name: CORE_PEER_TLS_KEY_FILE
          value: "/etc/hyperledger/fabric/tls/server.key"
        - name: CORE_PEER_TLS_ROOTCERT_FILE
          value: "/etc/hyperledger/fabric/tls/ca.crt"
        - name: CORE_LOGGING_LEVEL
          value: "DEBUG"
        - name: CORE_PEER_TLS_ENABLED
          value: "false"
        - name: CORE_PEER_GOSSIP_USELEADERELECTION
          value: "true"
        - name: CORE_PEER_GOSSIP_ORGLEADER
          value: "false"
        - name: CORE_PEER_PROFILE_ENABLED
          value: "false"
        - name: CORE_PEER_ID
          value: {{ $peerFDQN }}
        - name: CORE_PEER_LOCALMSPID
          value: {{ $localMSPID }}       
        - name: CORE_PEER_GOSSIP_EXTERNALENDPOINT
          value: "peer0-{{ $orgName | lower }}:7051"
        - name: CORE_CHAINCODE_STARTUPTIMEOUT
          value: "300s"
        - name: CORE_CHAINCODE_LOGGING_LEVEL
          value: "DEBUG"
        workingDir: /opt/gopath/src/github.com/hyperledger/fabric/peer
        ports:
         - containerPort: 7051
         - containerPort: 7052
         - containerPort: 7053
        command: ["/bin/bash", "-c", "--"]
        args: ["peer node start"]
        volumeMounts:
         - mountPath: /etc/hyperledger/fabric/msp
           name: shared
           subPath: {{ $cryptoPeerPath }}/msp
         - mountPath: /etc/hyperledger/fabric/tls
           name: shared
           subPath: {{ $cryptoPeerPath }}/tls
         - mountPath: /var/hyperledger/production
           name: shared
           subPath: {{ $varPeerPath }}/production
         - mountPath: /host/var/run
           name: run
      volumes:
        - name: shared
          persistentVolumeClaim:
             claimName: assurance-shared
        - name: run
          hostPath:
            path: /var/run
---
{{ end }}
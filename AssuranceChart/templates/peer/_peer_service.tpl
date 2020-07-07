{{- define "peer.service" }}

{{- $app := .app }}
{{- $orgName := .orgName }}
{{- $orgNameLower := .orgName | lower}}

apiVersion: v1
kind: Service
metadata:
  name: peer0-{{ $orgNameLower }}
spec:
  selector:
    app: {{ $app }}
    role: peer
    peer-id: peer0-{{ $orgNameLower }}
  ports:
    - name: listen-endpoint
      protocol: TCP
      port: 7051
      targetPort: 7051
    - name: chaincode-listen
      protocol: TCP
      port: 7052
      targetPort: 7052
    - name: listen
      protocol: TCP
      port: 7053
      targetPort: 7053
---
{{- end }}
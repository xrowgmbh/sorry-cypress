{{- if .Values.s3.ingress.enabled -}}
{{- $fullName := include "sorry-cypress-helm.fullname" . -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ $fullName }}-s3
  labels:
    {{- include "sorry-cypress-helm.labels" . | nindent 4 }}
    {{- with .Values.s3.ingress.labels }}
    {{- toYaml . | nindent 4 }}
    {{- end}}
  {{- with .Values.s3.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.s3.ingress.tls }}
  tls:
    {{- range .Values.s3.ingress.tls }}
    - hosts:
        {{- range .hosts }}
        - {{ . | quote }}
        {{- end }}
      secretName: {{ .secretName }}
    {{- end }}
  {{- end }}
  rules:
    {{- range .Values.s3.ingress.hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          - path: {{ .path | default "/" }}
            backend:
              servicePort: 80
              serviceName: {{ $fullName }}-s3
    {{- end }}
  {{- end }}
{{/*
Expand the name of the chart.
*/}}
{{- define "lighterpack.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec).
*/}}
{{- define "lighterpack.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Name of the bundled MongoDB service/statefulset.
*/}}
{{- define "lighterpack.mongodb.fullname" -}}
{{- printf "%s-mongodb" (include "lighterpack.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
The effective databaseUrl: an explicit config.databaseUrl wins; otherwise
point at the bundled MongoDB, or fail if neither is available.
*/}}
{{- define "lighterpack.databaseUrl" -}}
{{- if .Values.config.databaseUrl }}
{{- .Values.config.databaseUrl }}
{{- else if .Values.mongodb.enabled }}
{{- printf "%s/%s" (include "lighterpack.mongodb.fullname" .) .Values.mongodb.database }}
{{- else }}
{{- fail "config.databaseUrl is required when mongodb.enabled is false" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lighterpack.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lighterpack.labels" -}}
helm.sh/chart: {{ include "lighterpack.chart" . }}
{{ include "lighterpack.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lighterpack.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lighterpack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

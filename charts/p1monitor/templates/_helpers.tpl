{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "p1monitor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "p1monitor.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "p1monitor.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "p1monitor.labels" -}}
app.kubernetes.io/name: {{ include "p1monitor.name" . }}
helm.sh/chart: {{ include "p1monitor.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Allow overriding registry and repository for air-gapped environments
*/}}
{{- define "p1monitor.image" -}}
{{- if .Values.image.overrideValue -}}
    {{- .Values.image.overrideValue -}}
{{- else -}}
    {{- $imageRegistry := .Values.image.registry -}}
    {{- $imageRepository := .Values.image.repository -}}
    {{- $imageTag := .Values.image.tag -}}
    {{- $globalRegistry := (default .Values.global dict).imageRegistry -}}
    {{- $globalRegistry | default $imageRegistry | default "docker.io" -}} / {{- $imageRepository -}} : {{- $imageTag -}}
{{- end -}}
{{- end -}}
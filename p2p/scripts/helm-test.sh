#!/bin/bash
set -euo pipefail

type=$1
namespace=$2
app_name=$3
scale_down=${4:-false}
timeout=${5:-"3m"}
test_name=${6:-$app_name-$type-test}

printLogs() {
	current_timestamp=$(date +%s)
	logs_url="https://grafana.${INTERNAL_SERVICES_DOMAIN}/explore?orgId=1&left=%7B%22datasource%22:%22CloudLogging%22,%22queries%22:%5B%7B%22refId%22:%22A%22,%22queryText%22:%22resource.type%3D%5C%22k8s_container%5C%22%5Cnresource.labels.namespace_name%3D%5C%22${namespace}%5C%22%5Cnresource.labels.pod_name%3D%5C%22${test_name}%5C%22%22,%22projectId%22:%22${PROJECT_ID}%22,%22bucketId%22:%22global%2Fbuckets%2F_Default%22,%22viewId%22:%22_AllLogs%22%7D%5D,%22range%22:%7B%22from%22:%22${logs_start}000%22,%22to%22:%22${current_timestamp}000%22%7D%7D"

	echo "Logs: $logs_url"
}

scaleDownApp() {
	if [ "${scale_down}" = "true" ] ; then
		echo "Scaling down apps on namespace ${namespace}"
		kubectl -n "${namespace}" scale --replicas=0 deployments,statefulsets --all || echo "Failed to scale down deployments/statefulsets"
	else
		echo "Not scaling down apps on namespace ${namespace}"
	fi
}

trap 'printLogs && scaleDownApp' SIGINT SIGTERM EXIT
logs_start=$(date +%s)

helm test "${app_name}" -n "${namespace}" --filter name="${test_name}" --timeout "${timeout}"

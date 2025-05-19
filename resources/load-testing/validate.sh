#!/bin/bash
set -euo pipefail

promtool query instant -o json "${PROMETHEUS_ENDPOINT}" \
	"avg(k6_http_req_duration{quantile=\"0.99\", namespace=\"${NAMESPACE}\", expected_response=\"true\"}) > 500" \
	| grep -wq "\[\]" || (echo "Failed p(99) < 500ms" && false)

promtool query instant -o json "${PROMETHEUS_ENDPOINT}" \
	"sum(rate(http_server_requests_seconds_count{namespace=\"${NAMESPACE}\"}[${DURATION}])) < ${REQ_PER_SECOND}*0.9" \
	| grep -wq "\[\]" || (echo "Failed ${REQ_PER_SECOND} TPS" && false)

echo "Passed"
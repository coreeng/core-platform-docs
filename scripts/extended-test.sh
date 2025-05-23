#!/bin/bash
set -euo pipefail

type=$1
namespace=$2
app_name=$3
scale_down=${4:-false}
timeout=${5:-"3m"}
test_name=${6:-$app_name-$type-test}

bash scripts/helm-test.sh "${type}" "${namespace}" "${app_name}" false "${timeout}" "${test_name}"

kubectl wait --for=jsonpath='{.status.stage}'=finished "testrun/${test_name}" -n "${namespace}" --timeout "${timeout}"

bash scripts/helm-test.sh "${type}" "${namespace}" "${app_name}" "${scale_down}" "${timeout}" "${test_name}-validate"
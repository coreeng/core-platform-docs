import { check } from "k6";
import http from "k6/http";

const SERVICE_ENDPOINT = __ENV.SERVICE_ENDPOINT || "http://reference-service";
const REQ_PER_SECOND = __ENV.REQ_PER_SECOND || 1000;
const VUS = __ENV.VUS || 200;

export const options = {
  summaryTrendStats: ["avg", "min", "med", "max", "p(95)", "p(99)"],
  scenarios: {
    loadTest: {
      executor: "constant-arrival-rate",
      rate: REQ_PER_SECOND,
      timeUnit: "1s", // iterations per second
      duration: "1m",
      preAllocatedVUs: VUS, // how large the initial pool of VUs would be
    },
  },
  thresholds: {
    checks: ["rate>0.99"],
    http_reqs: ["rate>" + REQ_PER_SECOND * 0.8],
    http_req_failed: ["rate<0.01"],
    http_req_duration: ["p(99)<2000"],
  },
  tags: {
    test_name: "hello",
  },
};

export default function () {
  const res = http.get(`${SERVICE_ENDPOINT}/readyz`);
  check(res, {
    "status is 200": (r) => r.status === 200,
    "response body is correct": (r) => r.body.includes("OK"),
  });
}

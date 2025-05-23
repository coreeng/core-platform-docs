package functional

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/cucumber/godog"
	"github.com/go-resty/resty/v2"
)

var baseUri = getBaseURI()
var request *resty.Request
var response resty.Response

func getBaseURI() string {
	serviceEndpoint := os.Getenv("SERVICE_ENDPOINT")

	if serviceEndpoint == "" {
		panic("SERVICE_ENDPOINT environment variable is not set")
	}
	return serviceEndpoint
}

func TestFeatures(t *testing.T) {
	suite := godog.TestSuite{
		ScenarioInitializer: InitializeScenario,
		Options: &godog.Options{
			Format:   "pretty",
			Paths:    []string{"features"},
			TestingT: t,
		},
	}

	if suite.Run() != 0 {
		t.Fatal("non-zero status returned, failed to run feature tests")
	}
}

func InitializeScenario(ctx *godog.ScenarioContext) {
	ctx.Step(`^that the service is running$`, initialiseRestClient)
	ctx.Step(`^I call the healthcheck endpoint$`, iCallTheHealthCheckEndpoint)
	ctx.Step(`^an ok response is returned$`, anOkResponseIsReturned)
}

func initialiseRestClient() {
	httpClient := resty.New()
	request = httpClient.R()
}

func iCallTheHealthCheckEndpoint(ctx context.Context) error {
	godog.Logf(ctx, "Calling %s", baseUri)
	httpResponse, err := request.Get(baseUri + "/readyz")

	if err != nil {
		return fmt.Errorf("call to %s was unsuccessful, error: %v", baseUri, err)
	}

	response = *httpResponse
	return nil
}

func anOkResponseIsReturned(ctx context.Context) error {
	godog.Logf(ctx, "Response: %s", response.String())
	if response.IsSuccess() == true {
		return nil
	}
	return fmt.Errorf("response not successful, response code: %d, error: %v", response.StatusCode(), response.Error())
}

package main

import (
	"context"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func main( ) {
	lambda.Start(handler)
}

func handler(ctx context.Context, event events.APIGatewayV2CustomAuthorizerV2Request) (events.APIGatewayV2CustomAuthorizerSimpleResponse, error) {

	// No authorization token not found.
	if len(event.IdentitySource) == 0 {
		response := events.APIGatewayV2CustomAuthorizerSimpleResponse{
			IsAuthorized: false,
		}
		return response, nil
	}

	authorizationToken := event.IdentitySource[0]

	isAuthorized := false

	if authorizationToken == "test" {
		isAuthorized= true
	}

	response := events.APIGatewayV2CustomAuthorizerSimpleResponse{
		IsAuthorized: isAuthorized,
	}
	return response, nil
}
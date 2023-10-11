package main

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func getHandler( ) events.APIGatewayProxyResponse {

	return events.APIGatewayProxyResponse {
		StatusCode: http.StatusOK,
		Headers: map[string]string{},

		Body: "Hello, world!",
	}
}

func handler(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	log.Println("Received a request! Executing Lambda function")

	httpMethod := request.HTTPMethod
	switch httpMethod {
		case "GET":
			return getHandler( ), nil

		default:
			return events.APIGatewayProxyResponse{ StatusCode: http.StatusBadRequest },
						 fmt.Errorf("HTTP method %s not supported", httpMethod)
	}
}

func main( ) {
	lambda.Start(handler)
}
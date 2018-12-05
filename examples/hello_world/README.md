# HelloWorld Example

A bare-minimum Lambda function written in Elixir.

## Deployment Instructions

This example is ready to deploy. It needs to be built and bundled:

```
> mix deps.get
> mix do release, bootstrap, zip
```

This creates a file called ```lambda.zip``` in the current directory.
Use the AWS CLI to create the function like so:


```
> aws lambda create-function \
    --region $AWS_REGION \
    --function-name HelloWorld \
    --handler Elixir.HelloWorld:hello_world \
    --role $ROLE_ARN \
    --runtime provided \
    --zip-file fileb://./lambda.zip
```

This requires that you have already set the ```AWS_REGION``` and ```ROLE_ARN```
environment variables. Alternatively, the zip can be used directly in the
AWS Console (just navigate to Lambda and Create Function).

Note that the *handler string* is in the format ```module:function```. Also,
remember that Elixir modules have the ```Elixir.``` prefix to prevent clashes
with Erlang modules.



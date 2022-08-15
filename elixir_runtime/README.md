# AWS Lambda Elixir Runtime

Example implementation of a custom runtime for running Elixir on AWS Lambda.

## Installation

The package can be installed by adding `aws_lambda_elixir_runtime` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aws_lambda_elixir_runtime, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc).

## Step By Step Usage

This section is a step by step for creating the hello world example.

First, create a new mix project in a fresh directory:

```sh
> mix new --app hello_world ./hello_world
```

Now declare a dependency on `:aws_lambda_elixir_runtime`.

Edit `mix.exs`:

```elixir
def deps do
  [
    {:aws_lambda_elixir_runtime, "~> 0.1.0"}
  ]
end
```

Now get the dependencies:

```sh
> mix deps.get
```

The `:aws_lambda_elixir_runtime` has a mix task which will generate files needed
for configuration of a release used to deploy to Lambda. This is a one-time setup
for the project because once generated the file can be versioned and customized
like any other release. Generate the file like so:

```sh
> mix lambda.gen_lambda_release
```

Now the project is ready to be built and deployed -- all that remains is to
actually write a handler function. Open the `lib/hello_world.ex` and edit it
to read:

```elixir
defmodule HelloWorld do

  def hello_world(request, context)
      when is_map(request) and is_map(context) do
    """
    Hello World!
    Request: #{Kernel.inspect(request)}
    Context: #{Kernel.inspect(context)}
    """
    |> IO.puts()

    :ok
  end
end
```

This just defines a single public function in the HelloWorld module. Any
public function can be used to handle Lambda invocations, it just needs to
accept two maps.

Now, the project can be built and zipped:

```sh
> mix do release, lambda.bootstrap, lambda.zip
```

The `release` task is the standard Elixir release operation. The
`lambda.bootstrap` task generates an executable shell script which is called by the
AWS Lambda service to start the Elixir OTP application. And the `lambda.zip` task just
bundles the contents of the release into a single zip file. The `lambda.build` task runs
`mix do deps.get, compile, release, lambda.bootstrap, lambda.zip` in a Docker container
and copies the artifact to a `_build_/<MIX_ENV>/rel/<APP_NAME>/lambda.<ENV>.zip`.
This file can be uploaded to AWS lambda using the AWS console or the
cli. Using the CLI would look like the following:

```sh
> aws lambda create-function \
    --region $AWS_REGION \
    --function-name HelloWorld \
    --handler Elixir.HelloWorld:hello_world \
    --role $ROLE_ARN \
    --runtime provided \
    --zip-file fileb://./_build_/<MIX_ENV>/rel/<APP_NAME>/lambda.<ENV>.zip
```

Once created the function can be invoked from the console, the SDK, or the CLI.
Invoking from the CLI would look like this:

```sh
> aws lambda invoke \
    --function-name HelloWorld \
    --region $AWS_REGION \
    --log-type Tail \
    --payload '{"msg": "a fake request"}' \
    outputfile.txt
...

> cat outputfile.txt
ok
```

The LogResult returns a Base64 Encoded message. When decoded this would have
```
Hello World!
Request: %{ "msg" => "a fake request" }
Context: %{ ... }
```
within it including other log messages.

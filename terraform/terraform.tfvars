environment = "demo"
vpc_id = "vpc-0482f16d6951bd069"
subnet_ids = [ "subnet-06f4ca1c54481a572", "subnet-0bddb6ae3b7ccdd64", "subnet-0da1cbe5d76343391", "subnet-0d8c15ffc5243572b", "subnet-0161172dc66cc876d", "subnet-0ac17865d149efda6" ]
backend_image = "005069959676.dkr.ecr.us-east-1.amazonaws.com/demo:be-latest"
backend_secret = "arn:aws:secretsmanager:us-east-1:005069959676:secret:demo-secrets:MONGO_URI::"
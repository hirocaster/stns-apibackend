# stns-api-backend

stns backend server for AWS api-gateway

## Setup

  1. Copy sample file. `$ cp .envrc.sample .envrc`
  2. Replace config `.envrc`
  3. Load environments `direnv allow` or `bash .envrc`

### If using the S3 remote state

  1. Copy sample file. `$ cp backend.tf.sample backend.tf`
  2. Replace config it. `backend.tf`
  3. Initialize terraform. `$ terraform init`

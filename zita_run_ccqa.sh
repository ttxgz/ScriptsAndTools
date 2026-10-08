##################### NOTICE !!!!!!!!!!!!!!!!! #################################
# NEVER use !/bin/bash here to execute this script ( ./zita_run_test.sh )
# because in this way all exported values are limited to the exec shell, but not passing it to the parant (global) shell
# SHOULD ALWAYS USE source ./zita_run_test.sh so exported env are global

# Sample .profile for my account. You need to customize all these

# rp2/dev
export DLBIO_DEVELOPMENT_USERNAME="zita.liao@dolby.com"
export DLBIO_DEVELOPMENT_PASSWORD="Axxon99zz@"
export DLBIO_DEVELOPMENT_API_SECRET="f77bf7f9b4bdba2bdf1192a2abcc506274574e593f46f74cef04963c77539738"
export DLBIO_DEVELOPMENT_PUBLISH_TOKEN_ID="1882804"
export DLBIO_DEVELOPMENT_PUBLISH_TOKEN="3b3b2b2b9c687a1e9929d0cb321fa1ab1a4a2e6be8a13f3d8c69f19d160abf0b"
export DLBIO_DEVELOPMENT_SUBSCRIBE_TOKEN_ID="564242"
export DLBIO_DEVELOPMENT_SUBSCRIBE_TOKEN="c7be30d1c353d8f84db9015eda7436e6c48f50458babfa13c472f590743d3fab"
export DLBIO_DEVELOPMENT_STREAMID="yaGvHL/zita_ccqa_docker"
export DLBIO_DEVELOPMENT_STREAM_ACCOUNT_ID="yaGvHL"
export DLBIO_DEVELOPMENT_ACCOUNT_ID="25363" # Found from /milli_dev:acc yaGvHL
export DLBIO_DEVELOPMENT_WEBHOOKS_ENDPOINT="zita_ccqa_rp2" # WEBHOOK_ID: 549

# staging
#export DLBIO_STAGING_USERNAME="zita.liao@dolby.com"
#export DLBIO_STAGING_PASSWORD="Axxon99zz@"
#export DLBIO_STAGING_API_SECRET="482c23b68cae1735ee75d82e6b0ccdf3f785a434612bf8999339034d7c0b2dce"
#export DLBIO_STAGING_PUBLISH_TOKEN_ID="2062717"
#export DLBIO_STAGING_PUBLISH_TOKEN="66c1eeb1bf992e9b86b8f3e160fb6d69fc639eab6891e38e60e6ee96429776dd"
#export DLBIO_STAGING_SUBSCRIBE_TOKEN_ID="847551"
#export DLBIO_STAGING_SUBSCRIBE_TOKEN="ca65a66b98644440ce86370464fdc39cd052ba10b4a9c565380bd64f6ff992e9"
#export DLBIO_STAGING_STREAMID="hKH4xW/zita_ccqa_test"
#export DLBIO_STAGING_STREAM_ACCOUNT_ID="hKH4xW"
#export DLBIO_STAGING_ACCOUNT_ID="37717" # Found from /milli_stg:acc hKH4xW
#export DLBIO_STAGING_WEBHOOKS_ENDPOINT="zliao-ccqa-docker-staging" #WEBHOOK_ID:138459

# Account in dolby organization
# todo: export DLBIO_PRODUCTION_USERNAME="brendon.costa@dolby.com"
# todo: export DLBIO_PRODUCTION_PASSWORD="...REDACTED..."
# todo: export DLBIO_PRODUCTION_API_SECRET="119f...REDACTED...688c"
# todo: export DLBIO_PRODUCTION_PUBLISH_TOKEN_ID="13965657"
# todo: export DLBIO_PRODUCTION_PUBLISH_TOKEN="a0f6...REDACTED...94eb"
# todo: export DLBIO_PRODUCTION_SUBSCRIBE_TOKEN_ID="448699"
# todo: export DLBIO_PRODUCTION_SUBSCRIBE_TOKEN="17c1...REDACTED...8e0e"
# todo: export DLBIO_PRODUCTION_STREAMID="MG2zym/ccqa_docker"
# todo: export DLBIO_PRODUCTION_STREAM_ACCOUNT_ID="MG2zym"
# todo: export DLBIO_PRODUCTION_ACCOUNT_ID="104949"
# todo: export DLBIO_PRODUCTION_WEBHOOKS_ENDPOINT="zliao-shared-ccqa-docker"

# @todo ACCOUNT_ID is included in STREAM_ID and there is other redundant information here that must match. We should improve this when we have time

# get from https://dolby.box.com/s/3ud4uv96ci7snxz8j6w7auyb76x8s8b7
export DLBIO_DEVELOPMENT_DIRECTOR_API_PASSWORD="Test1234!"
export DLBIO_STAGING_DIRECTOR_API_PASSWORD="w9vdMWvvy2SyVTYi4fb1V9A0s9YRntM8"
export DLBIO_PRODUCTION_DIRECTOR_API_PASSWORD="fiuXyD2w9gBH4NagndHnbnc3AtNgm43z"

#=======================================================================
# Select which environment to test against: staging, dev
# dev
export DLBIO_TEST_ENVIRONMENT="development"
export WEBHOOK_ID=549
# staging
#export DLBIO_TEST_ENVIRONMENT="staging"
#export WEBHOOK_ID=138459
# prod
#export DLBIO_TEST_ENVIRONMENT="production"
#export WEBHOOK_ID=<your webhook id>

#=======================================================================
# Select which clusters to use for testing against
# fra-1, lon-1, phx-1, syd-1
#export DLBIO_RTS_CLUSTER="fra-1"
#export DLBIO_RTS_CASCADE_CLUSTER="lon-1"
export DLBIO_RTS_CLUSTER="syd-1"
export DLBIO_RTS_CASCADE_CLUSTER="lon-1"

source ./data/api_secrets.env

# re-up the docker to ensure env are passed down
#docker compose down
#docker compose up -d


# run test suite
# rm -rf ./logs
# ./tools/all.sh trial

#!/bin/bash

set -e 

source $X_XTRS_DIR/addons.sh
  
NO_VALUE='no-value'

function _load_envs_with_params() {
  local serviceName=$1
  local prefixPath=$2
  local awsRegion=$3
  local endpoint=$4

  local envs

  Step "service/$serviceName - Load envs with params"
  Log "_load_envs_with_params/args - serviceName  = $serviceName"
  Log "_load_envs_with_params/args - awsRegion    = $awsRegion"
  Log "_load_envs_with_params/args - prefixPath   = $prefixPath"
  Log "_load_envs_with_params/args - endpoint     = $endpoint"

  # Add Endpoint options if required
  if [[ $endpoint != $NO_VALUE ]]; then 
    Task "Setting Endpoint options - Probably in NON-production mode"
    enpoint_opts="--endpoint $endpoint"
    Log "Add endpoint options : $enpoint_opts"
  else
    if [[ $OS_BASE_KEEP_AWS_CREDENTIALS != "true" ]]; then 
      Task "Removing AWS credentials - use role instead"
      rm -rf $HOME/.aws/*
    fi;
    Log "Missing env var OS_SSM_ENDPOINT. Only used when testing!"
  fi;

  
  Step "service/$serviceName - Fetching common envs from SSM at path $prefixPath/$serviceName"
  local cmd="awssel load --export\
          --service-name  $serviceName\
          --prefix-path   $prefixPath\
          --aws-region    $awsRegion\
          $enpoint_opts"

  Log "Execute command : $cmd"
  envs=$($cmd)

  if [[ $? != 0 ]]; then 
    err "Failed to load env vars for '$serviceName'. result: $envs"
  else
    Step "service/$serviceName - Load env vars into the system"
    echo $envs > $OS_TMP/.ssm.envs.loaded
    source $OS_TMP/.ssm.envs.loaded

    Step "service/$serviceName - Clean temp files"
    rm -f $OS_TMP/.ssm.envs.loaded
  fi;

}


if [[ $OS_ENABLE_SSM_ENV_LOADER == "true" ]]; then
  Log "SSM_ENV_LOADER: enabled"

  Step "Checking required args are provided"
  
  : "${OS_SERVICE_NAME:?Need to set OS_SERVICE_NAME - non-empty}"
  : "${OS_SSM_PREFIX_PATH:?Need to set OS_SSM_PREFIX_PATH - non-empty}"
  : "${OS_AWS_REGION:?Need to set OS_AWS_REGION - non-empty}"
  : "${OS_ENV:?Need to set OS_ENV - non-empty}"
  
  endpoint="${OS_SSM_ENDPOINT:-$NO_VALUE}"

  #
  # LOAD COMMON ENV VARS 
  #
  default_common_envs_path="/os/${OS_ENV}/support/it/core/common"
  commonEnvsPath=${OS_SSM_COMMON_ENVS_PREFIX_PATH:-$default_common_envs_path}
  commonService="$(echo ${commonEnvsPath##*/})"
  commonPrefixPath="$(echo ${commonEnvsPath%/*})"

  _load_envs_with_params  "$commonService" "$commonPrefixPath" "$OS_AWS_REGION" "$endpoint"
  Check_errors $?

  #
  # LOAD SERVICE ENV VARS 
  #

  _load_envs_with_params "$OS_SERVICE_NAME" "$OS_SSM_PREFIX_PATH" "$OS_AWS_REGION" "$endpoint"
  Check_errors $?

else
  Log "SSM_ENV_LOADER: disabled"
fi;

Done

Step "Run command $@"
exec "$@"

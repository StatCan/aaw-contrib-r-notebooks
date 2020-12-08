# Source the s3 storage secrets and urls.

get_bash_variable <- function (location, var) {
    system(
        sprintf(
            "bash -c 'source %s; echo $%s'",
            location,
            var
        ),
        intern = TRUE
    )
}

### Just sets the environment variables.
daaas_storage.__getClient__ <- function (storage_type) {

    location = sprintf("/vault/secrets/minio-%s-tenant-1", storage_type)

    MINIO_URL        = get_bash_variable(location, "MINIO_URL")
    MINIO_ACCESS_KEY = get_bash_variable(location, "MINIO_ACCESS_KEY")
    MINIO_SECRET_KEY = get_bash_variable(location, "MINIO_SECRET_KEY")

    ENDPOINT = gsub("https?://", "", MINIO_URL)

    Sys.setenv(
        "AWS_S3_ENDPOINT" =  ENDPOINT,
        "AWS_ACCESS_KEY_ID" = MINIO_ACCESS_KEY,
        "AWS_SECRET_ACCESS_KEY" = MINIO_SECRET_KEY,
        "AWS_DEFAULT_REGION" = ""
    )
}


daaas_storage.standard <- function () {
    daaas_storage.__getClient__("standard")
}

daaas_storage.premium <- function () {
    daaas_storage.__getClient__("premium")
}

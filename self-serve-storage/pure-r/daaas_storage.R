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
daaas_storage.__getClient__<- function(storage_type = c("standard", "premium")) {

    type <- match.arg(storage_type)
    env_vars <- c("MINIO_URL", "MINIO_ACCESS_KEY", "MINIO_SECRET_KEY")
    location <- sprintf("/vault/secrets/minio-%s-tenant-1", type)
    minio <- if (requireNamespace("jsonlite", quietly = TRUE)) {
        # jsonlite is installed on the AAW's R image
        # works just as well with RJSONIO::fromJSON or rjson::fromJSON
        jsonlite::fromJSON(paste0(location, ".json"))
    } else {
        lapply(setNames(nm = env_vars), function(x) {
            system(sprintf("bash -c 'source %s; echo $%s'", location, x), intern = TRUE)
        })
    }
    Sys.setenv(
        "AWS_S3_ENDPOINT" = gsub("https?://", "", minio$MINIO_URL),
        "AWS_ACCESS_KEY_ID" = minio$MINIO_ACCESS_KEY,
        "AWS_SECRET_ACCESS_KEY" = minio$MINIO_SECRET_KEY,
        "AWS_DEFAULT_REGION" = "",
        "SECURE" = startsWith(minio$MINIO_URL, "https")
    )
}
daaas_storage.standard <- function () {
    daaas_storage.__getClient__("standard")
}
daaas_storage.premium <- function () {
    daaas_storage.__getClient__("premium")
}
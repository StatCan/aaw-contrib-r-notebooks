# No SQL Queries from R

You technically can, but it is very complicated in R, and much easier with `mc`. If you want to try it, you can use the `select_object` function from the `aws.s3` R library, and you have to pass the XML description of your S3 Select query as the `request_body`, which looks like this


```xml
<?xml version="1.0" encoding="UTF-8"?>
<SelectObjectContentRequest xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
   <Expression>
      SELECT PopTotal,PopDensity FROM s3object s 
      WHERE s.Location like \'%Canada%\'
   </Expression>
   <ExpressionType>SQL</ExpressionType>
   <InputSerialization>
      <CompressionType>GZIP</CompressionType>
      <CSV>
         <FieldDelimiter>,</FieldDelimiter>
         <FileHeaderInfo>USE</FileHeaderInfo>
         <RecordDelimiter>\\n</RecordDelimiter>
      </CSV>
   </InputSerialization>
   <OutputSerialization>
      <JSON>
      </JSON>
   </OutputSerialization>
</SelectObjectContentRequest>
```


[select_object](https://github.com/cloudyr/aws.s3/issues/224)


By contrast, this is accomplished by `mc` with

```sh
mc sql --json --query "
      SELECT PopTotal,PopDensity FROM s3object s 
      WHERE s.Location like '%Canada%'
" minio-minimal/shared/blair-drummond/sql-example/TotalPopulation.csv.gz | tee query-output.json
```
# Inception Pipeline

The source for the Inception Pipelines blog series!

1. [Seeds of Inception - Seeding your Account with an Inception Pipeline](https://mechanicalrock.github.io/2018/03/01/inception-pipelines-pt1.html)
2. [Seeds of Inception - Sprouting some website goodness](https://mechanicalrock.github.io/2018/04/01/inception-pipelines-pt2.html)
3. [Seeds of Inception - Sharing the website goodness](https://mechanicalrock.github.io/2018/05/18/inception-pipelines-pt3.html)
4. [Seeds of Inception - Seeding a forest](https://mechanicalrock.github.io/2018/06/25/inception-pipelines-pt4.html)
5. [Seeds of Inception - Access all accounts](https://mechanicalrock.github.io/2018/07/31/inception-pipelines-pt5.html)
6. [Seeds of Inception - Initiating the Seeding](https://mechanicalrock.github.io//2018/08/27/inception-pipelines-pt6)
7. [Seeds of Inception - Global CloudTrail](https://mechanicalrock.github.io/2019/07/09/inception-pipelines-pt7.html)

## Notes

When you begin to develop aspects in their own pipelines, you may find there are many cloudformation scripts being used (and thus configuration files). Unfortunately, the format of parameter file read by Codepipeline differs to the format read by Cloudformation. Cloudformation parameter files can still be useful when you are developing new Cloudformation scripts to include in your pipeline.

We have included a simple filter script, ``to-cfn-params.sh`` that uses ``jq`` to transform from Codepipeline parameters to Cloudformation, allowing you to maintain one parameter file and generate the Cloudformation one on the fly.

### Examples

 ***Given the following Codepipeline parameter file***
 ```
 {
     "Parameters" : {
         "TemporaryRoleName: "roleProdAccountDevops",
         "KmsKeyArn" : "arn:aws:kms:eu-west-1:01234556789:key/abc000000000-1234-1234-1234"
    }
}
```
***When we run pipe the file through the filter script***

``` $ cat codepipeline-params.json | to-cfn-params.sh ```

***Then we will see Cloudformation parameters output***
```
[
  {
    "ParameterKey": "TemporaryRoleName",
    "ParameterValue": "roleProdAccountDevops"
  },
  {
    "ParameterKey": "KmsKeyArn",
    "ParameterValue": "arn:aws:kms:eu-west-1:01234556789:key/abc000000000-1234-1234-1234"
  }
]
```

So to write your existing parameter file to a new Cloudformation parameter file, you might call

```
$ to-cfn-params.sh < codepipeline-params.json > code-pipeline-params-cli.json
```

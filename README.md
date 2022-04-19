# Lines of Code Reporter

Calculates and publishes lines of code report in GitHub Actions as Checksuite.

### Note:- The scope of this project is limited to Calculating lines of code and publishing report.
###  If you like my Github Action, please **STAR ⭐** it.

## Samples


Calculates and publishes lines of code report in GitHub Actions as Checksuite.
Here's a quick example of how to use this action in your own GitHub Workflows.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    
      # generates coverage-report.md and publishes as checkrun
      - name: JaCoCo Code Coverage Report
        id: lines-of-code_reporter
        uses: PavanMudigonda/lines-of-code_reporter@v0.0.1
        with:
          directory: ./
          github_token: ${{ secrets.GITHUB_TOKEN }}
                    
```


### Inputs

This Action defines the following formal inputs.

| Name | Req | Description
|-|-|-|
|**`directory`**  | true | Directory where lines of code needs to be calculated. 
|**`github_token`** | true | Input the GITHUB TOKEN Or Personal Access Token you would like to use. Recommended to use GitHub auto generated token ${{ secrets.GITHUB_TOKEN }}
|**`skip_check_run`** | false | If true, will skip attaching the Coverage Result report to the Workflow Run using a Check Run. 
|**`patterns`**  | true | file patterns that need to be considered for calculation
|**`exclude_directory`**  | true | directories that need to be excluded
|**`exclude_file_types`**  | true | file types that need to be excluded


### Outputs

This Action defines the following formal outputs.

| Name | Description
|-|-|
| **`loc_report`** | Lines of Code Report output
| **`total_lines`** | Total Code Lines output

### Sample Screenshot
### Sample Repo 

https://github.com/PavanMudigonda/jacoco-playground

### Sample Github Actions workflow 

https://github.com/PavanMudigonda/jacoco-playground/blob/main/.github/workflows/lines-of-code.yml


### PowerShell GitHub Action

This Action is implemented as a [PowerShell GitHub Action](https://github.com/ebekker/pwsh-github-action-base).

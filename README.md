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
    
      - name: use this action, with existing test results
        id: lines-of-code-reporter
        uses: PavanMudigonda/lines-of-code-reporter@v1.2
        with:
          directory: ./
          github_token: ${{ secrets.GITHUB_TOKEN }}
          skip_check_run: false
          
      - name: print output
        shell: pwsh
        run: | 
          Write-Host 'Total Lines of Code...:  ${{ steps.lines-of-code-reporter.outputs.total_lines }}'
          Write-Host 'Lines of Code Markdown Report Path...:  ${{ steps.lines-of-code-reporter.outputs.loc_report }}' 
                    
```


### Inputs

This Action defines the following formal inputs.

| Name | Req | Description
|-|-|-|
|**`directory`**  | true | Directory where lines of code needs to be calculated. 
|**`github_token`** | true | Input the GITHUB TOKEN Or Personal Access Token you would like to use. Recommended to use GitHub auto generated token ${{ secrets.GITHUB_TOKEN }}
|**`skip_check_run`** | false | If true, will skip attaching the Coverage Result report to the Workflow Run using a Check Run. 
<!-- |**`exclude_dir`**  | false | directories that need to be excluded
|**`exclude_lang`**  | false | file types that need to be excluded
 -->

### Outputs

This Action defines the following formal outputs.

| Name | Description
|-|-|
| **`loc_report`** | Lines of Code Report output
| **`total_lines`** | Total Code Lines output

### Sample Screenshot

<img width="881" alt="image" src="https://user-images.githubusercontent.com/86745613/164104335-2aec8669-9d15-4fc4-9517-35b4b8ba1f30.png">


<img width="1013" alt="image" src="https://user-images.githubusercontent.com/86745613/164104559-9a27a09d-6abc-4a6e-96d0-e2decd00dff2.png">


### Sample Github Actions workflow 

https://github.com/PavanMudigonda/lines-of-code-reporter/blob/main/.github/workflows/main.yml


### PowerShell GitHub Action

This Action is implemented as a [PowerShell GitHub Action](https://github.com/ebekker/pwsh-github-action-base).

# CCP2_NF

A Nextflow wrapper for CirComPara2

## Usage

Copy the `config/nextflow.config` file into you project directory.  

Modify the nextflow.config file to add custom volumes to the Docker run line:  
```bash
runOptions = '-u $(id -u):$(id -g) -v /blackhole:/blackhole -v /sharedfs01:/sharedfs01 -v /sharedfs00:/sharedfs00'
```

Run with nextflow:  
```bash
nextflow run /path/to/ccp2_nf/scripts/main.nf --metafile=meta.csv --varsfile=/path/to/ccp2_project_dir/vars.py
```

NB: the meta.csv file must be declared into the vars.py

```python
META = 'meta.csv'
```

Use the combine_ccp2_runs() function from the ccp2tools package to merge the samples' output.  

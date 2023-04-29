process writeMeta {
  
  debug true
  input:
    tuple val(sample_id), path(readPair), val(adapter)
  
  output:
    path "meta.csv", emit: meta
    tuple val(sample_id), path("${readPair[0]}"), path("${readPair[1]}"), emit: inputFiles
    
  exec:
    metafile = task.workDir.resolve("meta.csv")
    //for reads in readPairs:
    //  line = "sample,file,adapter\n${sample_id},${reads}"
    //  if adapter != null:
    //    line = line + ",${adapter}"
    //  line = line + "\n"
    //metafile.text = line
    metafile.text = "sample,file,adapter\n${sample_id},${readPair[0]},${adapter}\n${sample_id},${readPair[1]},${adapter}\n"

}

process readVars {
  
  debug true
  
  input:
    path varsfile
    
  output:
    val parameters
    
  script:
    """
    echo "${varsfile.basename}"
    """
}

process runCCP2 {
  
  debug true
  
  input:
    path metafile
    path varsfile
    tuple val(sample_id), path(reads1), path(reads2)
    val params
    
  output:
    path "circular_expression/circrna_analyze/reliable_circexp.csv"
  
  script:
    """
    circompara2 $params
    """
    
}

process runCCP2 {
  
  debug true
  
  input:
    path metafile
    val varsfile
    val params
    
  output:
    path "reliable.csv"
  
  script:
    """
    touch reliable.csv
    echo "circompara2 $params $metafile $varsfile"
    """
    
}

process writeMeta {
  
  debug true
  input:
    tuple val(sample_id), path(readPair), val(adapter)
  
  output:
    path "meta.csv", emit: meta
    
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

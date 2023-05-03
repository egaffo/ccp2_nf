process writeMeta {
  
  debug false
  
  input:
    tuple val(sample_id), val(readPair), val(adapter)
  
  output:
    path "meta.csv", emit: meta
    tuple val(sample_id), val("${readPair[0]}"), val("${readPair[1]}"), emit: inputFiles
    val sample_id, emit: sample_id
  
  exec:
    metafile = task.workDir.resolve("meta.csv")
    metafile.text = "sample,file,adapter\n${sample_id},${readPair[0]},${adapter}\n${sample_id},${readPair[1]},${adapter}\n"
}

process readVars {
  
  debug false
  
  input:
    path in_varsfile
    
  output:
    path "vars.py", emit: vars
    
  /* TODO:
     scan the parameters from the vars.py file. The variables refering to files
     or directories, such as the genome indexes, genome FASTA, gene annotations, 
     etc., must be checked if they exist and passed as output files. In this way,
     they will be linked into the task's directory.
  */
  
  script:
  """
  echo "vars.py copied"
  """
}

process runCCP2 {
  
  debug false
  publishDir "$sample_id", mode: "move"
  
  input:
    tuple path(meta), path(vars)
    val sample_id
    val ccp2params
    
  output:
    path "circular_expression"
    path "linear_expression"
    path "read_statistics"
    path "samples"
    path "ccp2.err"
    path "ccp2.log"
    path "meta.csv"
    path "vars.py"
    path "dbs"
  
  shell:
    """
    circompara2 $ccp2params 2> ccp2.err > ccp2.log
    rm -r '?'
    """
    
}
